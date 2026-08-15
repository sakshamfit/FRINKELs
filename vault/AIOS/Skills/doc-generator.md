# doc-generator - Creates Standardized Documentation Templates

## Purpose
Generates standardized documentation templates for features, APIs, architecture decisions, or other knowledge base content following FRINKELS conventions.

## Triggers
- "create doc"
- "generate documentation"
- "write spec"
- "new feature doc"
- "template for"

## Dependencies
None - works with predefined templates and user input.

## Instructions
1. **Determine Doc Type**: Identify what type of documentation is needed (feature, API, architecture, etc.)
2. **Select Template**: Choose the appropriate template based on doc type
3. **Gather Information**: Ask targeted questions to fill in template sections
4. **Fill Template**: Populate the template with user-provided information
5. **Apply Conventions**: Ensure formatting follows FRINKELS standards (headings, code snippets, links)
6. **Suggest Location**: Recommend where to save the generated documentation
7. **Provide Next Steps**: Suggest what to do after creating the doc (linking, updating indexes, etc.)

## Templates Available

### Feature Specification Template
```
# [Feature Name] - [Brief Description]

**Maintained by**: [Team/Person]
**Target Repository**: FRINKELS (Flutter + Supabase Platform)
**Status**: [Planned/In Progress/Completed/Deprecated]

---

## 🎯 Overview
[High-level description of what the feature does and why it exists]

## 🔧 Technical Implementation
### Architecture
- [Where this feature fits in the clean architecture]
- [Key classes, widgets, providers involved]
- [Data flow description]

### State Management
- [Riverpod providers used]
- [State objects and their relationships]
- [Async handling patterns]

### UI Components
- [Key widgets/screens created]
- [Reused components]
- [Custom UI elements]

### Data & Storage
- [Database tables/collections used]
- [Supabase/Firebase services involved]
- [RLS policies if applicable]
- [Caching strategies]

### Integration Points
- [How this feature connects to other features]
- [APIs consumed or exposed]
- [Events published/subscribed]

## ⚙️ Configuration & Setup
### Environment Variables
- [Required env vars and their purpose]

### Feature Flags
- [Any flags controlling rollout]

### Permissions & Access
- [Required user roles/permissions]
- [Supabase policies]
- [Client-side access checks]

## 🧪 Testing Strategy
### Unit Tests
- [What needs unit testing]
- [Mocking strategies]

### Widget Tests
- [Key widgets to test]
- [Golden test candidates]

### Integration Tests
- [User flows to test]
- [Edge cases to cover]

## 📝 API Reference (if applicable)
### Endpoints
- [List of API endpoints with methods]

### Data Models
- [Request/response structures]

### Error Handling
- [Error codes and messages]

## 🔒 Security Considerations
- [Authentication requirements]
- [Authorization checks]
- [Data protection measures]
- [Input validation]

## 📈 Performance Notes
- [Expected load characteristics]
- [Optimization opportunities]
- [Monitoring metrics]

## 📚 Related Documentation
- [Links to related feature docs]
- [Architecture decisions]
- [API specifications]
- [UX/UI guidelines]

## 📋 Changelog
### [Date] - [Version]
- [Initial implementation or changes]
```

### API Documentation Template
```
# [API Name] - [Brief Description]

**Maintained by**: [Team/Person]
**Target Repository**: FRINKELS Backend
**Version**: [API Version]
**Last Updated**: [Date]

---

## 📖 Overview
[What this API does and who consumes it]

## 🔐 Authentication
- [Auth method required (JWT, API key, etc.)]
- [Token acquisition process]
- [Token expiration and refresh]

## 🌐 Base URL
```
[Base URL for all endpoints]
```

## 🛣️ Endpoints

### [HTTP Method] [Endpoint Path]
**Purpose**: [Brief description of what this endpoint does]

**Parameters**:
- [Path parameters] (if any)
- [Query parameters] (if any)
- [Request body] (if applicable)

**Request Example**:
```json
{
  // Example request payload
}
```

**Response Example** (Success):
```json
{
  // Example successful response
}
```

**Response Example** (Error):
```json
{
  // Example error response
}
```

**Error Codes**:
- [HTTP Status Code]: [Error description]
- [HTTP Status Code]: [Error description]

**Rate Limiting**:
- [Requests per time period]
- [How limits are applied]

## 📊 Data Models
### [Model Name]
**Purpose**: [What this model represents]

**Fields**:
- [field_name]: [type] - [description]
  - Constraints: [validation rules]
  - Example: [example value]

### [Additional Models as needed]

## 🔒 Security
- [Transport security (HTTPS)]
- [Authentication mechanisms]
- [Authorization checks per endpoint]
- [Input validation and sanitization]
- [Output encoding]

## ⚙️ Configuration
- [Environment-specific settings]
- [Feature flags]
- [Third-party service integrations]

## 🧪 Testing
- [Test suites available]
- [How to run tests]
- [Coverage requirements]

## 📚 Related Documentation
- [Links to API specification files]
- [SDK documentation]
- [Integration guides]
- [Security policies]
```

### Architecture Decision Record (ADR) Template
```
# [ADR Number] - [Title of Decision]

**Status**: [Proposed/Accepted/Deprecated/Superseded]
**Date**: [YYYY-MM-DD]
**Deciders**: [List of decision makers]
**Consulted**: [List of consulted parties]

---

## 📝 Context and Problem Statement
[What is the issue that we're trying to address? This should include relevant background, constraints, and assumptions.]

## 🎯 Decision Drivers
- [Driver 1]: [explanation] 
- [Driver 2]: [explanation]
  - [Optional: weighting or priority]

## 💡 Considered Options
### [Option 1]
[Description of option 1]
- **Good**: [Why this option fulfills the drivers]
- **Bad**: [Why this option does not fully fulfill the drivers]

### [Option 2]
[Description of option 2]
- **Good**: [Why this option fulfills the drivers]
- **Bad**: [Why this option does not fully fulfill the drivers]

### [Option 3] (Current State)
[Description of current situation]
- **Good**: [Why this option fulfills the drivers]
- **Bad**: [Why this option does not fully fulfill the drivers]

## 🤝 Decision Outcome
[Chosen option]: [Option 1 or 2 or 3 or a custom option], because [justification]. 
[Additional explanation if needed.]

## ✅ Consequences
### Good
- [Positive consequence 1]
- [Positive consequence 2]
  - [Optional: elaboration]

### Bad
- [Negative consequence 1]
- [Negative consequence 2]
  - [Optional: elaboration]

### Neutral
- [Neutral consequence 1]
- [Neutral consequence 2]
  - [Optional: elaboration]

## 🔗 Related Decisions
- [List of related ADRs with links and brief explanation of relationship]

## 📚 Related Documentation
- [Links to relevant architecture docs]
- [Feature specifications impacted]
- [Code changes or tickets]

## 📋 Notes
[Any additional information that doesn't fit elsewhere but is relevant to the decision]
```

## Output
- Complete documentation file following the selected template
- Suggested file path based on doc type and naming conventions
- List of sections that still need information (if any)
- Recommendations for next steps (linking, updating indexes, etc.)

## Example
**Input**: "create doc: feature spec for Google OAuth authentication"

**Process**:
1. Identifies as feature specification doc
2. Selects Feature Specification Template
3. Asks targeted questions about:
   - Feature name and description
   - Maintainer and target repository
   - Current status
   - Technical implementation details
   - State management approach
   - UI components involved
   - Data and storage considerations
   - Integration points
   - Configuration requirements
   - Testing strategy
   - Security considerations
   - Performance notes
   - Related documentation
4. Generates complete feature spec with placeholders for user to fill
5. Suggests saving to: `03-Features/AUTHENTICATION.md` (if updating existing) or creates new section
6. Recommends updating `FEATURE-INDEX.md` and linking from relevant architecture docs

## How to Use
When you need to create standardized documentation:
1. Invoke this skill with: "create doc: [description of what you need]"
2. Answer the guided questions to fill in the template
3. Review the generated documentation
4. Save to the suggested location or adjust as needed
5. Follow the suggested next steps for integration into your knowledge base