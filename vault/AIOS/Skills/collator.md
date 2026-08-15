# collator.md - Collects and Organizes Related Information

## Purpose
Gathers related information from across your knowledge base on a specific topic, theme, or project and organizes it into a coherent collection for easy reference and synthesis.

## Triggers
- "collect on topic"
- "gather information about"
- "collator: [topic]"
- "organize related notes"
- "bring together information"

## Dependencies
Works across your entire knowledge base or specified sections to find related content.

## Instructions
1. **Define Collection Scope**: Determine what topic, theme, or project to collect information on
2. **Scan Knowledge Base**: Search for notes, snippets, and information related to the scope
3. **Assess Relevance**: Evaluate each piece of information for relevance to the topic
4. **Organize Collection**: Structure the collected information logically (by type, chronology, importance, etc.)
5. **Identify Gaps**: Notice what information is missing or underrepresented
6. **Suggest Connections**: Recommend links between items in the collection
7. **Propose Output Format**: Recommend how to present the collection (note, MOC, etc.)
8. **Preserve Attribution**: Maintain source references for all collected information

## Output
- Collected information organized logically
- Source references for each item
- Identified gaps in coverage
- Suggested internal links within the collection
- Recommended format for the final collection
- Metadata about the collection process

## Example
**Input**: "collator: collect information on FRINKELS authentication system"

**Output**:
```
# Collection: FRINKELS Authentication System

## 📊 Collection Overview
- **Source Notes Scanned**: 47 notes from vault/
- **Relevant Items Found**: 12 distinct pieces of information
- **Date Range**: March 2026 - August 2026 (covers migration period)
- **Collection Format**: Organized by type and chronology

## 🔐 Authentication System Collection

### 1. 📚 Feature Specifications & Documentation
- `03-Features/AUTHENTICATION.md` (updated Aug 10, 2026)
  - Complete feature spec covering email/password, Google OAuth, Resend flows
  - Includes migration notes from Supabase to Clerk
  
- `vault/AIOS/Skills/doc-generator.md` (template used for AUTHENTICATION.md)
  - Shows the template structure used for this feature specification

### 2. 💻 Implementation Code
- `lib/features/auth/presentation/controllers/auth_controller.dart`
  - Clerk user flow listener updating StateNotifier (lines 22-30)
  - Authentication state management implementation
  
- `lib/features/auth/data/datasource/clerk_auth_remote_data_source.dart`
  - Clerk initialization and API calls
  - Provider configuration for different auth methods

### 3. ⚙️ Configuration & Setup
- `lib/firebase_options.dart`
  - Firebase configuration required for Flutter Clerk SDK
  
- `.env.example` (shows required environment variables)
  - CLERK_PUBLISHABLE_KEY
  - Optional: Custom provider configuration

### 4. 🧪 Testing & Validation
- `test/auth/auth_controller_test.dart` (if exists)
  - Unit tests for authentication state changes
  
- `vault/AIOS/Skills/error-decoder.md` examples
  - Includes StateError: setState() called after dispose() example relevant to auth

### 5. 📝 Migration & Transition Notes
- Git commit history: `bac0c35` to `5df4af1`
  - Shows migration from Supabase to Clerk
  - Firebase initialization added alongside Clerk

### 6. 🔗 Related Systems & Integration Points
- `03-Features/JOBS.md`
  - User profiles and authentication connection
  
- `04-Backend/SECURITY-REPORT.md`
  - Security considerations for authentication systems
  
- `lib/features/home/presentation/screens/home_screen.dart`
  - Conditional Sentry debug button (auth-related monitoring)

## 🎯 Collection Organization
This collection is organized by:
1. **Documentation Level** (specifications → implementation → configuration)
2. **Chronology** (shows migration progression)
3. **System Layer** (frontend → backend → configuration)

## 🔍 Identified Gaps
- **User Experience Flow**: No detailed flow diagrams for auth process
- **Error Handling Guide**: No centralized document for auth-specific error patterns
- **Testing Coverage**: Unclear what percentage of auth logic is tested
- **Performance Considerations**: No notes on auth performance optimization

## 💡 Suggested Connections Within Collection
- Link `AUTHENTICATION.md` error handling section to `error-decoder.md` examples
- Connect `clerk_auth_remote_data_source.dart` to Firebase configuration notes
- Link JWT token handling mentions to security report
- Connect auth controller to home screen conditional monitoring features

## 📄 Recommended Output Format
For this collection, consider creating:
1. **Authentication MOC** (`03-Features/AUTH-MOC.md`)
   - Central hub linking to all authentication-related materials
   
2. **Detailed Migration Document** (`02-Architecture/AUTH-MIGRATION.md`)
   - Chronological history of the auth system evolution
   
3. **Authentication Cheat Sheet** (`01-Reference/AUTH-CHEAT-SHEET.md`)
   - Quick reference for common auth operations and troubleshooting

## How to Use
When you want to collect and organize information on a topic:
1. Invoke this skill with: "collator: [topic or theme to collect on]"
2. Optionally specify scope: "collator: [topic] - scope: [specific folders or exclude folders]"
3. Review the collected information and organization suggestions
4. Decide on the final format for your collection (note, MOC, etc.)
5. Create the collection following the suggested organization
6. Link the collection appropriately in your knowledge base
7. Consider setting up a process to update the collection periodically

## Integration with Other Skills
- Works with **knowledge-organizer** to file collections appropriately
- Connects to **link-weaver** to find opportunities to link collected items
- Informs **harmonize** by revealing inconsistencies in collected information
- Connects to **verbatin** for preserving exact text from sources
- Use with **quick-append** to add collected information to existing notes
- Connects to **cascade** for breaking down large collection projects into steps