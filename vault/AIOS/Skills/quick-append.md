# quick-append - Adds Content to Existing Notes

## Purpose
Provides a structured way to add new information, insights, or updates to existing notes in your knowledge base without overwriting or losing the original content.

## Triggers
- "add to note"
- "append information"
- "quick append"
- "update note"
- "add insight"

## Dependencies
Works with existing notes and can link to knowledge-organizer for finding the right note.

## Instructions
1. **Identify Target Note**: Determine which note should receive the addition (via path, content analysis, or user specification)
2. **Assess Addition Type**: Determine what kind of content is being added (insight, update, correction, example, etc.)
3. **Preserve Existing Structure**: Ensure the addition fits within the note's current format and style
4. **Add Content**: Insert the new information in the most appropriate location
5. **Maintain Flow**: Ensure the addition doesn't disrupt the note's readability or logical progression
6. **Update Metadata**: Modify timestamps, tags, or frontmatter if needed
7. **Suggest Linking**: Recommend connections to other related notes that might now be relevant

## Output
- Suggested location for the addition within the target note
- The formatted content to be added
- Explanation of why this location is appropriate
- Any suggested structural adjustments to the note
- Updated tags or metadata recommendations
- Links to related notes that might now be relevant due to the addition

## Example
**Input**: "quick-append: add insight about Google OAuth error handling to AUTHENTICATION.md"

**Output**:
```
# Quick Append Suggestion

## 📄 Target Note
`03-Features/AUTHENTICATION.md`

## 📍 Suggested Location
In the "Google OAuth" subsection under "Implementation Details", after the callback handling section.

## ✏️ Content to Add
### 🔐 Error Handling Considerations
- **Network Errors**: Implement retry mechanisms with exponential backoff for token exchange failures
- **Popup Blockers**: Detect when sign-in popups are blocked and provide user-friendly instructions
- **Token Expiry**: Handle expired tokens gracefully by triggering re-authentication flow
- **User Cancellation**: Provide clear feedback when users cancel the sign-in process
- **Domain Mismatch**: Validate redirect URIs match Clerk configuration to prevent silent failures

## 💡 Rationale for Location
This addition belongs in the Google OAuth implementation details because:
1. It directly addresses runtime considerations for the OAuth flow
2. It complements the existing callback handling section
3. It maintains the subsection's focus on implementation specifics
4. It follows the note's pattern of including "considerations" subsections

## 🏷️ Tag Updates
Consider adding: `#error-handling #oauth-considerations`

## 🔗 New Linking Opportunities
After this addition, consider linking to:
- [[04-Backend/ERROR-HANDLING-GUIDE.md]] (if exists)
- [[vault/AIOS/Skills/error-decoder.md]] for OAuth-specific error patterns
- [[lib/features/auth/presentation/controllers/auth_controller.dart]] where error handling is implemented
```

## How to Use
When you want to add information to an existing note:
1. Invoke this skill with: "quick-append: [describe what to add and to which note if known]"
2. If the target note isn't specified, the skill may suggest candidates using knowledge-organizer principles
3. Review the suggested location and content to add
4. Add the content to the note at the suggested location
5. Consider any structural updates or tag changes recommended
6. Link to newly related notes as suggested

## Integration with Other Skills
- Works with **knowledge-organizer** to find appropriate notes for appending
- Connects to **verbatim** for preserving exact text to be appended
- Informs **summarizer** by providing source material for summarization
- Connects to **collator** for collecting related appendices
- Use with **sanitize** to ensure proper formatting and linking
- Links to **link-weaver** to find new connection opportunities after appending