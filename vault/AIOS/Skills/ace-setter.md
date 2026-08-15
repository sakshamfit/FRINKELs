# ace-setter - Sets Up ACE Folder Structure (Atlas, Calendar, Efforts)

## Purpose
Creates or reorganizes your vault using the ACE (Atlas, Calendar, Efforts) folder structure for optimal knowledge organization and retrieval.

## Triggers
- "setup ace structure"
- "create ace folders"
- "organize with ace"
- "implement ace system"

## Dependencies
None - creates directories and provides guidance on file placement.

## Instructions
1. **Assess Current Structure**: Review existing vault organization (if any)
2. **Create ACE Folders**: Establish the three main folders:
   - Atlas (for maps and static knowledge)
   - Calendar (for time-based notes)
   - Efforts (for active projects and tasks)
3. **Provide Placement Guidelines**: Explain what types of content belong in each folder
4. **Suggest Migration Path**: Offer guidance on moving existing content
5. **Recommend Maintenance Practices**: Suggest how to keep the system organized
6. **Link to Existing Knowledge**: Show how ACE integrates with your current FRINKELS structure

## ACE Folder Definitions

### 📚 Atlas - Maps and Static Knowledge
**Purpose**: Reference materials, maps of knowledge, static information that doesn't change over time.

**Contents**:
- Knowledge maps and mental models
- Reference guides and cheat sheets
- Hierarchical taxonomies and classifications
- Glossaries and dictionaries
- Infrastructure diagrams and architecture maps
- Skill matrices and competency maps
- Decision frameworks and mental models

**Examples**:
- `Atlas/Technology Stack Map.md`
- `Atlas/Feature Relationship Map.md`
- `Atlas/Glossary of Terms.md`
- `Atlas/Architecture Decision Log.md`

### 📅 Calendar - Time-Based Notes
**Purpose**: Notes that are inherently temporal - daily logs, meeting notes, time-bound plans.

**Contents**:
- Daily notes and journals
- Meeting minutes and recordings
- Time-bound plans and schedules
- Retrospectives and reviews
- Trip logs and event documentation
- Time-specific research notes

**Examples**:
- `Calendar/2026/08-August/2026-08-15 Daily Note.md`
- `Calendar/Meetings/Team Sync - 2026-08-14.md`
- `Calendar/Retrospectives/Sprint 12 Review.md`
- `Calendar/Planning/Q3 2026 Roadmap.md`

### 💪 Efforts - Active Projects and Tasks
**Purpose**: Current projects, areas of focus, and actionable tasks with clear outcomes.

**Contents**:
- Active projects and initiatives
- Areas of responsibility and focus
- Task lists and action items
- Experiments and prototypes
- Campaigns and initiatives with deadlines
- Skills currently being learned

**Examples**:
- `Efforts/FRINKELS Authentication Migration.md`
- `Efforts/Knowledge Base Organization Project.md`
- `Efforts/Learning Riverpod Advanced Patterns.md`
- `Efforts/Performance Optimization Sprint.md`
- `Efforts/AI Feature Experimentation.md`

## Integration with Existing FRINKELS Structure

Your FRINKELS project already has an excellent topic-based structure. The ACE system can work alongside it:

### Option 1: Keep Current Structure, Add ACE Overlay
- Maintain your existing `00-Index` through `07-Meeting-Notes` structure
- Use ACE folders for personal knowledge and meta-organization
- Atlas: Personal knowledge maps and learning resources
- Calendar: Your personal daily notes and time-based reflections
- Efforts: Your personal projects and learning goals

### Option 2: Hybrid Approach for Project Knowledge
- Use existing structure for FRINKELS project documentation
- Use ACE for:
  - Atlas: Architecture decisions, technology maps, reference guides
  - Calendar: Meeting notes, sprint retrospectives, release planning
  - Efforts: Active feature development, bug bashes, learning spikes

## Instructions for Implementation

### Step-by-Step Setup:
1. **Create the three main folders**:
   ```
   vault/Atlas/
   vault/Calendar/
   vault/Efforts/
   ```

2. **Create subfolders for organization**:
   - In Atlas: `/Maps`, `/Reference`, `/Glossaries`, `/Architecture`
   - In Calendar: `/Daily`, `/Meetings`, `/Retrospectives`, `/Planning`
   - In Efforts: `/Projects`, `/Areas`, `/Tasks`, `/Learning`, `/Experiments`

3. **Create index files** in each main folder:
   - `Atlas/README.md` - Guide to using the Atlas
   - `Calendar/README.md` - How to use time-based notes
   - `Efforts/README.md` - Managing projects and efforts

4. **Establish daily note habit** (if desired):
   - Create a template for daily notes
   - Set up a process for daily review and planning

5. **Link between systems**:
   - From project docs to ACE: Link to relevant maps or learning resources
   - From ACE to project docs: Link from meeting notes to feature specifications, etc.

## Output
- Confirmation of folder creation
- Detailed guidelines for what belongs in each folder
- Suggested subfolder structure
- Migration advice for existing content
- Linking strategies between ACE and existing FRINKELS structure
- Maintenance recommendations

## Example Workflow

**When starting a new feature**:
1. Plan in `Efforts/Projects/[Feature Name]/Planning.md`
2. Link to relevant Atlas maps: `[[Atlas/Maps/Feature Relationship Map.md]]`
3. Schedule work in `Calendar/Planning/[Feature Name] Timeline.md`
4. Hold meetings and link notes: `[[Calendar/Meetings/Feature Planning - 2026-08-15.md]]`
5. Document decisions: `[[Atlas/Architecture Decision Log.md#feature-name-choice]]`
6. Retrospective: `[[Calendar/Retrospectives/[Feature Name] Review.md]]`

## How to Use
When you want to implement or improve your ACE structure:
1. Invoke this skill with: "ace-setter: [your current organization status]"
2. Describe your current setup and goals
3. Follow the provided guidelines to create or refine your ACE structure
4. Use the placement principles to organize new and existing notes
5. Establish regular review habits to maintain the system