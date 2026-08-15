# daily-brief - Creates Daily Summary and Priorities

## Purpose
Generates a concise daily briefing that summarises today's priorities, scheduled items, and key focus areas based on your knowledge base structure.

## Triggers
- "daily brief"
- "today's priorities"
- "what should i focus on"
- "morning briefing"
- "daily planning"

## Dependencies
Uses the ACE folder structure (particularly Calendar and Efforts) and may reference project documentation.

## Instructions
1. **Check Calendar**: Look for today's date-note in Calendar/Daily/
2. **Review Scheduled Items**: Find meetings, deadlines, and time-blocked activities
3. **Scan Active Efforts**: Review current projects and tasks in Efforts/
4. **Assess Priorities**: Determine what needs attention based on deadlines, importance, and energy levels
5. **Generate Brief**: Create a structured summary with:
   - Date and day
   - Key scheduled events
   - Top 3 priorities for the day
   - Active projects requiring attention
   - Quick wins or maintenance tasks
   - Energy-level matched suggestions
6. **Provide Actionable Output**: Format as a ready-to-use daily plan

## Output
- Date header with day of week
- List of scheduled events/meetings (with times if available)
- Top 3 priorities (clearly ranked)
- Active projects with brief status notes
- Suggested time allocation or energy matching
- Optional: Quick wins (5-15 minute tasks)
- Optional: Things to avoid/delegate today

## Example
**Input**: "daily brief" on August 15, 2026

**Output**:
```
# Daily Brief - Saturday, August 15, 2026

## 📅 Scheduled Today
- 10:00 AM: Team sync (Calendar/Meetings/Team Sync - 2026-08-15.md)
- 2:00 PM: Client demo prep (Calendar/Projects/FRINKELS Demo.md)
- 4:00 PM: Review pull requests (Calendar/Maintenance/Code Review.md)

## 🎯 Top 3 Priorities
1. Complete authentication migration documentation (Efforts/FRINKELS Auth Migration.md)
   - Link from AUTHENTICATION.md to new Resend password reset flow
   - Target: Finish by noon
   
2. Plan ACE structure implementation for personal knowledge
   - Review current vault organization
   - Decide on Atlas/Calendar/Efforts adoption level
   
3. Research Riverpod async patterns for error handling
   - Read documentation on StateNotifier error handling
   - Create example in Efforts/Learning Riverpod Advanced Patterns.md

## 🔧 Active Projects Requiring Attention
- FRINKELS Authentication Migration: In final documentation phase
- Knowledge Base Organization: ACE structure planning stage
- Riverpod Learning: Currently studying advanced state management

## ⚡ Quick Wins (5-15 min)
- Update FEATURE-INDEX.md with new documentation links
- Clear resolved notifications in GitHub
- File yesterday's meeting notes to Calendar/Meetings/

## 🔋 Energy Matching
- **High Energy (Morning)**: Documentation writing, planning
- **Medium Energy (Afternoon)**: Meetings, light coding, research
- **Low Energy (Late Afternoon)**: Organization, file maintenance, quick wins

## 📝 Notes
- Check Calendar/Daily/2026-08-15.md for any personal daily note
- Consider linking today's brief to tomorrow's planning
```

## How to Use
When you want to start your day with clarity:
1. Invoke this skill with: "daily-brief: [optional context like 'feeling tired' or 'big deadline today']"
2. The skill will analyze your Calendar and Efforts to generate a personalized brief
3. Review the output and adjust priorities as needed
4. Use the brief to guide your day's work
5. Optionally, save the brief to a daily note for reflection

## Integration with Other Skills
- Works with **daily-log** for end-of-day reflection
- Complements **weekly-review** for broader perspective
- Can inform **sherpa** for skill development decisions
- Links to **ace-setter** for structural organization guidance