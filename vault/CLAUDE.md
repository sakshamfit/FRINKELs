# CLAUDE.md - FRINKELS Project Knowledge Base

## User Profile & Working Style

**Name**: SATYAM PANDAY  
**Role**: Lead Developer / Architect  
**Expertise**: Full-stack Flutter development, Supabase/Firebase integration, Clean Architecture  
**Preferences**: 
- Detailed documentation and knowledge organization
- Systematic approach to feature implementation
- Preference for Obsidian-style knowledge linking
- Focus on production-ready code with proper error handling
- Emphasis on UI/UX with glassmorphism and modern design principles
- Strong focus on authentication systems (Clerk migration from Supabase)
- Interest in AI integration features
- Obsidian knowledge base enthusiast

## Working Patterns

### Development Approach
1. **Feature-first thinking**: Implements complete features before moving to next
2. **Documentation-driven**: Creates/updates documentation alongside code
3. **Iterative refinement**: Continuously improves existing implementations
4. **Systematic debugging**: Uses structured approaches to identify and fix issues
5. **Knowledge capture**: Actively documents learnings in the vault for future reference

### Communication Style
- Prefers concrete, actionable feedback
- Appreciates thorough explanations with code examples
- Values understanding the "why" behind decisions
- Responds well to structured, organized information
- Likes to see progress tracked and visualized

### Technical Preferences
- **State Management**: Riverpod (StateNotifier/StateNotifierProvider pattern)
- **UI Framework**: Flutter with custom glassmorphism widgets
- **Navigation**: GoRouter-based routing system
- **Authentication**: Migrated from Supabase to Clerk (email/password, Google OAuth)
- **Database**: Supabase with Row Level Security (RLS)
- **Error Monitoring**: Sentry integration with debug test capabilities
- **Design System**: Custom tokens, typography, and spacing (8pt grid)
- **Architecture**: Clean Architecture with clear separation of concerns
- **Testing**: Widget testing with golden tests where applicable

## Knowledge Base Structure Preferences

### Obsidian-Compatible Features
1. **Wiki-style linking**: Uses `[[FileName]]` or `[FileName](./path/to/FileName.md)` patterns
2. **Tagging system**: Utilizes frontmatter tags for categorization
3. **Graph visualization**: Structures content to maximize meaningful connections in graph view
4. **Atomic notes**: Breaks down complex topics into focused, linkable notes
5. **Templates**: Uses consistent templates for similar document types
6. **Daily notes**: Incorporates temporal aspects of learning and development

### Preferred Documentation Patterns
- **Master Index**: Central navigation hub (MASTER-INDEX.md)
- **Feature Matrix**: Overview of all features and their status
- **API Index**: Comprehensive API documentation
- **Architecture Decision Records**: Key architectural choices documented
- **Feature Specifications**: Detailed implementation guides
- **Runbooks**: Operational procedures and troubleshooting guides
- **Retrospectives**: Lessons learned and improvement plans

## Current Project Focus Areas (as of Aug 2026)

1. **Authentication System**: Complete migration to Clerk with all providers
2. **Navigation Implementation**: All home screen sections fully navigable
3. **Knowledge Base**: Expanding and organizing the Obsidian vault
4. **AI Integration**: Kittu AI assistant features development
5. **Performance Optimization**: Ongoing performance monitoring and improvements
6. **Security Hardening**: RLS policies, input validation, secure storage
7. **Testing Coverage**: Increasing unit and widget test coverage
8. **Deployment Pipeline**: CI/CD workflows for all platforms

## How I Like to Work with AI Assistants

### Effective Approaches
- **Provide context**: Share relevant code snippets and file paths
- **Be specific**: Clearly state what needs to be implemented or fixed
- **Show examples**: Demonstrate similar implementations when possible
- **Explain trade-offs**: Discuss pros/cons of different approaches
- **Iterate together**: Collaborate on refining solutions
- **Document decisions**: Help capture rationale in the knowledge base

### Less Effective Approaches
- **Vague requests**: Without clear scope or acceptance criteria
- **Missing context**: Not showing related code or files
- **Assumptions**: Assuming shared understanding without verification
- **Over-engineering**: Suggesting unnecessarily complex solutions
- **Ignoring conventions**: Not following established project patterns

## Knowledge Graph Goals

1. **Connect related concepts**: Link features, architecture choices, and implementation details
2. **Trace evolution**: Show how implementations have changed over time
3. **Identify patterns**: Highlight reusable solutions and anti-patterns
4. **Onboarding aid**: Help new team members understand the system quickly
5. **Decision history**: Preserve reasoning behind key architectural choices
6. **Skill mapping**: Connect technologies to team member expertise

## Maintenance Preferences

- **Regular updates**: Keep documentation synchronized with code changes
- **Link hygiene**: Fix broken links and update references
- **Tag consistency**: Maintain standardized tagging system
- **Graph health**: Periodically review and optimize knowledge connections
- **Backup strategy**: Ensure knowledge base is version controlled