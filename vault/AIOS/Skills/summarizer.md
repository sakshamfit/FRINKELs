# summarizer - Creates Concise Summaries of Longer Content

## Purpose
Takes longer documents, notes, or content and creates concise summaries that capture the key points, insights, and action items while preserving the essential meaning.

## Triggers
- "summarize this"
- "tl;dr"
- "give me the summary"
- "summarizer: [content]"
- "what are the key points"

## Dependencies
Works with any text content and can link to original sources for reference.

## Instructions
1. **Assess Input**: Review the content to be summarized (document, notes, conversation, etc.)
2. **Identify Key Points**: Extract main ideas, important facts, conclusions, and action items
3. **Determine Essence**: Determine what must be preserved to maintain the content's value
4. **Create Summary**: Write a concise version that preserves key information
5. **Preserve Structure**: Maintain logical flow and relationships between ideas
6. **Suggest Length**: Offer options for different summary lengths (brief, medium, detailed)
7. **Link Back**: Provide reference to original content for deeper exploration

## Output
- Concise summary capturing key points and essential information
- Indication of what was omitted (if significant)
- Suggested summary lengths (brief/medium/detailed)
- Links to original content for reference
- Tags suggesting topics covered
- Usage suggestions for the summary

## Example
**Input**: A detailed feature specification for Google OAuth authentication (1000+ words)

**Brief Summary (2-3 sentences)**:
```
Google OAuth integration using Clerk enables users to sign in with Google accounts in FRINKELS. Implementation involves provider configuration in Clerk dashboard, frontend integration with Google Sign-In buttons, callback handling through Clerk SDK, and user flow management for new/existing accounts. Documentation updates in AUTHENTICATION.md cover setup, user experience, and troubleshooting.
```

**Medium Summary (1 paragraph)**:
```
The Google OAuth authentication feature integrates Clerk's managed OAuth service to allow FRINKELS users to sign in with their Google accounts. Implementation requires configuring the Google OAuth provider in the Clerk dashboard with authorized domains and redirect URIs, adding Google Sign-In buttons to authentication screens using Clerk's Prebuilt components, handling OAuth callbacks through Clerk's automatic redirect management and token exchange via the Clerk SDK, and managing user flows for both new account creation and existing account linking. The feature includes comprehensive error handling for common failure scenarios like network errors, popup blockers, and user cancellation. Documentation updates to AUTHENTICATION.md detail the implementation steps, user experience flow, security considerations, testing procedures, and troubleshooting guides for common issues like domain mismatches and authentication failures.
```

**Detailed Summary (2-3 paragraphs)**:
```
[Would include most of the original content with some condensation and removal of redundant examples while preserving all key technical details, decision rationales, and actionable information]
```

## How to Use
When you want a summary of longer content:
1. Invoke this skill with: "summarizer: [paste content or describe what to summarize]"
2. Optionally specify desired length: "summarizer: [content] - brief/medium/detailed"
3. Review the generated summary for accuracy and completeness
4. Use the summary for quick reference, sharing, or decision making
5. Link back to original content when deeper exploration is needed
6. Consider saving summaries as their own notes with links to sources

## Integration with Other Skills
- Works with **verbatim** to create summaries of captured exact text
- Connects to **knowledge-organizer** for filing summaries appropriately
- Links to **quick-append** for adding summaries to existing documentation
- Informs **link-weaver** by providing condensed content for connection analysis
- Connects to **collator** for collecting related summaries
- Use with **sanitize** to ensure proper formatting and linking