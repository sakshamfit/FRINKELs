# sherpa - Guides Skill Development and Learning Paths

## Purpose
Helps identify skill gaps, suggests learning resources, and creates personalized development paths based on your current expertise and goals.

## Triggers
- "what should i learn"
- "skill development"
- "learning path"
- "guide my growth"
- "sherpa: [skill area]"

## Dependencies
References your knowledge base to understand current skills and may link to external resources.

## Instructions
1. **Assess Current Skills**: Analyze your knowledge base for existing skills and expertise (tags, project files, learning notes)
2. **Identify Goals**: Understand what you want to achieve (from context or direct input)
3. **Identify Gaps**: Compare current skills against goals to find development areas
4. **Suggest Resources**: Recommend specific learning materials, projects, or practices
5. **Create Learning Path**: Structure a progressive path from current level to goal
6. **Provide Practice Suggestions**: Suggest hands-on projects or exercises
7. **Set Milestones**: Define checkpoints to measure progress
8. **Consider Time & Energy**: Factor in your available time and preferred learning style

## Output
- Summary of current skill assessment
- Identified skill gaps related to goals
- Recommended learning resources (courses, docs, books, projects)
- Structured learning path with phases/milestones
- Suggested practice projects or exercises
- Time estimates and pacing suggestions
- Methods to track progress and measure improvement

## Example
**Input**: "sherpa: improve Riverpod state management skills"

**Output**:
```
# Sherpa Guide: Riverpod State Management Development

## 📊 Current Skill Assessment
Based on your knowledge base:
- **Proficient**: StateNotifier/StateNotifierProvider pattern, basic providers
- **Developing**: Advanced state management patterns, error handling
- **Limited Experience**: State manipulation testing, complex async flows
- **Evidence**: See `lib/features/auth/presentation/controllers/auth_controller.dart`, `Efforts/Learning Riverpod Advanced Patterns.md`

## 🎯 Learning Goals
Achieve proficiency in advanced Riverpod patterns including:
- Complex state manipulation and testing
- Async state handling with error boundaries
- Performance optimization techniques
- Testing strategies for state management

## 🔍 Identified Gaps
1. Testing Riverpod providers (unit and widget tests)
2. Handling complex async states with loading/error/success patterns
3. Performance optimization (selectors, memoization)
4. Advanced patterns: futureProvider, streamProvider, stateProvider modifiers

## 📚 Recommended Resources
- **Documentation**: Riverpod official guide - Testing chapter
- **Video Course**: "Advanced Riverpod" by Reso Coder (YouTube)
- **Book**: "Flutter in Action" - State Management chapter
- **Project**: Refactor existing auth controller to use advanced patterns

## 🛤️ Structured Learning Path
### Phase 1: Foundation Testing (1 week)
- Learn Riverpod testing fundamentals
- Write unit tests for existing StateNotifier providers
- Resource: Riverpod testing documentation + practice exercises

### Phase 2: Async State Mastery (2 weeks)
- Implement loading/error/success state patterns
- Use FutureProvider and StreamProvider effectively
- Resource: Async state handling guide + mini-project

### Phase 3: Performance Optimization (1 week)
- Learn about selectors and memoization
- Optimize existing state management in FRINKELS
- Resource: Performance guide + profiling practice

### Phase 4: Advanced Patterns (1 week)
- Explore stateProvider modifiers and families
- Implement complex state transformations
- Resource: Advanced patterns guide + refactoring exercise

## 💪 Suggested Practice Projects
1. **Test Suite Expansion**: Add comprehensive tests to auth controller
2. **Settings Repository**: Create a settings provider with async loading
3. **Feature Flags System**: Implement using StateProvider with persistence
4. **Shopping Cart**: Complex state with async updates and testing

## 🎯 Milestones & Checkpoints
- **Week 1**: Can write unit tests for any StateNotifier provider
- **Week 2**: Can implement async state patterns confidently
- **Week 3**: Can identify and fix performance issues in state management
- **Week 4**: Can implement advanced patterns like stateProvider families

## ⏱️ Time & Energy Considerations
- Suggested: 5 hours/week (can be adjusted)
- Best learning times: Based on your daily-log energy patterns
- Break down into: 30-60 minute focused sessions
- Pair with: Documentation writing to reinforce learning

## 📈 Progress Tracking Methods
- Test coverage percentage for state management code
- Number of advanced patterns implemented in FRINKELS
- Self-assessment quiz at end of each phase
- Ability to explain concepts to others (rubber ducking)

## How to Use
When you want guidance on skill development:
1. Invoke this skill with: "sherpa: [specific skill or area you want to develop]"
2. Provide context about your current level and goals if helpful
3. Review the assessment, gaps, and recommendations
4. Follow the suggested learning path or adapt it to your needs
5. Use the practice suggestions and milestones to guide your effort
6. Update your knowledge base with learnings and progress

## Integration with Other Skills
- Informs **daily-brief** and **daily-log** for learning time allocation
- Connects to **knowledge-organizer** for filing learning materials
- Links to **doc-generator** for creating learning summaries
- Works with **weekly-review** for periodic skill assessment
- Connects to **style-guide-MOC** for learning style preferences