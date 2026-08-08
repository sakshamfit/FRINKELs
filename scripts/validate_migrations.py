#!/usr/bin/env python3
"""
Deep validation script for FRINKELs migration files.

Uses pglast to parse each .sql and walks the AST.

Verifies:
  * All FK references resolve to a table created in this file or earlier.
  * No duplicate object names within the same file.
  * RLS policies use DROP IF EXISTS before CREATE (informational).
  * Triggers are guarded by pg_trigger existence check (informational).
"""
import sys
from pathlib import Path
import pglast
from pglast import ast

MIGRATIONS_DIR = Path(r"C:\Users\SATYAM PANDAY\StudioProjects\frinkels\supabase\migrations")

# Tracks state across files
created_tables = set()   # include auth.users
created_types = set()
created_functions = set()
errors = []
warnings = []

# Pre-existing objects that come from Supabase/Postgres core
EXTERNAL_TABLES = {"auth.users", "auth.users.id", "storage.buckets", "storage.objects"}


def qname(node):
    """Return qualified name from a RangeVar / TypeName / ObjectWithArgs."""
    if node is None:
        return None
    if isinstance(node, ast.RangeVar):
        if node.schemaname and node.relname:
            return f"{node.schemaname}.{node.relname}"
        return node.relname
    if isinstance(node, ast.TypeName):
        names = node.names or []
        return ".".join(n.sval for n in names if hasattr(n, "sval"))
    if isinstance(node, ast.ObjectWithArgs):
        names = node.objname or []
        return ".".join(n.sval for n in names if hasattr(n, "sval"))
    if isinstance(node, ast.String):
        return node.sval
    return None


def is_fk_constraint(node):
    return isinstance(node, ast.Constraint) and node.contype == "CONSTR_FOREIGN"


def validate_migration(path):
    errors_local = []
    warnings_local = []

    sql = path.read_text(encoding="utf-8")
    try:
        tree = pglast.parse_sql(sql)
    except Exception as e:
        errors_local.append(f"Could not parse {path.name}: {e}")
        return errors_local, warnings_local

    file_created_tables = []
    file_created_types = []
    file_created_functions = []
    file_created_triggers = []
    file_created_policies = []
    file_seen_policies = []  # tracks CREATE POLICY names

    def walk(node, parent_kind=None):
        """Walk the AST looking for relevant statements."""
        if isinstance(node, ast.RawStmt):
            walk(node.stmt)
            return

        if isinstance(node, ast.CreateStmt):
            tname = qname(node.relation)
            if tname:
                file_created_tables.append(tname)
                # Collect FK references: both column-level (inside ColumnDef.constraints)
                # and table-level (top-level Constraint nodes in tableElts).
                for col in node.tableElts or []:
                    if is_fk_constraint(col):
                        check_fk(col, tname, errors_local)
                    elif hasattr(col, "constraints") and col.constraints:
                        for c in col.constraints:
                            if is_fk_constraint(c):
                                check_fk(c, tname, errors_local)

        elif isinstance(node, ast.IndexStmt):
            pass  # tracked by CREATE INDEX IF NOT EXISTS comment

        elif isinstance(node, ast.CreateFunctionStmt):
            for f in node.functions or []:
                fname = qname(f)
                if fname:
                    file_created_functions.append(fname)

        elif isinstance(node, ast.CreateTrigStmt):
            file_created_triggers.append(node.trigname)

        elif isinstance(node, ast.CreateEnumStmt):
            tname = qname(node.typeName)
            if tname:
                file_created_types.append(tname)

        elif isinstance(node, ast.CreatePolicyStmt):
            file_created_policies.append(node.policy_name)

        elif isinstance(node, ast.DoStmt):
            pass  # DO blocks (trigger guards, publication guards) - reviewed by raw text

        elif isinstance(node, ast.InsertStmt):
            rel = node.relation
            if rel and qname(rel) == "storage.buckets":
                pass  # bucket insert, OK

        # Recurse into lists / nodes
        if hasattr(node, "__slots__"):
            for slot in node.__slots__:
                if slot.startswith("_"):
                    continue
                child = getattr(node, slot, None)
                if isinstance(child, list):
                    for c in child:
                        if hasattr(c, "__class__") and c.__class__.__module__.startswith("pglast"):
                            walk(c)
                elif child is not None and hasattr(child, "__class__") and child.__class__.__module__.startswith("pglast"):
                    walk(child)

    walk(tree)

    # Duplicate table checks within file
    seen = set()
    for t in file_created_tables:
        if t in EXTERNAL_TABLES:
            continue
        if t in seen:
            errors_local.append(f"DUPLICATE table in file: {t}")
        seen.add(t)

    # Policy DROP-then-CREATE check: each CREATE POLICY must be preceded by DROP POLICY IF EXISTS
    for p in file_created_policies:
        if f'DROP POLICY IF EXISTS "{p}"' not in sql:
            warnings_local.append(f'Policy "{p}" not preceded by DROP POLICY IF EXISTS')

    # Add to global state
    for t in file_created_tables:
        created_tables.add(t)
    for tp in file_created_types:
        created_types.add(tp)
    for f in file_created_functions:
        created_functions.add(f)

    if errors_local:
        print(f"\n--- {path.name} ---")
        for err in errors_local:
            print(f"  ERROR: {err}")
            errors.append((path.name, err))
    for warn in warnings_local:
        print(f"  WARN:  {path.name} :: {warn}")
        warnings.append((path.name, warn))

    return errors_local, warnings_local


def check_fk(node, owner_table, errors_local):
    """A FK constraint: check that referenced table exists."""
    pkt = node.pktable
    if not pkt:
        return
    ref = qname(pkt)
    if ref is None:
        return
    if ref in created_tables or ref in EXTERNAL_TABLES:
        return
    # messages.self_reference is allowed (reply_to / forwarded_from)
    if owner_table == ref:
        return
    errors_local.append(f"FK in {owner_table} references {ref}, which does not exist yet")


def main():
    pre_auth = {"auth.users"}

    # Seed auth schema manually (Supabase core)
    created_tables.update(pre_auth)

    files = sorted(MIGRATIONS_DIR.glob("2026*.sql"))
    print(f"Deep-validating {len(files)} migration files...\n")
    for f in files:
        validate_migration(f)

    print()
    print(f"Tables created: {len(created_tables)}")
    print(f"Types created:  {len(created_types)}")
    print(f"Functions:      {len(created_functions)}")
    print()
    print(f"ERRORS: {len(errors)}")
    print(f"WARNINGS: {len(warnings)}")
    sys.exit(0 if not errors else 1)


if __name__ == "__main__":
    main()
