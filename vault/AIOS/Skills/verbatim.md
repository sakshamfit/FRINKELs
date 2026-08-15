# verbatim - Captures Exact Quotes and Important Text

## Purpose
Captures and preserves exact quotes, code snippets, configurations, or important text verbatim for future reference, ensuring nothing is lost in translation or summarization.

## Triggers
- "verbatim:"
- "capture this exactly"
- "save verbatim"
- "preserve this text"
- "exact copy"

## Dependencies
None - works by taking the provided text and formatting it for preservation.

## Instructions
1. **Accept Input**: Take the exact text to be preserved (quote, code, config, etc.)
2. **Identify Source**: Determine where the text came from (if provided)
3. **Add Metadata**: Include timestamp, source context, and any relevant tags
4. **Format for Preservation**: Wrap in appropriate markdown for clarity and future use
5. **Suggest Location**: Recommend where to save the verbatim capture
6. **Provide Usage Ideas**: Suggest how this captured text might be used later

## Output
- The exact input text preserved unchanged
- Source attribution (if provided)
- Timestamp of capture
- Suggested tags for organization
- Recommended file path for storage
- Ideas for future use or linking

## Example
**Input**: "verbatim: paste this error message exactly: StateError: setState() called after dispose(): _HomeScreenState#9876a(life cycle: defunct, not mounted)"

**Output**:
```
# Verbatim Capture - StateError in HomeScreenState
**Captured**: 2026-08-15 14:30:22
**Source**: Error encountered during FRINKELS home screen navigation testing
**Tags**: #error #flutter #stateerror #verbatim

---

StateError: setState() called after dispose(): _HomeScreenState#9876a(life cycle: defunct, not mounted)

---

## 💡 Suggested Uses
- Add to troubleshooting documentation for home screen navigation
- Include in error-decoder skill examples
- Reference when debugging similar setState-after-dispose issues
- Link from AUTHENTICATION.md if related to auth state management
- Save as: `01-Troubleshooting/SETSTATE-AFTER-DISPOSE.md`
```

## How to Use
When you need to preserve exact text:
1. Invoke this skill with: "verbatim: [paste the exact text to preserve]"
2. Optionally provide source context: "verbatim: [text] (from error log, conversation, etc.)"
3. Review the formatted capture with metadata
4. Save to the suggested location or choose your own
5. Consider linking to related notes where this exact text is relevant
6. Use the captured text exactly as needed without worrying about misquotation

## Integration with Other Skills
- Works with **error-decoder** for preserving exact error messages
- Connects to **knowledge-organizer** for filing verbatim captures
- Links to **quick-append** for adding to existing documentation
- Informs **summarizer** by providing source material
- Connects to **collator** for collecting related verbatim captures
- Use with **sanitize** to ensure proper formatting and linking