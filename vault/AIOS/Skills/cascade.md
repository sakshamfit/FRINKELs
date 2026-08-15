# cascade - Breaks Down Large Tasks into Manageable Steps

## Purpose
Takes large, overwhelming tasks or projects and breaks them down into smaller, manageable steps with clear dependencies and progression paths.

## Triggers
- "break this down"
- "cascade: [large task]"
- "how to approach"
- "step by step plan"
- "decompose task"

## Dependencies
Works with your knowledge base to understand similar tasks and may reference project planning documents.

## Instructions
1. **Assess the Large Task**: Understand the scope, goals, and requirements of the large task
2. **Identify Natural Breakpoints**: Find logical places to split the task (phases, components, milestones)
3. **Determine Dependencies**: Figure out what needs to happen before what else
4. **Create Ordered Steps**: Arrange steps in logical progression with clear outcomes
5. **Estimate Effort**: Provide rough time/effort estimates for each step
6. **Identify Resources**: Note what skills, knowledge, or tools are needed for each step
7. **Suggest Tracking**: Recommend ways to monitor progress through the cascade
8. **Highlight Risks**: Point out potential bottlenecks or challenging steps

## Output
- Clear decomposition of the large task into ordered steps
- Dependencies between steps (what blocks what)
- Effort estimates for each step
- Required resources or knowledge for each step
- Suggested milestones or checkpoints
- Risk assessment for challenging steps
- Progress tracking suggestions

## Example
**Input**: "cascade: implement Google OAuth authentication in FRINKELS"

**Output**:
```
# Cascade: Google OAuth Authentication Implementation

## 🎯 Overall Goal
Implement Google OAuth authentication using Clerk in the FRINKELS Flutter application, enabling users to sign in with their Google accounts.

## 🔗 Dependencies & Prerequisites
- Clerk account set up with Google OAuth provider configured
- flutter_clerk package added to dependencies
- Basic understanding of Clerk's authentication flow

## ⛓️ Step-by-Step Cascade

### Step 1: Provider Configuration (2-3 hours)
**Goal**: Set up Google OAuth provider in Clerk dashboard
**Dependencies**: Clerk account access
**Resources**: Clerk documentation, Google Cloud Console
**Outcome**: Google OAuth provider configured with correct redirect URIs
**Risks**: Domain mismatch, incorrect redirect URI configuration

### Step 2: Frontend Integration (3-4 hours)
**Goal**: Add Google Sign-In button to authentication screens
**Dependencies**: Step 1 completed
**Resources**: Clerk Flutter SDK documentation, UI design specs
**Outcome**: Google Sign-In button visible and styled correctly
**Risks**: Styling inconsistencies, button not responding

### Step 3: Callback Handling (2-3 hours)
**Goal**: Manage OAuth redirects and token exchange
**Dependencies**: Step 2 completed
**Resources**: Clerk SDK auth state listeners, error handling patterns
**Outcome**: Successful authentication handled, errors caught
**Risks**: Token exchange failures, unhandled edge cases

### Step 4: User Flow Management (3-4 hours)
**Goal**: Process new vs existing account scenarios
**Dependencies**: Step 3 completed
**Resources**: Clerk user metadata, account linking documentation
**Outcome**: New accounts created, existing accounts linked properly
**Risks**: Account linking failures, data inconsistency

### Step 5: Documentation & Testing (2-3 hours)
**Goal**: Document implementation and create test scenarios
**Dependencies**: Steps 1-4 completed
**Resources**: AUTHENTICATION.md template, testing frameworks
**Outcome**: Feature documented, test cases identified
**Risks**: Incomplete documentation, missed edge cases

## 📈 Progress Tracking
- [ ] Step 1: Provider Configuration
- [ ] Step 2: Frontend Integration
- [ ] Step 3: Callback Handling
- [ ] Step 4: User Flow Management
- [ ] Step 5: Documentation & Testing

## 💡 Suggested Approach
Work sequentially through the steps, but be prepared to iterate:
- Complete each step before moving to the next
- Test thoroughly after each step
- Document learnings that might affect previous steps
- Consider doing Steps 2-3 together if frontend and callback handling are tightly coupled

## 🛠️ Required Resources
- Clerk dashboard access
- Clerk Flutter SDK
- Google Cloud Console (for OAuth setup)
- FRINKELS authentication screens
- AUTHENTICATION.md template
```

## How to Use
When you want to break down a large task:
1. Invoke this skill with: "cascade: [describe the large task or project]"
2. Provide any known constraints, deadlines, or resources
3. Review the suggested breakdown and dependencies
4. Adjust the steps based on your specific context
5. Use the cascade as your execution plan
6. Track progress using the suggested milestones

## Integration with Other Skills
- Works with **daily-brief** and **daily-log** for time allocation
- Informs **sherpa** for skill development needed for steps
- Connects to **knowledge-organizer** for filing cascade plans
- Links to **quick-append** for adding learnings to documentation
- Use with **link-weaver** to find connections between steps
- Connects to **rock-tumbler** for refining the cascade plan itself