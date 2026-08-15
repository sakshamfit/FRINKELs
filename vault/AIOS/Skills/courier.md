# courier.md - Delivers and Shares Knowledge from Your Vault

## Purpose
Handles the delivery, sharing, and export of knowledge from your vault to external systems, people, or formats, ensuring your insights reach where they're needed while maintaining proper attribution and context.

## Triggers
- "share this knowledge"
- "export notes"
- "courier: [what to share]"
- "send to [person/system]"
- "deliver knowledge"

## Dependencies
Works with your knowledge base content and may link to external sharing mechanisms (email, messaging, export formats).

## Instructions
1. **Identify Content to Share**: Determine what knowledge, notes, or insights need to be delivered
2. **Assess Recipient Needs**: Understand who will receive the information and what format they need
3. **Preserve Context**: Ensure shared content maintains necessary context, links, and attributions
4. **Choose Delivery Method**: Select appropriate format and mechanism (email, export, link sharing, etc.)
5. **Prepare Package**: Format the content for delivery (preserving links, adding summaries, etc.)
6. **Add Metadata**: Include source information, timestamps, and relevant tags
7. **Suggest Delivery**: Recommend how and where to send the knowledge
8. **Track Delivery**: Note what was shared, when, and to whom for future reference

## Output
- Recommended format for sharing the knowledge
- Prepared content package with metadata
- Suggested delivery mechanisms and recipients
- Attribution and source information to include
- Links to related knowledge that should accompany the share
- Tracking suggestion for what was shared

## Example
**Input**: "courier: share my authentication system knowledge with the backend team"

**Output**:
```
# Knowledge Share: FRINKELS Authentication System

## 📦 Content to Share
- `03-Features/AUTHENTICATION.md` - Complete feature spec
- `lib/features/auth/presentation/controllers/auth_controller.dart` - State management implementation
- `lib/features/auth/data/datasource/clerk_auth_remote_data_source.dart` - API integration
- `vault/AIOS/Skills/error-decoder.md` examples - Relevant auth error patterns

## 👥 Recipient Analysis
**Backend Team Needs**:
- Understanding of auth flow for API integration
- Information on token handling and security considerations
- Details about user data flow and storage
- Error handling patterns to anticipate

## 📋 Delivery Preparation
### Format Options
1. **Linked Knowledge Bundle**: Share links with context (best for Obsidian users)
2. **Export Bundle**: PDF or markdown export of key documents
3. **Summary Document**: Concise overview with links to full details
4. **Presentation Format**: Slides or meeting notes format

### Recommended Approach
Create a knowledge bundle that includes:
1. Executive summary (2-3 paragraphs)
2. Key implementation details (technical team)
3. API integration points (backend team)
4. Error handling patterns (support team)
5. Links to full documentation for deep dives

### Content to Include
```
# FRINKELS Authentication System - Knowledge Share

## 🔐 Overview
FRINKELS uses Clerk for authentication, migrated from Supabase in August 2026. Supports email/password, Google OAuth, and Resend password reset flows.

## 🧩 Key Implementation Points
- **State Management**: Clerk user flow listener updates StateNotifier (auth_controller.dart)
- **Provider Configuration**: Clerk setup in clerk_auth_remote_data_source.dart
- **API Integration**: Requires Firebase options for Flutter Clerk SDK
- **User Flows**: Handles new account creation, account linking, and error cases

## 🔗 Backend Integration Points
- Token verification endpoints (if custom validation needed)
- User data synchronization (profile updates from Clerk)
- Webhook handling for Clerk events (optional)
- Password reset flow coordination with Resend service

## ⚠️ Important Considerations
- **Security**: JWT tokens handled by Clerk, minimal custom token handling
- **Error Patterns**: See vault/AIOS/Skills/error-decoder.md for auth-specific troubleshooting
- **Migration Notes**: Full migration history available in git commits bac0c35 → 5df4af1
- **Testing**: Authentication controller has associated unit tests

## 📚 Related Knowledge
- [[03-Features/JOBS.md]] - User profiles and authentication connection
- [[04-Backend/SECURITY-REPORT.md]] - Security considerations
- [[lib/firebase_options.dart]] - Firebase configuration requirements

## 📤 Suggested Delivery Methods
1. **For Obsidian Users**: Share this note with links intact
2. **For General Consumption**: Export as PDF or formatted markdown
3. **For Technical Deep Dive**: Share individual source files with this summary
4. **For Meeting Presentation**: Convert to slide deck using the outlined sections

## 🏷️ Tracking Metadata
- **Shared**: 2026-08-15
- **Recipient**: Backend Team
- **Content ID**: auth-system-share-2026-08-15
- **Tags**: #knowledge-share #authentication #backend-team
```

## How to Use
When you want to share knowledge from your vault:
1. Invoke this skill with: "courier: [describe what knowledge to share and to whom if known]"
2. Optionally specify format: "courier: [content] - format: [email/export/summary/etc.]"
3. Review the prepared knowledge package and delivery suggestions
4. Share the knowledge using your preferred mechanism
5. Consider tracking what was shared for future reference
6. Link back to the original knowledge in your vault for context

## Integration with Other Skills
- Works with **knowledge-organizer** to file courier suggestions appropriately
- Connects to **link-weaver** to find opportunities to link shared knowledge
- Informs **harmonize** by ensuring shared knowledge is consistent and up-to-date
- Connects to **collator** for collecting related information to share
- Use with **quick-append** to add sharing notes to existing documentation
- Connects to **cascade** for breaking down large knowledge sharing projects
- Links to **verbatim** for preserving exact text to be shared
- Works with **summarizer** to create concise versions for sharing