# link-weaver - Finds Opportunities to Link Related Notes

## Purpose
Identifies opportunities to create links between existing notes in the knowledge base to strengthen connections and improve discoverability.

## Triggers
- "find connections"
- "link related notes"
- "weave knowledge graph"
- "what should this link to"

## Dependencies
None - analyzes existing note content and titles to find semantic relationships.

## Instructions
1. **Scan Target Note**: Examine the content of the note to find linking opportunities for
2. **Extract Concepts**: Identify key terms, technologies, features, people, and concepts mentioned
3. **Search Knowledge Base**: Look for existing notes that contain similar or related concepts
4. **Evaluate Relevance**: Score potential links based on conceptual overlap and contextual fit
5. **Prioritize Links**: Rank suggestions by strength of connection and usefulness
6. **Provide Context**: Explain why each suggested link is valuable
7. **Check Existing Links**: Avoid suggesting links that already exist
8. **Suggest Anchor Text**: Recommend appropriate text to use for the link

## Output
- List of suggested links with:
  - Target note path
  - Suggested anchor text
  - Explanation of the connection
  - Strength rating (Strong/Medium/Weak)
- Duplication warnings for existing links
- Alternative link suggestions

## Example
**Input**: A note about implementing JWT token refresh in the authentication service

**Suggested Links**:
1. `[[03-Features/AUTHENTICATION.md#token-management]]` (Strong)
   *Explanation: Directly relates to the authentication token handling section*
   
2. `[[02-Architecture/STATE-MANAGEMENT.md#async-patterns]]` (Medium)
   *Explanation: Token refresh involves async state management patterns*
   
3. `[[04-Backend/SECURITY-REPORT.md#token-security]]` (Strong)
   *Explanation: Covers security best practices for handling authentication tokens*

**Existing Link Check**: No existing links to these sections found in the input note.

**Anchor Text Suggestions**:
- "token management practices" → AUTHENTICATION.md
- "async state handling" → STATE-MANAGEMENT.md
- "token security considerations" → SECURITY-REPORT.md

## How to Use
When you want to improve the connectivity of a note:
1. Invoke this skill with: "link-weaver: [paste note content or file path]"
2. Review the suggested links and explanations
3. Add the most relevant links to your note using Obsidian's link syntax
4. Consider the strength ratings when prioritizing which links to add