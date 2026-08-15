# creation-janitor.md - Ensures New Notes Follow Conventions and Best Practices

## Purpose
Reviews new notes or content additions to ensure they follow your knowledge base conventions, linking practices, and quality standards before they become part of your permanent knowledge.

## Triggers
- "check new note"
- "creation janitor"
- "validate note format"
- "ensure conventions followed"
- "review new content"

## Dependencies
References your knowledge base conventions, style guides, and may link to templates for comparison.

## Instructions
1. **Receive New Content**: Take the note or content to be reviewed (new file or addition)
2. **Check Conventions**: Verify adherence to your knowledge base standards:
   - File naming conventions
   - Heading structure and formatting
   - Linking practices (wiki-style, descriptive anchor text)
   - Tag usage and consistency
   - Template adherence (if applicable)
3. **Assess Quality**: Evaluate clarity, completeness, and value
4. **Check Linking**: Ensure appropriate connections to existing knowledge
5. **Verify Tags**: Confirm relevant and consistently formatted tags
6. **Suggest Improvements**: Recommend specific changes to bring the note up to standard
7. **Approve or Request Revision**: Indicate whether the note is ready or needs work

## Conventions Checked

### 📄 File and Naming Conventions
- File extension (.md)
- Naming case (your preference: Title-Case, snake_case, etc.)
- Use of spaces vs hyphens/underscores
- Appropriate folder placement
- Avoidance of special characters

### 🏗️ Structural Conventions
- Proper heading hierarchy (single # for title, ## for sections, etc.)
- Logical flow and organization
- Appropriate use of lists, blockquotes, code snippets
- Consistent spacing and formatting
- Template adherence (when using a known template)

### 🔗 Linking Conventions
- Use of wiki-style links (`[[FileName]]`) for internal knowledge
- Descriptive anchor text when using `|` syntax
- Links to relevant existing knowledge
- No broken or dangling links
- Appropriate link density (not too sparse, not excessive)

### 🏷️ Tagging Conventions
- Use of relevant tags
- Consistent tag formatting (lowercase, no spaces, etc.)
- Appropriate number of tags (not too few, not too many)
- Tags that actually help with discoverability

### ✍️ Writing and Style Conventions
- Adherence to your preferred writing style (from style-guide-writing-me.md)
- Appropriate technical depth for the audience
- Clear explanations and examples where needed
- Actionable insights or clear takeaways
- Proper attribution for external content

## Output
- Convention compliance report (pass/fail for each category)
- Specific issues found with line references or examples
- Suggested improvements for each failing convention
- Overall readiness assessment (ready, needs minor work, needs major work)
- Estimated effort to bring up to standard
- Links to relevant conventions or style guides for reference

## Example
**Input**: A new note about implementing dark mode in FRINKELS

**Analysis**:
```
Note: `03-Features/DARK-MODE.md`
Location: Suggested for 03-Features/ folder

### ✅ Passed Checks
- File naming: Uses Title-Case with hyphens appropriately
- Folder placement: Correctly placed in 03-Features/
- Heading structure: Proper hierarchy with single # title
- Technical depth: Appropriate for feature specification
- Template usage: Follows Feature Specification Template conventions

### ⚠️ Issues Found
**Linking Conventions** (Minor):
- Missing links to related UI/theme documentation
- Suggestion: Add links to `02-Architecture/THEME-SYSTEM.md` and `04-Backend/UI-GUIDELINES.md`

**Tagging Conventions** (Minor):
- Missing relevant tags: #ui #theme #darkmode
- Current tags: #feature (could be more specific)

**Writing Conventions** (Median):
- Could benefit from concrete implementation example
- Suggestion: Add code snippet showing ThemeMode usage

### 📋 Suggested Improvements
1. **Add Links**:
   - After "Overview" section: `See also [[02-Architecture/THEME-SYSTEM.md]] for theme architecture`
   - In "Implementation Details": `Following guidelines from [[04-Backend/UI-GUIDELINES.md]]`

2. **Update Tags**:
   - Change from: `#feature`
   - To: `#feature #ui #theme #darkmode`

3. **Enhance Example**:
   - Add code snippet:
     ```dart
     ThemeMode switching:
     final ThemeMode mode = Ref.watch(themeProvider);
     return MaterialApp(
       themeMode: mode,
       // ... rest of app
     );
     ```

### 🎯 Overall Assessment
**Ready with Minor Improvements** - The note follows most conventions well and would benefit from the suggested enhancements.
```

## How to Use
When you want to validate new content before adding it to your knowledge base:
1. Invoke this skill with: "creation-janitor: [paste the new note content or describe what to check]"
2. Optionally specify the intended location: "creation-janitor: [content] - intended for [folder/path]"
3. Review the convention compliance report
4. Implement the suggested improvements
5. Consider the note ready for addition when it passes key conventions
6. Link the new note appropriately once added

## Integration with Other Skills
- Works with **knowledge-organizer** to file janitor-approved notes appropriately
- Connects to **link-weaver** for finding link opportunities in new content
- Informs **harmonize** by ensuring new content doesn't introduce inconsistencies
- Connects to **collator** for collecting janitor reports and suggestions
- Use with **quick-append** to add content to existing notes after validation
- Connects to **cascade** for breaking down convention improvements into steps