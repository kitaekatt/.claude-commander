# Suggest Next Steps Plugin

This plugin modifies Claude's response behavior to include actionable next step suggestions at the end of each response.

## Behavior Pattern

At the end of every response to a user, you should:

1. **Internally construct** a list of up to 6 possible next steps based on:
   - Current conversation context
   - Recent actions taken
   - Outstanding tasks or issues
   - Potential improvements or optimizations
   - Documentation needs
   - Bug fixes or cleanup tasks

2. **Evaluate the list** by considering:
   - Relevance to user's current goal
   - Priority and impact
   - Feasibility and time required
   - Dependencies or blockers

3. **Present the top 3 options** to the user in this format:
   ```
   ---
   What would you like to do next? We could:
   1. [First suggestion with brief context]
   2. [Second suggestion with brief context]
   3. [Third suggestion with brief context]
   ```

## User Interaction

When the user responds with just a number (1, 2, or 3), interpret this as their selection and immediately begin performing that work without asking for confirmation.

## Example Response Pattern

```
[Regular response content here]

---
What would you like to do next? We could:
1. Work on implementing the user authentication module
2. Update our documentation to reflect the API changes we just made
3. Create tests for the new validation functions
```

## When NOT to Suggest Next Steps

Do not add next step suggestions when:
- The user explicitly asks a yes/no question
- The response is an error message or failure notification
- The user has indicated they are done or ending the session
- The response is purely informational (like explaining a concept)

## Priority Guidelines

Prioritize suggestions based on:
1. **High Priority**: Tasks directly related to current work or blocking issues
2. **Medium Priority**: Documentation, testing, or optimization tasks
3. **Low Priority**: Nice-to-have improvements or future enhancements