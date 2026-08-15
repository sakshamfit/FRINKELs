# sanitize.md - Cleans and Standardizes Note Formatting

## Purpose
Cleans up and standardizes the formatting of notes in your knowledge base, ensuring consistent styling, proper linking, and adherence to your preferred conventions.

## Triggers
- "sanitize this note"
- "clean up formatting"
- "standardize note"
- "fix formatting"
- "make consistent"

## Dependencies
References your style guides and may link to templates for standardization guidance.

## Instructions
1. **Assess Current Formatting**: Evaluate the note for formatting inconsistencies, styling issues, and convention violations
2. **Standardize Headings**: Ensure proper heading hierarchy and formatting
3. **Fix Linking**: Ensure wiki-style links are correct and descriptive anchor text is used appropriately
4. **Standardize Lists**: Ensure consistent list formatting (indentation, markers, spacing)
5. **Clean Code Blocks**: Ensure proper syntax highlighting and formatting
6. **Standardize Emphasis**: Ensure consistent use of bold/italic for emphasis
7. **Fix Spacing**: Ensure consistent spacing around elements, paragraphs, and sections
8. **Apply Tag Standards**: Ensure tags follow your preferred format (lowercase, no spaces, etc.)
9. **Remove Extraneous Whitespace**: Clean up trailing spaces, excessive blank lines
10. **Ensure Template Adherence**: If using a known template, ensure compliance

## Output
- List of formatting issues found with line references
- Specific corrections suggested for each issue
- Before/after examples for major changes
- Overall assessment (needs light/medium/heavy sanitizing)
- Estimated effort to complete sanitizing
- Links to relevant style guides or templates

## Example
**Input**: A note with inconsistent formatting

**Issues Found**:
1. **Inconsistent Heading Levels**: 
   - Line 5: Uses `##` for subsection when `###` is appropriate
   - Line 12: Skips heading level (goes from `##` to `####`)
2. **Inconsistent Linking**:
   - Line 8: Uses `[text](file.md)` instead of wiki-style `[[file.md]]`
   - Line 15: Wiki-style link lacks descriptive text when beneficial: `[[FEATURE-INDEX.md]]` 
3. **Inconsistent Lists**:
   - Line 20: Uses dashes for list items when asterisks are preferred
   - Line 25: Inconsistent indentation in nested list
4. **Inconsistent Emphasis**:
   - Line 30: Uses `__bold__` instead of `**bold**`
   - Line 35: Mixes *italic* and _underline_ for emphasis
5. **Inconsistent Tags**:
   - Frontmatter: Uses `#Feature` when lowercase `#feature` is standard
   - Line 40: Inline tag `#UI-Component` when `#ui-component` is preferred

**Suggested Corrections**:
1. **Fix Heading Hierarchy**:
   - Line 5: Change `## Subsection` to `### Subsection`
   - Line 12: Insert `### Missing Level` between `##` and `####`
2. **Standardize Linking**:
   - Line 8: Change `[Auth Docs](03-Features/AUTHENTICATION.md)` to `[[03-Features/AUTHENTICATION.md|Authentication Documentation]]`
   - Line 15: Change `[[FEATURE-INDEX.md]]` to `[[FEATURE-INDEX.md|Feature Overview]]`
3. **Fix List Consistency**:
   - Line 20: Change `- Item` to `* Item` (or vice versa based on preference)
   - Line 25: Standardize nested list indentation to 2 spaces
4. **Standardize Emphasis**:
   - Line 30: Change `__bold text__` to `**bold text**`
   - Line 35: Standardize on *italic* for emphasis, remove _underline_
5. **Fix Tag Formatting**:
   - Frontmatter: Change `#Feature` to `#feature`
   - Line 40: Change `#UI-Component` to `#ui-component`

## How to Use
When you want to clean and standardize a note's formatting:
1. Invoke this skill with: "sanitize: [paste the note content or describe the note to clean]"
2. Optionally specify formatting preferences: "sanitize: [content] - prefer asterisks for lists"
3. Review the formatting issues and suggested corrections
4. Apply the corrections to standardize the note
5. Consider linking to relevant style guides for future reference

## Integration with Other Skills
- Works with **knowledge-organizer** to file sanitized notes appropriately
- Connects to **link-weaver** to find link opportunities after sanitizing
- Informs **harmonize** by ensuring consistent formatting doesn't mask substantive conflicts
- Connects to **collator** for collecting sanitization reports
- Use with **quick-append** to add content to sanitized notes
- Connects to **cascade** for breaking down sanitization into steps
- Links to **creation-janitor** for validating new notes before sanitizing