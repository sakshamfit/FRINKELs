# navigation-janitor.md - Improves Note Discoverability and Navigation

## Purpose
Improves the discoverability and navigation of your knowledge base by analyzing link structure, suggesting improvements, and ensuring notes can be easily found through browsing and searching.

## Triggers
- "improve navigation"
- "make notes easier to find"
- "navigation janitor"
- "improve link structure"
- "make knowledge base more discoverable"

## Dependencies
Analyzes your entire knowledge base or specified sections to understand link patterns and content relationships.

## Instructions
1. **Analyze Link Structure**: Examine how notes link to each other (incoming/outgoing links, orphaned notes)
2. **Identify Orphaned Notes**: Find notes with few or no incoming links that might be hard to discover
3. **Assess Link Quality**: Evaluate whether links are descriptive, contextual, and useful
4. **Suggest Missing Links**: Recommend connections that would improve discoverability
5. **Recommend Hub Notes**: Suggest creating or strengthening index/MOC notes for better navigation
6. **Check Tag Usage**: Analyze tag consistency and suggest improvements for categorization
7. **Evaluate Searchability**: Assess how easily notes can be found through search
8. **Propose Structural Improvements**: Suggest folder reorganizations or naming convention improvements

## Output
- Link analysis report (incoming/outgoing link counts, link quality assessment)
- List of orphaned or hard-to-discover notes
- Suggested missing links with rationale
- Recommendations for hub/MOC notes to create or strengthen
- Tag usage analysis and improvement suggestions
- Structural improvements for better browsability
- Priority-ranked action items

## Example
**Input**: "navigation-janitor: analyze my FRINKELS feature documentation"

**Output**:
```
# Navigation Analysis: FRINKELS Feature Documentation

## 📊 Link Structure Overview
- **Total Notes Analyzed**: 12 feature specification files
- **Total Links**: 47 incoming, 38 outgoing
- **Average Incoming Links**: 3.9 per note
- **Average Outgoing Links**: 3.2 per note
- **Orphaned Notes** (0-1 incoming links): 2 notes
- **Well-Linked Notes** (5+ incoming links): 5 notes

## 🚪 Orphaned & Hard-to-Discover Notes
1. `03-Features/AI-KITTU-DETAILED.md` (1 incoming link)
   - Currently linked only from: `03-Features/AI-KITTU-ASSISTANT.md`
   - **Issue**: Difficult to discover through browsing
   - **Suggestion**: Link from `MASTER-INDEX.md` or `03-Features/FEATURE-INDEX.md`

2. `03-Features/COMMUNITIES.md` (0 incoming links)
   - Currently linked from: None
   - **Issue**: Completely orphaned - not reachable through links
   - **Suggestion**: Add link from `03-Features/FEATURE-INDEX.md` and `MASTER-INDEX.md`

## 🔗 Suggested Missing Links
### From `03-Features/AI-KITTU-ASSISTANT.md`:
- → `03-Features/AI-KITTU-DETAILED.md` (already has this)
- → `02-Architecture/STATE-MANAGEMENT.md` (Medium strength)
  *Rationale: AI assistant implementation involves state management patterns*
  
### From `03-Features/AUTHENTICATION.md`:
- → `03-Features/JOBS.md` (Weak strength)
  *Rationale: Both involve user accounts and profiles*
- → `04-Backend/SECURITY-REPORT.md` (Strong strength)
  *Rationale: Authentication is a key security concern*

## 🏛️ Hub & MOC Recommendations
### Strengthen Existing Hubs:
1. **FEATURE-INDEX.md**
   - Current state: Basic list of features
   - Improvement: Add brief descriptions and status indicators
   - Specific: Add `[x] AUTHENTICATION - Complete migration to Clerk`

### Suggest New Hubs:
1. **Authentication MOC** (`03-Features/AUTH-MOC.md`)
   - Purpose: Centralize all authentication-related documentation
   - Content: Links to AUTHENTICATION.md, JOBS.md (user profiles), SECURITY-REPORT.md
   - Benefit: Easier navigation for auth-related topics

## 🏷️ Tag Usage Analysis
- **Consistent Tags**: #authentication, #feature (used appropriately)
- **Inconsistent Tags**: Mix of #AI-Kittu and #ai-kittu (case inconsistency)
- **Missing Tags**: Several notes lack tags that would improve discoverability
- **Suggestion**: Standardize on lowercase tags and add relevant tags to all notes

## 📁 Structural Suggestions
### Current Structure:
```
03-Features/
├── AUTHENTICATION.md
├── AI-KITTU-ASSISTANT.md
├── AI-KITTU-DETAILED.md
├── COMMUNITIES.md
├── JOBS.md
└── LOCAL-NEWS.md
```

### Suggested Improvements:
1. **Group Related Features**:
   - Create `03-Features/AI-KITTU/` directory for AI assistant files
   - Move AI-KITTU-ASSISTANT.md and AI-KITTU-DETAILED.md into it
   - Update links accordingly

2. **Standardize Naming**:
   - Consider using consistent case (all lowercase or title case)
   - Example: `authentication.md` vs `AUTHENTICATION.md`

## 🎯 Priority Action Items
1. **High Priority**: Fix orphaned notes (COMMUNITIES.md, consider others)
   - Add links from FEATURE-INDEX.md and MASTER-INDEX.md
   
2. **Medium Priority**: Improve link quality and descriptiveness
   - Replace vague links like "see also" with descriptive anchor text
   - Example: Change "[[FEATURE-INDEX.md]]" to "[[FEATURE-INDEX.md|Feature Overview]]"
   
3. **Low Priority**: Standardize tag usage and consider structural reorganizations
   - Implement tag consistency pass
   - Evaluate grouping related features in directories

## How to Use
When you want to improve your knowledge base's navigation:
1. Invoke this skill with: "navigation-janitor: [scope - e.g., 'all notes', '03-Features/', 'AI OS skills']"
2. Specify any particular concerns: "navigation-janitor: [all notes] - focus on orphaned notes"
3. Review the analysis and suggestions
4. Implement the recommended changes, starting with high priority items
5. Consider running navigation-janitor periodically as your knowledge base grows

## Integration with Other Skills
- Works with **knowledge-organizer** to file janitor suggestions appropriately
- Connects to **link-weaver** for finding specific link opportunities
- Informs **harmonize** by providing link analysis that might reveal inconsistencies
- Connects to **collator** for collecting navigation improvement suggestions
- Use with **quick-append** to add discovered links to notes
- Connects to **cascade** for breaking down navigation improvements into steps