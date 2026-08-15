# harmonize - Resolves Conflicts and Inconsistencies in Knowledge

## Purpose
Identifies and resolves conflicts, inconsistencies, or contradictory information in your knowledge base, ensuring your notes present a coherent and accurate view of your understanding.

## Triggers
- "resolve conflicts"
- "harmonize knowledge"
- "inconsistent information"
- "contradicting notes"
- "check for conflicts"

## Dependencies
Works across multiple notes in your knowledge base and may link to style guides for consistency standards.

## Instructions
1. **Scan for Conflicts**: Compare notes on similar topics for contradictory statements, differing definitions, or conflicting advice
2. **Identify Inconsistencies**: Find variations in terminology, formatting, or approaches that create confusion
3. **Assess Context**: Understand when different information might be valid (different times, contexts, or assumptions)
4. **Determine Resolution**: Decide how to reconcile differences (update, clarify, contextualize, or note evolution)
5. **Suggest Actions**: Recommend specific edits, additions, or linking strategies to resolve conflicts
6. **Document Decisions**: Record why certain resolutions were chosen for future reference

## Types of Conflicts Addressed

### 📝 Factual Conflicts
- Direct contradictions in information (X says A, Y says not-A)
- Outdated information vs current understanding
- Conflicting data points or statistics
- Different definitions of the same term

### 🔧 Procedural Conflicts
- Contradictory steps or approaches to the same task
- Different recommendations for similar situations
- Inconsistent best practices or guidelines
- Conflicting tool or technology recommendations

### 🏷️ Structural Conflicts
- Inconsistent naming conventions or taxonomy
- Different categorization systems for similar content
- Conflicting tagging approaches
- Inconsistent linking patterns

### 📚 Stylistic Conflicts
- Varying levels of technical detail for similar topics
- Different formatting or presentation styles
- Conflicting tone or voice in similar documents
- Inconsistent use of examples or code snippets

## Output
- List of identified conflicts with:
  - Conflicting notes and specific contradictions
  - Contextual notes (when each might be valid)
  - Suggested resolution approach
  - Priority/impact rating (High/Medium/Low)
- Recommended actions for each conflict
- Suggested linking or contextualization strategies
- Documentation of decisions made

## Example
**Input**: Two notes about authentication state management in FRINKELS

**Note 1** (`03-Features/AUTHENTICATION.md`):
"FRINKELS uses Supabase for authentication state management with a custom StateNotifier provider that listens to auth state changes."

**Note 2** (`lib/features/auth/presentation/controllers/auth_controller.dart`):
"The authentication state is managed using Clerk's user flow listener that updates a StateNotifier provider."

**Analysis**:
- **Conflict**: Different authentication systems mentioned (Supabase vs Clerk)
- **Context**: Note 1 appears to be outdated documentation; Note 2 reflects current implementation
- **Resolution**: Update AUTHENTICATION.md to reflect Clerk migration, add note about migration date
- **Action**: Revise AUTHENTICATION.md section, add [[MIGRATION-NOTES.md]] link

**Output**:
```
# Conflict Resolution: Authentication System Documentation

## 📄 Conflicting Notes
1. `03-Features/AUTHENTICATION.md`: Section on "State Management"
   - States: "FRINKELS uses Supabase for authentication state management..."
   
2. `lib/features/auth/presentation/controllers/auth_controller.dart`: Lines 22-30
   - Shows: Clerk user flow listener updating StateNotifier

## 🔍 Conflict Analysis
- **Type**: Factual conflict (outdated documentation)
- **Context**: AUTHENTICATION.md appears to be pre-migration documentation
- **Evidence**: Code shows Clerk implementation, git history shows migration commit
- **Impact**: High - could mislead new developers about current system

## 🛠️ Suggested Resolution
1. **Primary Action**: Update AUTHENTICATION.md to reflect Clerk-based implementation
2. **Secondary Action**: Add migration context note
3. **Linking Strategy**: Link from AUTHENTICATION.md to migration documentation

## ✍️ Specific Changes Suggested
In `03-Features/AUTHENTICATION.md`, replace:
```
FRINKELS uses Supabase for authentication state management with a custom StateNotifier provider that listens to auth state changes.
```

With:
```
FRINKELS migrated to Clerk for authentication state management in [Date]. 
The system uses Clerk's user flow listener that updates a StateNotifier provider 
(see `lib/features/auth/presentation/controllers/auth_controller.dart`).
See [[MIGRATION-NOTES-from-Supabase-to-Clerk.md]] for migration details.
```

## 🏷️ Suggested Tags
#conflict-resolution #authentication #documentation #FRINKELS-migration

## How to Use
When you want to check for and resolve inconsistencies:
1. Invoke this skill with: "harmonize: [describe what to check or specific notes to compare]"
2. Optionally specify scope: "harmonize: [all notes] or harmonize: [specific folder]"
3. Review the identified conflicts and suggested resolutions
4. Implement the recommended changes or adaptations
5. Link notes appropriately to show evolution or context
6. Document resolutions for future reference

## Integration with Other Skills
- Works with **knowledge-organizer** to file resolved notes appropriately
- Connects to **link-weaver** to find opportunities to link clarified concepts
- Informs **doc-generator** by providing clean source material for templates
- Connects to **verbatim** for preserving exact conflicting text
- Use with **rock-tumbler** to refine the resolution documentation
- Connects to **collator** for collecting related conflict resolutions