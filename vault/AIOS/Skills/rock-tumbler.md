# rock-tumbler.md - Iteratively Improves and Polishes Notes

## Purpose
Takes rough notes or ideas and iteratively refines them through multiple passes to improve clarity, structure, and value, similar to how a rock tumbler smooths rough stones.

## Triggers
- "polish this note"
- "refine ideas"
- "improve documentation"
- "tumble this thought"
- "make this better"

## Dependencies
Works with existing notes and can link to style guides for refinement guidance.

## Instructions
1. **Assess Rough State**: Evaluate the current note for roughness (unclear thoughts, poor structure, missing elements)
2. **First Pass - Structure**: Organize the content with clear headings, logical flow, and basic formatting
3. **Second Pass - Clarity**: Refine language, remove jargon, improve explanations, add examples where needed
4. **Third Pass - Value**: Ensure the note provides clear value, actionable insights, or useful information
5. **Fourth Pass - Polish**: Apply style preferences, check linking, add tags, final formatting
6. **Iterate as Needed**: Repeat passes until the note meets your quality standards
7. **Compare Versions**: Show before/after or explain improvements made

## The Tumbling Process

### 🪨 Pass 1: Rough Shaping (Structure)
- Identify main topic and purpose
- Create clear heading hierarchy (##, ###, etc.)
- Group related ideas into sections
- Add basic formatting (lists, bold for key terms)
- Ensure logical flow from introduction to conclusion

### 💎 Pass 2: Smoothing (Clarity)
- Replace vague terms with specific language
- Explain acronyms and technical terms on first use
- Add concrete examples for abstract concepts
- Improve sentence structure for readability
- Ensure each paragraph has a clear point

### ✨ Pass 3: Faceting (Value)
- Clearly state what the reader gains from this note
- Add actionable insights or clear next steps
- Include relevant links to related knowledge
- Ensure the note answers "why should I care?"
- Link to source materials or references when appropriate

### 🌟 Pass 4: Shine (Polish)
- Apply your preferred writing style (from style-guide-writing-me.md)
- Check for and add relevant wiki-style links
- Suggest and add appropriate tags
- Ensure consistent formatting and spacing
- Review for Obsidian-friendly formatting

## Output
- Description of improvements made at each pass
- Before/after comparison (if showing both versions)
- Final polished version of the note
- Suggested tags for the improved note
- Links to related notes that could be added
- Quality assessment (clarity, structure, value, polish)

## Example
**Input**: A rough note about implementing Google OAuth in FRINKELS

**Pass 1 - Structure**:
```
# Google OAuth Implementation

## Overview
Adding Google OAuth to FRINKELS auth system

## Details
Need to use Clerk for Google OAuth
Will involve setting up provider
Need to handle callbacks
Should update documentation
```

**Pass 2 - Clarity**:
```
# Google OAuth Integration in FRINKELS Authentication System

## Overview
This note outlines the implementation of Google OAuth authentication using Clerk in the FRINKELS Flutter application.

## Implementation Details
- **Provider Configuration**: Setting up Google OAuth provider in Clerk dashboard
- **Frontend Integration**: Adding Google Sign-In button to authentication screens
- **Callback Handling**: Managing OAuth redirects and token exchange
- **User Flow**: Processing successful authentication and error cases
- **Documentation**: Updating AUTHENTICATION.md with Google OAuth specifics
```

**Pass 3 - Value**:
```
# Google OAuth Integration in FRINKELS Authentication System

## Overview
This note outlines the implementation of Google OAuth authentication using Clerk in the FRINKELS Flutter application, enabling users to sign in with their Google accounts.

## Why This Matters
- **User Convenience**: Reduces friction for users who prefer Google authentication
- **Security**: Leverages Google's robust authentication infrastructure
- **Development Efficiency**: Uses Clerk's managed OAuth flows reducing custom implementation
- **Analytics**: Enables tracking of authentication method usage

## Implementation Details
- **Provider Configuration**: Setting up Google OAuth provider in Clerk dashboard with authorized domains and redirect URIs
- **Frontend Integration**: Adding Google Sign-In button using Firebase UI or custom implementation with Google Sign-In package
- **Callback Handling**: Managing OAuth redirects through Clerk's universal link handling and token exchange via Clerk SDK
- **User Flow**: Processing successful authentication (account linking/new user creation) and handling error cases (cancelled sign-ins, network errors)
- **Documentation**: Updating AUTHENTICATION.md with Google OAuth specifics including setup steps, user experience flow, and troubleshooting common issues
```

**Pass 4 - Polish**:
```
# Google OAuth Integration in FRINKELS Authentication System

## Overview
This note outlines the implementation of Google OAuth authentication using Clerk in the FRINKELS Flutter application, enabling users to sign in with their Google accounts.

## Why This Matters
- **User Convenience**: Reduces friction for users who prefer Google authentication
- **Security**: Leverages Google's robust authentication infrastructure with industry-standard OAuth 2.0
- **Development Efficiency**: Uses Clerk's managed OAuth flows, eliminating custom token handling and reducing security surface area
- **Analytics & Growth**: Enables tracking of authentication method usage for product decisions and marketing insights

## Implementation Details

### 🔧 Provider Configuration
- Setting up Google OAuth provider in Clerk dashboard
- Configuring authorized domains (localhost for dev, production domain for prod)
- Setting redirect URIs to match Clerk's expected callback patterns
- Enabling required OAuth scopes (profile, email)

### 📱 Frontend Integration
- Adding Google Sign-In button to authentication screens using Clerk's Prebuilt components
- Ensuring consistent glassmorphism styling with existing auth buttons
- Implementing responsive design for mobile and web platforms
- Adding loading states and error handling for sign-in flow

### 🔄 Callback Handling
- Leveraging Clerk's automatic redirect handling for OAuth flows
- Managing token exchange through Clerk SDK's auth state listeners
- Handling edge cases: popup blockers, network failures, user cancellation
- Ensuring secure state management during redirect process

### 👥 User Flow
- **New Users**: Account creation with Google profile data, email verification prompts
- **Existing Users**: Account linking to existing email/password or other provider accounts
- **Error Handling**: Graceful degradation with clear user messages for common failure scenarios
- **Post-Auth**: Redirect to appropriate onboarding or home screen based on user state

### 📚 Documentation
- Updating AUTHENTICATION.md with Google OAuth specifics including:
  - Setup steps for Clerk dashboard configuration
  - User experience flow diagrams
  - Troubleshooting common issues (domain mismatches, popup blockers)
  - Testing procedures for development and production environments
  - Security considerations and data handling practices

## 🏷️ Suggested Tags
#authentication #google-oauth #clerk #implementation #FRINKELS

## 🔗 Related Notes to Consider Linking
- [[03-Features/AUTHENTICATION.md]] - Main authentication feature specification
- [[lib/features/auth/presentation/controllers/auth_controller.dart]] - Auth state management
- [[style-guide-writing-me.md]] - Personal writing preferences applied in this note
```

## How to Use
When you want to refine a rough note or idea:
1. Invoke this skill with: "rock-tumbler: [paste your rough note or describe the idea to refine]"
2. The skill will guide you through multiple refinement passes
3. Review the improvements suggested at each stage
4. Apply the refinements iteratively until satisfied with the result
5. Save the polished note and consider linking it to related knowledge