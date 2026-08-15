# Skill Map - AI Skills and Systems Guide

## Purpose
This map provides clear instructions about what AI skills exist, what they do, and exactly when to use them. Skills are stored as markdown files in the vault to ensure tool independence and future-proofing.

## How to Use Skills
1. Each skill is its own note in the `AIOS/Skills/` directory
2. Skills follow a consistent format: purpose, triggers, dependencies, and instructions
3. To invoke a skill, use the specific trigger phrase or reference the skill directly
4. Skills can be combined into larger workflows for complex tasks

## Skill Categories

### 🏗️ Knowledge Base Building Skills
These skills help build and maintain the Obsidian knowledge base.

#### `knowledge-organizer`
- **Purpose**: Automatically organizes new notes into appropriate directories based on content analysis
- **Triggers**: "organize knowledge", "categorize notes", "file new note"
- **Dependencies**: None (uses file content analysis)
- **Output**: Suggests proper file placement and tags

#### `link-weaver`
- **Purpose**: Identifies opportunities to create links between existing notes
- **Triggers**: "find connections", "link related notes", "weave knowledge graph"
- **Dependencies**: None (analyzes existing note content)
- **Output**: Suggested links with context explanations

#### `tag-gardener`
- **Purpose**: Maintains consistent tagging system and suggests new tags
- **Triggers**: "organize tags", "suggest tags", "tag cleanup"
- **Dependencies**: None
- **Output**: Tag usage statistics and recommendations

#### `index-updater`
- **Purpose**: Automatically updates index files when new notes are added
- **Triggers**: "update index", "refresh master index", "add to feature index"
- **Dependencies**: None
- **Output**: Updated index files with new entries

### 📝 Documentation & Writing Skills

#### `doc-generator`
- **Purpose**: Creates standardized documentation templates for features, APIs, or architecture
- **Triggers**: "create doc", "generate documentation", "write spec"
- **Dependencies**: None
- **Output**: Documentation file following project templates

#### `tech-writer`
- **Purpose**: Explains technical concepts in clear, accessible language
- **Triggers**: "explain this", "write for beginners", "simplify concept"
- **Dependencies**: None
- **Output**: Reader-friendly technical explanation

#### `changelog-creator`
- **Purpose**: Generates changelog entries from git commits or note changes
- **Triggers**: "create changelog", "summarize changes", "what's new"
- **Dependencies**: Git access (when available)
- **Output**: Formatted changelog entry

### � Piala Analysis & Insight Skills

#### `pattern-finder`
- **Purpose**: Identifies recurring patterns in code, documentation, or processes
- **Triggers**: "find patterns", "look for duplicates", "analyze repetition"
- **Dependencies**: None
- **Output**: Pattern descriptions with examples

#### `gap-analyzer`
- **Purpose**: Identifies missing documentation, features, or implementation gaps
- **Triggers**: "what's missing", "find gaps", "completeness check"
- **Dependencies**: None
- **Output**: List of missing items with priority suggestions

#### `trend-analyzer`
- **Purpose**: Analyzes changes over time to identify trends and trajectories
- **Triggers**: "show trends", "evolution of", "historical analysis"
- **Dependencies**: Access to historical notes/git history
- **Output**: Trend visualization and interpretation

### ⚙️ Process Automation Skills

#### `workflow-designer`
- **Purpose**: Creates step-by-step workflows for complex processes
- **Triggers**: "create workflow", "design process", "map out steps"
- **Dependencies**: None
- **Output**: Numbered workflow with decision points

#### `decision-helper`
- **Purpose**: Helps evaluate options and make informed decisions
- **Triggers**: "help me decide", "compare options", "pros and cons"
- **Dependencies**: None
- **Output**: Decision matrix with recommendations

#### `meeting-preparer`
- **Purpose**: Prepares for meetings by gathering context and creating agendas
- **Triggers**: "prepare for meeting", "get ready for", "meeting prep"
- **Dependencies**: None
- **Output**: Meeting brief with agenda and background info

### 🐞 Debugging & Problem-Solving Skills

#### `error-decoder`
- **Purpose**: Helps understand and resolve error messages
- **Triggers**: "what does this mean", "debug error", "fix this error"
- **Dependencies**: None
- **Output**: Error explanation and resolution steps

#### `performance-analyzer`
- **Purpose**: Analyzes performance issues and suggests optimizations
- **Triggers**: "slow performance", "optimize this", "performance bottleneck"
- **Dependencies**: None (relies on provided metrics or code)
- **Output**: Performance improvement suggestions

#### `security-reviewer`
- **Purpose**: Reviews code or configurations for security issues
- **Triggers**: "security check", "audit for vulns", "is this secure"
- **Dependencies**: None
- **Output**: Security findings with severity ratings

### 🧠 Learning & Research Skills

#### `concept-teacher`
- **Purpose**: Explains new concepts using analogies and examples
- **Triggers**: "teach me", "explain concept", "how does this work"
- **Dependencies**: None
- **Output**: Concept explanation with learning progression

#### `research-assistant`
- **Purpose**: Helps gather and synthesize information on a topic
- **Triggers**: "research this", "find information", "learn about"
- **Dependencies**: None
- **Output**: Research summary with sources and key points

#### `comparison-maker`
- **Purpose**: Compares technologies, approaches, or solutions
- **Triggers**: "compare these", "vs analysis", "which is better"
- **Dependencies**: None
- **Output**: Comparison table with trade-offs

## Skill Format Template

Each skill file should follow this structure:

```markdown
# skill-name - Brief Description

## Purpose
One sentence describing what the skill does.

## Triggers
- Phrase that invokes the skill
- Alternative trigger phrases
- Context when it's useful

## Dependencies
- What tools, APIs, or access the skill needs
- Mark "None" if it works with just note content

## Instructions
Step-by-step process for how the skill works:
1. First step description
2. Second step description
3. etc.

## Output
What the skill produces or returns.

## Example
Concrete example of using the skill.
```

## Creating New Skills

To create a new skill:
1. Create a file in `AIOS/Skills/skill-name.md`
2. Follow the skill format template above
3. Add the skill to this Skill Map
4. Test the skill with sample invocations
5. Refine based on usage

## Skill Maintenance

- **Regular review**: Periodically check if skills are still useful
- **Consolidation**: Combine similar skills when appropriate
- **Specialization**: Split overly broad skills into focused ones
- **Documentation**: Keep skill descriptions up-to-date with actual behavior
- **Feedback loop**: Improve skills based on how they're actually used

## Current Skill Inventory

*(This section will be automatically populated as skills are created)*

### Recently Added Skills
- `knowledge-organizer` - Organizes new notes into appropriate directories
- `link-weaver` - Finds opportunities to link related notes
- `doc-generator` - Creates standardized documentation templates
- `error-decoder` - Helps understand and resolve error messages

### In Development
- `workflow-designer` - For creating step-by-step processes
- `research-assistant` - For gathering and synthesizing information
- `performance-analyzer` - For identifying optimization opportunities

## Integration Guidelines

### When to Use Skills
- When you notice repetitive tasks in your knowledge work
- When you need consistent output formats
- When you want to leverage AI for structured thinking
- When you're trying to discover patterns or gaps

### When Not to Use Skills
- For highly creative, open-ended exploration
- When personal judgment and intuition are paramount
- For tasks requiring deep emotional intelligence
- When the context is too unique or sensitive for automation

### Best Practices
- Start with the simplest skill that could work
- Combine skills for complex workflows (output of one feeds into another)
- Always review and refine AI-generated output
- Keep the human in the loop for final decisions
- Document skill limitations and failure modes