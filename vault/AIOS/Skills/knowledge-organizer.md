# knowledge-organizer - Automatically Organizes New Notes

## Purpose
Automatically organizes new notes into appropriate directories based on content analysis and existing knowledge base structure.

## Triggers
- "organize knowledge"
- "categorize notes" 
- "file new note"
- "where should this go"

## Dependencies
None - works by analyzing note content against existing directory structure and file names.

## Instructions
1. **Analyze Input**: Examine the content of the note to be organized
2. **Identify Keywords**: Extract key terms, technologies, features, and concepts
3. **Match to Structure**: Compare keywords against directory names and index files
4. **Suggest Location**: Recommend the most appropriate directory and filename
5. **Provide Reasoning**: Explain why the suggested location is appropriate
6. **Offer Alternatives**: Suggest secondary options if multiple locations fit
7. **Check for Duplicates**: Warn if similar content already exists

## Output
- Primary location recommendation with path and reasoning
- 1-2 alternative locations if applicable
- Duplication warnings if similar content exists
- Suggested tags based on content analysis

## Example
**Input**: A note about implementing Google OAuth authentication in the FRINKELS app

**Primary Suggestion**: 
`03-Features/AUTHENTICATION.md` 
*Reason: Contains detailed authentication implementation, matches existing AUTHENTICATION.md feature file*

**Alternative**: 
`03-Features/AI-KITTU-ASSISTANT.md` (if focused on AI-powered auth)
*Reason: Could relate to AI-enhanced authentication features*

**Tags**: `#authentication #google-oauth #security #implementation`

**Duplication Check**: Similar content found in `03-Features/AUTHENTICATION.md#oauth-providers` - consider updating existing section instead.

## How to Use
When you have a new note or content fragment that needs filing:
1. Invoke this skill with: "organize knowledge: [paste your content]"
2. Review the suggested location and reasoning
3. Decide whether to create new file or update existing one
4. Follow the suggested path and naming conventions