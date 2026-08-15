# weekly-review - Weekly Reflection and Planning

## Purpose
Facilitates weekly reflection to review accomplishments, challenges, insights, and plan for the upcoming week based on your daily logs and knowledge base activities.

## Triggers
- "weekly review"
- "end of week reflection"
- "weekly planning"
- "review last week"
- "plan upcoming week"

## Dependencies
Works with daily-logs for the week and may reference ACE structure and project documentation.

## Instructions
1. **Gather Daily Logs**: Collect all daily-log.md files from the past week (Calendar/Daily/)
2. **Review Accomplishments**: Identify completed tasks, progress made, and goals achieved
3. **Document Challenges**: Note recurring obstacles, blockers, and how they were addressed
4. **Extract Insights**: Record learnings, patterns noticed, and new understandings from the week
5. **Assess Metrics**: Review quantitative data if available (time spent, tasks completed, etc.)
6. **Identify Patterns**: Look for recurring themes in productivity, energy, and focus
7. **Plan for Next Week**: Set goals, priorities, and schedule for the upcoming week
8. **Update Systems**: Note any changes needed to your knowledge base or workflows
9. **Celebrate Wins**: Acknowledge accomplishments and progress made

## Output
- Week header with date range
- Accomplishments section (completed tasks, progress markers, goals met)
- Challenges section (obstacles, blockers, resolutions attempted/pending)
- Insights & Patterns section (learnings, recurring themes, new understandings)
- Metrics & Measurements (if tracked: time allocation, completion rates, etc.)
- Energy & Focus Patterns (weekly productivity trends)
- Unfinished Work & Carry-Over
- Goals & Priorities for Next Week (clearly ranked)
- Schedule & Time Blocking Suggestions
- System Updates & Improvements Needed
- Wins & Celebrations (acknowledgments of progress)
- Suggested tags for organization

## Example
**Input**: "weekly review" for week of August 8-14, 2026

**Output**:
```
# Weekly Review - Week of August 8-14, 2026

## 📅 Week Overview
- **Dates**: August 8-14, 2026 (Sunday to Saturday)
- **Working Days**: 5 days (Mon-Fri)
- **Daily Logs Completed**: 5/5 days
- **Primary Focus**: Authentication system migration, knowledge base organization

## ✅ Accomplishments
- Completed Clerk authentication migration (email/password, Google OAuth)
- Added Resend password reset flow documentation
- Created 4 new AI OS skills (knowledge-organizer, link-weaver, doc-generator, error-decoder)
- Fixed navigation TODOs in jobs section
- Updated AUTHENTICATION.md and FEATURE-INDEX.md
- Organized vault/AIOS/Skills/ directory structure
- Improved Sentry monitoring configuration

## 🚧 Challenges
- **Git push issues**: Secrets in .env file causing rejections
  - *Resolution*: Aborted rebases, amended commits to remove secrets
- **Authentication confusion**: Clerk vs Supabase implementation questions
  - *Resolution*: Clarified by reviewing code and choosing Clerk path
- **Context switching costs**: Moving between coding and documentation
  - *Mitigation*: Using daily briefs to maintain focus

## 💡 Insights & Patterns
- **Documentation-first approach** reduces rework and improves clarity
- **Daily briefings** significantly improve morning focus and task selection
- **ACE structure** provides good balance between project and personal knowledge
- **Link-weaver skill** effectively surfaces related documentation for cross-referencing
- **Peak productivity**: 9:00-11:30 AM and 4:00-6:00 PM (consistent across days)
- **Meeting effectiveness**: Better when scheduled in early afternoon (1-3 PM)

## 📊 Metrics & Measurements
- **Features completed**: Authentication migration (100%)
- **Knowledge notes created**: 8 new vault documents
- **Skills created**: 4 AI OS skills
- **TODOs resolved**: 1/4 home screen navigation TODOs fixed
- **Documentation updates**: AUTHENTICATION.md, FEATURE-INDEX.md
- **Average daily focus**: 6.2 productive hours/day (based on daily logs)

## ⚡ Energy & Focus Patterns
- **Consistent peak**: Morning (9-11:30 AM) and late afternoon (4-6 PM)
- **Weekly rhythm**: Higher mid-week (Tue-Thu), lower Monday/Friday
- **Best for deep work**: Morning sessions (writing, planning, complex coding)
- **Best for collaboration**: Early afternoon (meetings, light coding, research)
- **Best for maintenance**: Late afternoon (organization, file management, quick wins)

## 📋 Unfinished Work & Carry-Over
- [ ] Stories section navigation (create story, story view)
- [ ] Local news section navigation (news detail)
- [ ] Communities section navigation (community screen)
- [ ] ACE folder structure implementation (planning phase complete)
- [ ] Daily brief/log habit refinement

## 🎯 Goals & Priorities for Next Week
1. **Complete remaining navigation fixes** (Stories, Local News, Communities sections)
   - Implement navigation to detail/create screens
   - Test all home screen sections for proper navigation
   - Target: Complete by Wednesday
   
2. **Begin ACE structure implementation** 
   - Create Atlas/Calendar/Efforts folders
   - Migrate existing personal knowledge to appropriate locations
   - Target: Basic structure by Friday
   
3. **Enhance knowledge base linking**
   - Use link-weaver on recent documentation
   - Ensure feature specs link to architecture decisions
   - Target: 20 new meaningful links added
   
4. **Refine daily brief/log Practice**
   - Review effectiveness of current templates
   - Adjust based on weekly insights
   - Target: Optimized templates by end of week

## 📅 Suggested Time Blocking
- **Monday AM**: Planning and setup for week
- **Tuesday-Thursday AM**: Deep work (navigation fixes, ACE structuring)
- **Tuesday-Thursday PM**: Collaboration (meetings, light tasks, research)
- **Friday AM**: Review, wrap-up, planning for next week
- **Friday PM**: Maintenance, organization, knowledge base cleanup

## 🔧 System Updates & Improvements
- Consider adding template for weekly review itself
- Explore ways to automate daily log creation
- Investigate better integration between ACE and FRINKELS project structure
- Look into tag standardization across knowledge base

## 🙏 Wins & Celebrations
- Authentication system fully migrated to Clerk with all providers
- Knowledge base growing with structured AI OS skills
- Improved personal productivity through daily brief/reflection cycle
- Successful resolution of git push secret issues through proper process

## 🏷️ Suggested Tags
#weekly-review #authentication #knowledge-organization #navigation #FRINKELS #ACE-system #productivity

## How to Use
When you want to conduct your weekly review:
1. Invoke this skill with: "weekly-review: [optional context like 'productive week' or 'faced challenges']"
2. Gather all daily-log.md files from Calendar/Daily/ for the past week
3. Review your daily-brief.md files if you created them
4. Answer the guided reflection prompts thoroughly
5. Set clear, achievable goals for the upcoming week
6. Save the review to a suitable location (consider Calendar/Weekly/ or a dedicated reviews folder)
7. Use insights to inform your daily planning and skill development
8. Link to relevant notes and files you worked on during the week

## Integration with Other Skills
- Works with **daily-log** and **daily-brief** for daily/weekly comparison
- Informs **sherpa** for skill development decisions based on weekly patterns
- Can guide **ace-setter** implementation based on weekly insights
- Connects to **knowledge-organizer** for filing weekly review documents
- Links to **link-weaver** for finding cross-week connections