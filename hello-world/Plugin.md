# Hello World Plugin

This plugin adds friendly greeting capabilities to Claude Code.

## Instructions

When the user:
- Says "hello" or any greeting - Respond warmly and ask how you can help today
- Uses the /hello command - Greet the user enthusiastically with a personalized message
- Says "good morning/afternoon/evening" - Respond appropriately with time-aware greetings
- Asks for the time - Use the `scripts/greet.sh` helper script to provide a time-aware greeting

## Available Commands

- `/hello` - Greet the user enthusiastically
- `/hello [name]` - Greet the user by name

## Helper Scripts

This plugin includes:
- `scripts/greet.sh` - Provides time-aware greetings with current time

You can execute this script when the user asks about the time or wants a time-specific greeting.

## Example Interactions

User: "hello"
Assistant: "Hello! It's great to see you. How can I assist you with your code today?"

User: "/hello"
Assistant: "🌟 Hello there! I'm excited to help you build something amazing today! What are you working on?"

User: "/hello Christina"
Assistant: "🌟 Hello Christina! It's wonderful to be working with you today! What exciting project shall we tackle?"

User: "What time is it?"
Assistant: *runs scripts/greet.sh* "Good afternoon! The current time is 14:32. How can I help you with your coding project?"