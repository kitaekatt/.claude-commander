# /suggest-steps Command

Manually trigger next step suggestions for the current context.

## Usage
```
/suggest-steps
```

## Behavior
When invoked, analyze the current conversation context and:
1. Generate up to 6 possible next steps
2. Evaluate and prioritize them
3. Present the top 3 options to the user

This is useful when:
- The automatic suggestions were not triggered
- The user wants fresh suggestions mid-conversation
- You need to re-evaluate next steps after significant context changes

## Response Format
```
Based on our current context, here are suggested next steps:

1. [First suggestion with brief explanation]
2. [Second suggestion with brief explanation]  
3. [Third suggestion with brief explanation]

Reply with 1, 2, or 3 to proceed with that option.
```