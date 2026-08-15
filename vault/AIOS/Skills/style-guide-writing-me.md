# style-guide-writing-me.md - My Personal Writing and Communication Preferences

## Purpose
Documents your personal preferences for how you write, think, and communicate, serving as a reference for yourself and others who collaborate with you.

## Triggers
- "how i write"
- "my writing style"
- "personal communication preferences"
- "how i think and work"
- "my preferences"

## Dependencies
Builds on your self-knowledge and may link to examples in your knowledge base that demonstrate your style.

## Instructions
This skill captures your personal writing and communication preferences across different contexts. It represents how you naturally express yourself and prefer to receive information.

## Your Personal Preferences

### 🧠 Thinking and Processing Style
- **Systems thinker**: You see connections between components and prefer to understand how things fit together
- **Documentation-oriented**: You process information better when writing it down or seeing it documented
- **Visual learner**: You benefit from diagrams, mind maps, and visual representations of concepts
- **Pattern recognizer**: You look for recurring patterns and principles rather than memorizing specifics
- **Future-oriented**: You often think about implications, scalability, and long-term consequences

### ✍️ Writing Style
- **Structured and organized**: You prefer clear headings, bullet points, and logical flow
- **Detail-appropriate**: You include technical details when necessary but avoid unnecessary complexity
- **Example-driven**: You understand concepts better through concrete examples than abstract explanations
- **Action-oriented**: You focus on what can be done and prefer clear next steps
- **Linking-focused**: You naturally think in terms of connections and relationships between ideas
- **Concise but thorough**: You value brevity but won't sacrifice clarity for shortness
- **Obsidian-native**: You think in terms of wiki-style linking (`[[FileName]]`) and atomic notes

### 💬 Communication Preferences
- **Context-aware**: You adjust your communication style based on audience and purpose
- **Question-friendly**: You appreciate when people ask clarifying questions rather than making assumptions
- **Feedback-receptive**: You welcome constructive feedback when it's specific and actionable
- **Progress-appreciated**: You like to see work tracked and visualized
- **Reasoning-valuing**: You care about the "why" behind decisions, not just the "what"
- **Patience-preferred**: You appreciate when people take time to understand before suggesting solutions
- **Enthusiasm-responsive**: You respond well to genuine interest in your work and projects

### 📚 Knowledge Work Style
- **Atomic note-taker**: You break down complex topics into focused, linkable notes
- **Tag user**: You use tags effectively for categorization and retrieval
- **Graph thinker**: You appreciate seeing how notes connect in a knowledge graph
- **Template user**: You prefer consistent formats for similar types of information
- **Temporal thinker**: You incorporate time-based aspects (daily logs, retrospectives, planning)
- **Meta-learner**: You document not just what you learned but how you learned it

## Specific Preferences by Context

### 🔧 Technical Communication
When discussing code, architecture, or technical implementation:
- **File paths first**: You like to see exact file references (e.g., `lib/features/auth/auth_controller.dart:45`)
- **Code snippets welcome**: You prefer seeing relevant code rather than just descriptions
- **Pattern names useful**: You appreciate when patterns are named (e.g., "StateNotifier/StateNotifierProvider")
- **Trade-off aware**: You like discussions of pros/cons, not just solutions presented as perfect
- **Convention-respecting**: You value when people follow or consciously deviate from established patterns
- **Error-detail oriented**: When debugging, you want error messages, stack traces, and context

### 📖 Documentation and Knowledge Sharing
When creating or consuming documentation:
- **Wiki-linking essential**: You expect and use `[[FileName]]` links extensively
- **Atomic notes preferred**: You like focused notes that address one topic well
- **Template-consistent**: You appreciate when similar documents follow the same structure
- **Frontmatter-friendly**: You don't mind metadata when it helps organization
- **Tag-suggestive**: You find suggested tags helpful for categorization
- **Example-inclusive**: You value concrete examples in documentation
- **Link-rich**: You expect documentation to connect to related information

### 🎯 Planning and Decision Making
When discussing plans, features, or architectural decisions:
- **Context-first**: You like to understand the problem space before jumping to solutions
- **Options-considered**: You appreciate when alternatives are presented with trade-offs
- **Risk-aware**: You want to know potential downsides or considerations
- **Phased approach**: You like breaking work into manageable pieces
- **Success-criteria clear**: You want to know how to recognize when something is complete
- **Future-thinking**: You appreciate thoughts on scalability, maintenance, and evolution
- **Decision-record valued**: You like seeing the reasoning behind choices preserved

### 🐞 Debugging and Problem Solving
When troubleshooting issues:
- **Reproducible steps valued**: You like clear steps to reproduce problems
- **Environment details important**: You want to know versions, configurations, and context
- **Systematic approach preferred**: You appreciate methodical elimination of possibilities
- **Isolation techniques useful**: You like suggestions for isolating problems
- **Error message focused**: You pay close attention to exact error texts and stack traces
- **Solution testing appreciated**: You like when fixes are verified to work

### 💡 Learning and Skill Development
When learning new things or developing skills:
- **Hands-on preferred**: You learn better by doing than just watching or reading
- **Project-based learning**: You appreciate applying concepts to real projects
- **Teach-back valuable**: You solidify learning by explaining to others
- **Pattern-seeking**: You look for underlying principles rather than memorizing procedures
- **Mistake-friendly**: You see errors as learning opportunities when analyzed
- **Resource-appreciative**: You value specific recommendations for books, courses, or tutorials
- **Progress-tracking helpful**: You like having ways to measure improvement over time

## Communication Do's and Don'ts

### ✅ Do:
- **Start with context**: Provide background before diving into specifics
- **Be specific**: Reference exact files, lines, error messages when relevant
- **Show examples**: Demonstrate with concrete code snippets or scenarios
- **Explain reasoning**: Walk through how you arrived at a conclusion
- **Note trade-offs**: Discuss pros/cons of different approaches
- **Suggest actions**: Provide clear next steps when making recommendations
- **Use linking syntax**: Reference related notes with `[[FileName]]` when appropriate
- **Respect expertise**: Acknowledge what you know while remaining open to learning
- **Iterate together**: Frame suggestions as starting points for collaboration

### ❌ Don't:
- **Assume shared understanding**: Don't skip explaining basics unless certain they're known
- **Be vague**: Avoid statements like "fix this" or "make it better" without specifics
- **Ignore context**: Don't suggest solutions that contradict established patterns without explanation
- **Over-complicate simple things**: Don't introduce unnecessary complexity for simple tasks
- **Dismiss concerns**: Don't brush off worries about scalability, security, or maintainability
- **Guess when uncertain**: Prefer asking for clarification over making assumptions
- **Ignore documentation**: Don't overlook existing docs that might answer the question
- **Break conventions without reason**: Don't deviate from patterns without explaining why

## Examples of Your Natural Communication Style

### When Explaining a Technical Concept:
"In the FRINKELS auth system, we're using Clerk with StateNotifier providers. Looking at `auth_controller.dart:22-30`, you can see how the Clerk user flow listener updates the authentication state. This follows the Riverpod pattern where we:
1. Listen to Clerk's auth state changes
2. Update our StateNotifier when the state changes
3. Notify listeners so the UI can react
The key benefit is that we maintain a single source of truth for auth state that's automatically kept in sync with Clerk."

### When Giving Feedback on Code:
"I noticed in `home_screen.dart` you're implementing navigation for the jobs section. This looks good overall! A couple of observations:
1. The TODO comment suggests navigating to a job detail screen - we should make sure that route exists in `go_router.dart`
2. Consider extracting the onTap handler to a separate method if it grows more complex
3. The glassmorphism card styling matches our design system preferences
Would you like me to suggest how to implement the navigation using GoRouter's context.go()?"

### When Planning a Feature:
"For adding Google OAuth authentication, I see we've already migrated to Clerk. Based on our documentation-first approach:
1. Let's update `AUTHENTICATION.md` to document the Google OAuth flow
2. Then implement the provider configuration in `clerk_auth_remote_data_source.dart`
3. Add the UI button to the login/signup screens
4. Finally, test the complete flow and document any edge cases
Does this phased approach work for you? Are there any specific concerns about the Google OAuth integration we should address upfront?"

## How to Use
When you want to remind yourself of your preferences or communicate them to others:
1. Reference this guide when preparing to communicate or collaborate
2. Use it to evaluate whether communications match your preferred style
3. Share it with team members or collaborators to improve mutual understanding
4. Update it as your preferences evolve through experience
5. Use it in conjunction with sherpa for developing communication skills
6. Use it with doc-generator to create consistently styled documentation

## Integration with Other Skills
- Works with **style-guide-MOC** as part of your communication style mapping
- Informs **sherpa** for learning how to better communicate your needs
- Complements **doc-generator** for creating documentation in your preferred style
- Links to **knowledge-organizer** for filing self-knowledge and preferences
- Connects to **daily-brief/daily-log** for reflecting on communication effectiveness
- Connects to **link-weaver** for finding opportunities to apply your style principles