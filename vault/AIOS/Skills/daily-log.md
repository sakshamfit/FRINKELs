# daily-log - End-of-Day Reflection and Capture

## Purpose
Facilitates end-of-day reflection to capture accomplishments, challenges, insights, and plan for tomorrow based on your daily activities and knowledge base.

## Triggers
- "daily log"
- "end of day reflection"
- "what did i accomplish"
- "daily review"
- "evening log"

## Dependencies
Works with daily-brief for comparison and uses Calendar/Daily/ for storage.

## Instructions
1. **Review Today's Brief**: Compare against morning daily-brief if available
2. **Capture Accomplishments**: List completed tasks and progress made
3. **Document Challenges**: Note obstacles encountered and how they were addressed
4. **Extract Insights**: Record learnings, realizations, and new understandings
5. **Assess Energy & Focus**: Reflect on productivity patterns and energy levels
6. **Plan for Tomorrow**: Identify unfinished work and priorities for next day
7. **Gratitude/Appreciation**: Optional section for positive acknowledgments
8. **Save to Daily Note**: Store in Calendar/Daily/[YYYY-MM-DD] Daily Note.md

## Output
- Date header and day of week
- Accomplishments section (completed tasks, progress markers)
- Challenges section (obstacles, blockers, resolutions attempted)
- Insights & Learnings section (new understandings, patterns noticed)
- Energy & Focus Reflection (when were you most/least productive)
- Unfinished Work & Tomorrow's Plan
- Gratitude/Appreciation (optional)
- Links to related notes or files worked on
- Suggested tags for organization

## Example
**Input**: "daily log" at end of August 15, 2026

**Output**:
```
# Daily Log - Saturday, August 15, 2026

## ✅ Accomplishments
- Completed authentication migration documentation in AUTHENTICATION.md
  - Added Resend password reset flow section
  - Linked from vault/AIOS/Skills/error-decoder.md for auth error patterns
- Created ACE structure plan in vault/AIOS/Skills/ace-setter.md
- Organized vault/AIOS/Skills/ directory with 4 new skills
- Fixed navigation TODO in jobs_section.dart (jobs now navigate to detail)
- Updated FEATURE-INDEX.md with new documentation links

## 🚧 Challenges
- Git push rejected due to secrets in .env file
  - Resolved by aborting rebase and amending commits to remove secrets
- Slight confusion with Clerk vs Supabase auth implementation
  - Clarified by reviewing auth_controller.dart and choosing Clerk path
- Performance concern with large list rendering in home screen
  - Investigated but deferred optimization for later sprint

## 💡 Insights & Learnings
- Clerk initialization requires persistor parameter for token persistence
- GoRouter navigation works best with named routes and type-safe parameters
- Daily briefings significantly improve morning focus and task selection
- ACE structure provides good balance between project and personal knowledge
- Link-weaver skill effectively surfaces related documentation

## ⚡ Energy & Focus Reflection
- **Peak Energy**: 9:00-11:30 AM (completed documentation and planning)
- **Focus Dip**: 2:00-3:00 PM (post-lunch, better for meetings)
- **Secondary Peak**: 4:00-6:00 PM (completed coding tasks)
- **Best For**: Morning = deep work/writing, Afternoon = meetings/light tasks

## 📋 Unfinished Work & Tomorrow's Plan
- Continue navigation fixes:
  - [ ] Stories section: create story and story view navigation
  - [ ] Local news section: news detail navigation
  - [ ] Communities section: community screen navigation
- Review and implement daily-brief suggestions for tomorrow
- Begin ACE folder structure creation if approved
- Link today's log to tomorrow's planning note

## 🙏 Gratitude & Appreciation
- Progress on authentication system migration
- Helpful clarification on Clerk implementation from code review
- Satisfaction with knowledge base organization efforts

## 🔗 Related Notes & Files Worked On
- [[03-Features/AUTHENTICATION.md]]
- [[lib/features/auth/presentation/controllers/auth_controller.dart]]
- [[lib/features/home/presentation/widgets/jobs_section.dart]]
- [[vault/AIOS/Skills/ace-setter.md]]
- [[vault/AIOS/Skills/daily-brief.md]]
- [[vault/AIOS/Skills/error-decoder.md]]
- [[vault/AIOS/Skills/knowledge-organizer.md]]
- [[vault/AIOS/Skills/link-weaver.md]]
- [[vault/AIOS/Skills/doc-generator.md]]

## 🏷️ Suggested Tags
#authentication #documentation #knowledge-organization #navigation #FRINKELS #ACE-system

## How to Use
When you want to reflect on your day:
1. Invoke this skill with: "daily-log: [optional context like 'productive day' or 'faced challenges']"
2. Review your morning daily-brief if you created one
3. Answer the guided reflection prompts honestly
4. Save the log to your Calendar/Daily/ folder for today's date
5. Use insights to inform tomorrow's planning and skill development
6. Link to relevant notes and files you worked on today

## Integration with Other Skills
- Works with **daily-brief** for morning/evening comparison
- Informs **weekly-review** for broader perspective
- Can guide **sherpa** decisions based on energy patterns
- Links to **ace-setter** for structural organization thoughts
- Connects to **link-weaver** and **knowledge-organizer** for knowledge capture