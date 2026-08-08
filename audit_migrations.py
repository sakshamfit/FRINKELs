#!/usr/bin/env python3
"""
Audit script for FRINKELs Supabase migrations.
Analyzes migration dependencies and checks for ordering issues.
"""

import re
import os
from collections import defaultdict

# Define the migrations directory
MIGRATIONS_DIR = r'supabase/migrations'

# List of migration files sorted by name (which should be timestamp order)
migration_files = sorted([
    f for f in os.listdir(MIGRATIONS_DIR)
    if f.endswith('.sql')
])

print(f"Found {len(migration_files)} migration files:")
for f in migration_files:
    print(f"  {f}")

# We'll store for each migration:
#   objects_created: set of object identifiers (type, schema, name)
#   objects_referenced: set of object identifiers that are referenced
# We'll also store the raw SQL for debugging if needed.

# Object types we care about:
#   TABLE: ('table', 'schema', 'name')
#   TYPE:  ('type', 'schema', 'name')  # for ENUMs
#   FUNCTION: ('function', 'schema', 'name')
#   VIEW: ('view', 'schema', 'name')
#   STORAGE BUCKET: ('storage', 'bucket', 'name')
#   POLICY: we don't store the policy itself isolate the policy object, but we note the table it depends on
#   PUBLICATION: we don't store the publication object, but we note the tables it publishes

# We'll also note foreign key references: REFERENCES schema.table(column)

# Patterns for object creation - now with corrected regex to capture schema and name
# Pattern: CREATE [OR REPLACE] OBJECT_TYPE [IF NOT EXISTS] [schema.]name
# We allow optional quotes around schema and name, and optional schema (default to public if missing)

# Helper pattern for optional quotes and word
_QUOTED_WORD = r'(?:[\'"])?(\w+)(?:[\'"])?'

# Table: CREATE TABLE [IF NOT EXISTS] [schema.]name
TABLE_CREATE_RE = re.compile(
    r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?'  # optional IF NOT EXISTS
    r'(?:' + _QUOTED_WORD + r'\s*\.\s*)?'         # optional schema with dot (group1: schema)
    r'' + _QUOTED_WORD,                            # name (group2: name, or group1 if no schema)
    re.IGNORECASE
)

# Type: CREATE TYPE [IF NOT EXISTS] [schema.]name AS ENUM
TYPE_CREATE_RE = re.compile(
    r'CREATE\s+TYPE\s+(?:IF\s+NOT\s+EXISTS\s+)?'   # optional IF NOT EXISTS
    r'(?:' + _QUOTED_WORD + r'\s*\.\s*)?'         # optional schema with dot (group1: schema)
    r'' + _QUOTED_WORD + r'\s+AS\s+ENUM',         # name (group2: name, or group1 if no schema) and AS ENUM
    re.IGNORECASE
)

# Function: CREATE [OR REPLACE] FUNCTION [schema.]name(
FUNCTION_CREATE_RE = re.compile(
    r'CREATE\s+(?:OR\s+REPLACE\s+)?FUNCTION\s+'    # optional OR REPLACE
    r'(?:' + _QUOTED_WORD + r'\s*\.\s*)?'         # optional schema with dot (group1: schema)
    r'' + _QUOTED_WORD + r'\s*\(',                # name (group2: name, or group1 if no schema) and opening paren
    re.IGNORECASE
)

# View: CREATE VIEW [IF NOT EXISTS] [schema.]name AS
VIEW_CREATE_RE = re.compile(
    r'CREATE\s+VIEW\s+(?:IF\s+NOT\s+EXISTS\s+)?'   # optional IF NOT EXISTS
    r'(?:' + _QUOTED_WORD + r'\s*\.\s*)?'         # optional schema with dot (group1: schema)
    r'' + _QUOTED_WORD + r'\s+AS',                # name (group2: name, or group1 if no schema)
    re.IGNORECASE
)

# Storage bucket: INSERT INTO storage.buckets (id, name, ...) VALUES ('bucket_id', ...)
STORAGE_BUCKET_INSERT_RE = re.compile(
    r"INSERT\s+INTO\s+storage\.buckets\s*\([^)]*\)\s*VALUES\s*\([^']*'([^']+)'",
    re.IGNORECASE
)

# Policy: CREATE POLICY policy_name ON schema.table FOR ...
POLICY_CREATE_RE = re.compile(
    r'CREATE\s+POLICY\s+(?:' + _QUOTED_WORD + r')\s+ON\s+'  # policy name (group1)
    r'(?:\'?\"?(\w+)\'?\"?\s*\.\s*)'                       # schema (group2) with quotes and dot
    r'(\w+)\s+FOR',                                         # table name (group3)
    re.IGNORECASE
)

# Publication: CREATE PUBLICATION pubname FOR TABLE table1, table2, ...
PUBLICATION_CREATE_RE = re.compile(
    r'CREATE\s+PUBLICATION\s+(?:' + _QUOTED_WORD + r')\s+FOR\s+TABLE\s+(.+)',  # pub name (group1), then table list
    re.IGNORECASE
)

# Foreign key: REFERENCES [schema.]table(column)
FK_REF_RE = re.compile(
    r'REFERENCES\s+(?:\'?\"?(\w+)\'?\"?\s*\.\s*)?'  # optional schema with quotes and dot (group1: schema)
    r'(\w+)\s*\(',                                  # table name (group2: name, or group1 if no schema)
    re.IGNORECASE
)

# We'll store for each migration index (0-based) the sets of created and referenced objects.

class MigrationAudit:
    def __init__(self):
        self.migrations = []  # list of dicts for each migration file
        self.objects_defined = defaultdict(int)  # (type, schema, name) -> migration_index where first defined
        self.objects_referenced = defaultdict(set)  # (type, schema, name) -> set of migration_indices where referenced

    def _parse_schema_and_name(self, match, default_schema='public'):
        """Helper to extract schema and name from regex match.
        Assumes the pattern has two groups:
          group1: schema (if present, else None)
          group2: name (if schema present, else the name)
        If schema is present (group1 not None), then name is group2.
        If schema is not present (group1 is None), then name is group1?
        Actually, looking at our patterns, when schema is optional and not present,
        the first group (schema) is None and the second group (name) is the actual name.
        But wait: in the pattern for TABLE_CREATE_RE, we have:
          (?: _QUOTED_WORD \s* \. \s* )?   -> group1: schema (if present)
          _QUOTED_WORD                     -> group2: name
        So if the optional group is not present, group1 is None and group2 is the name.
        If the optional group is present, group1 is the schema and group2 is the name.
        Therefore, in both cases, the name is in group2.
        The schema is group1 if present, else default_schema.
        """
        schema = match.group(1)
        name = match.group(2)
        if schema is None:
            schema = default_schema
        return schema, name

    def parse_migration(self, index, filename):
        path = os.path.join(MIGRATIONS_DIR, filename)
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()

        created = set()
        referenced = set()

        # Find table creations
        for match in TABLE_CREATE_RE.finditer(content):
            schema, name = self._parse_schema_and_name(match)
            created.add(('table', schema, name))

        # Find type creations (ENUM)
        for match in TYPE_CREATE_RE.finditer(content):
            schema, name = self._parse_schema_and_name(match)
            created.add(('type', schema, name))

        # Find function creations
        for match in FUNCTION_CREATE_RE.finditer(content):
            schema, name = self._parse_schema_and_name(match)
            created.add(('function', schema, name))

        # Find view creations
        for match in VIEW_CREATE_RE.finditer(content):
            schema, name = self._parse_schema_and_name(match)
            created.add(('view', schema, name))

        # Find storage bucket inserts
        for match in STORAGE_BUCKET_INSERT_RE.finditer(content):
            bucket_name = match.group(1)
            created.add(('storage', 'bucket', bucket_name))

        # Find policy creations
        for match in POLICY_CREATE_RE.finditer(content):
            # Policy name is group1 (quoted word), schema is group2, table name is group3
            policy_name = match.group(1)  # not used for dependency, but we could store it
            schema = match.group(2)
            table_name = match.group(3)
            # The policy depends on the table, so we'll add a reference to the table.
            referenced.add(('table', schema, table_name))

        # Find publication creations
        for match in PUBLICATION_CREATE_RE.finditer(content):
            pub_name = match.group(1)  # not used for dependency
            tables_string = match.group(2)
            # Parse the table list: could be comma separated, possibly with schema
            for table_ref in tables_string.split(','):
                table_ref = table_ref.strip()
                # Remove quotes and spaces
                table_ref = re.sub(r'[\'\"]', '', table_ref)
                # Could be schema.table or just table
                if '.' in table_ref:
                    schema, table_name = table_ref.split('.', 1)
                else:
                    schema = 'public'
                    table_name = table_ref
                referenced.add(('table', schema, table_name))

        # Find foreign key references
        for match in FK_REF_RE.finditer(content):
            schema = match.group(1)
            table_name = match.group(2)
            if schema is None:
                schema = 'public'
            referenced.add(('table', schema, table_name))

        # Store
        self.migrations.append({
            'file': filename,
            'created': created,
            'referenced': referenced,
            'raw_content': content[:500]  # first 500 chars for debugging
        })

        # Update global tracking
        for obj in created:
            if obj not in self.objects_defined:
                self.objects_defined[obj] = index
            # If already defined in an earlier migration, we note it's a re-creation (but we have IF NOT EXISTS, so it's ok)

        for obj in referenced:
            self.objects_referenced[obj].add(index)

    def audit(self):
        print("\n=== AUDIT RESULTS ===\n")

        # First, parse all migrations
        for idx, fname in enumerate(migration_files):
            self.parse_migration(idx, fname)

        # Check for references to objects that are not defined in the same or earlier migration
        errors = []
        warnings = []

        # Define schemas that are considered external (managed by Supabase, not our migrations)
        external_schemas = {'auth', 'storage'}

        for obj, ref_migrations in self.objects_referenced.items():
            obj_type, schema, name = obj
            # Skip if the object is in an external schema (we assume it exists)
            if schema in external_schemas:
                continue
            if obj in self.objects_defined:
                first_def = self.objects_defined[obj]
                for ref_mig in ref_migrations:
                    if ref_mig < first_def:
                        errors.append(f"Object {obj} referenced in migration {migration_files[ref_mig]} (index {ref_mig}) but first defined in migration {migration_files[first_def]} (index {first_def})")
            else:
                errors.append(f"Object {obj} is referenced but never defined in any migration")

        # Check for objects defined but never referenced (not necessarily an error, but could be dead code)
        for obj, def_migration in self.objects_defined.items():
            obj_type, schema, name = obj
            if schema in external_schemas:
                continue
            if obj not in self.objects_referenced:
                warnings.append(f"Object {obj} defined in migration {migration_files[def_migration]} (index {def_migration}) but never referenced")

        # Print errors
        if errors:
            print("ERRORS (dependency violations):")
            for err in errors:
                print("  - " + err)
        else:
            print("NO DEPENDENCY ERRORS FOUND")

        # Print warnings
        if warnings:
            print("\nWARNINGS (objects defined but not referenced):")
            for warn in warnings:
                print("  - " + warn)
        else:
            print("\nNO WARNINGS")

        # Print migration summary
        print("\n=== MIGRATION SUMMARY ===")
        for idx, m in enumerate(self.migrations):
            print(f"\nMigration {idx}: {m['file']}")
            print(f"  Creates: {len(m['created'])} objects")
            for obj in sorted(m['created']):
                print(f"    + {obj[0]} {obj[1]}.{obj[2]}")
            print(f"  References: {len(m['referenced'])} objects")
            for obj in sorted(m['referenced']):
                print(f"    -> {obj[0]} {obj[1]}.{obj[2]}")

        # Return True if no errors
        return len(errors) == 0

if __name__ == '__main__':
    auditor = MigrationAudit()
    success = auditor.audit()
    exit(0 if success else 1)