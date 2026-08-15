# error-decoder - Helps Understand and Resolve Error Messages

## Purpose
Assists in understanding error messages and provides step-by-step guidance for resolving them by analyzing the error context and suggesting potential solutions.

## Triggers
- "what does this mean"
- "debug error"
- "fix this error"
- "error help"
- "troubleshoot"

## Dependencies
None - works by analyzing error message text, stack traces (if provided), and context about the technology stack.

## Instructions
1. **Accept Error Input**: Take the error message, stack trace, and surrounding context
2. **Categorize Error**: Determine error type (compilation, runtime, logic, configuration, etc.)
3. **Identify Technology**: Detect which technology/framework the error relates to (Flutter, Dart, Supabase, etc.)
4. **Analyze Components**: Break down the error into actionable parts
5. **Search Patterns**: Match against common error patterns for the identified technology
6. **Generate Explanations**: Provide clear, plain-language explanation of what the error means
7. **Suggest Solutions**: Offer step-by-step resolution approaches ordered by likelihood
8. **Prevention Tips**: Suggest how to avoid similar errors in the future
9. **Escalation Path**: Indicate when to seek deeper help or consult documentation

## Output
- Error categorization and technology identification
- Plain-language explanation of the error
- Step-by-step resolution methods (most likely first)
- Prevention tips for future occurrences
- Relevant documentation links (if known)
- Escalation suggestions if standard fixes don't apply

## Example
**Input**: 
```
Error: StateError: setState() called after dispose(): _HomeScreenState#9876a(life cycle: defunct, not mounted)
```

**Analysis**:
- **Category**: Flutter Framework Error
- **Technology**: Flutter/Dart State Management
- **Meaning**: Attempting to update state on a widget that has already been disposed
- **Location**: `_HomeScreenState` in home screen widget

**Explanation**: 
This error occurs when you call `setState()` or notify listeners on a State object after its corresponding widget has been removed from the widget tree. The framework prevents this to avoid memory leaks and undefined behavior.

**Resolution Steps**:
1. **Check Async Operations**: Ensure any async operations (network calls, timers) are cancelled in `dispose()`
2. **Validate Mounted State**: Use `if (mounted) { setState(() { ... }); }` before state updates
3. **Review Stream Subscriptions**: Cancel streams and close subscriptions in `dispose()`
4. **Inspect Timer Handling**: Cancel any Timers or PeriodicTimers in `dispose()`
5. **Verify Navigation**: Ensure you're not trying to update state after navigating away

**Prevention Tips**:
- Always check `mounted` property before calling `setState()` in async callbacks
- Cancel all listeners, streams, and timers in the `dispose()` method
- Use `StateMixin` or `automaticKeepAlive` carefully with proper cleanup
- Consider using Riverpod's automatic disposal instead of manual State management where applicable

**Relevant Documentation**:
- Flutter Widget lifecycle documentation
- State management best practices guide

**Escalation**: If the issue persists after checking mounted state and cleanup, provide more context about when the error occurs (specific user action, timing, etc.) for deeper analysis.

## How to Use
When you encounter an error:
1. Invoke this skill with: "error-decoder: [paste the full error message and context]"
2. Include any relevant code snippets or surrounding information
3. Review the analysis and suggested solutions
4. Try the resolutions in order of likelihood
5. If unresolved, provide additional context for further analysis