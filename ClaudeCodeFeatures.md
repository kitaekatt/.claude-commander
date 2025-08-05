# Claude Code Capability Guide

This document helps Claude Code determine which documentation to read based on context. Each section explains core functionality and when consultation might be helpful.

## Interactive Commands

**[Slash commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands)**
- Built-in commands: `/help`, `/config`, `/cost` for mid-session control
- Custom command support via Markdown files with arguments and namespacing
- **Read when**: Users ask about available commands or you need to explain command syntax/behavior

**[Settings](https://docs.anthropic.com/en/docs/claude-code/settings)**
- Hierarchical configuration system (user → project → enterprise)
- Controls permissions, tools, and operational scope
- Configurable via files, environment variables, and `/config` command
- **Read when**: Questions arise about what you can/cannot do or why certain capabilities are available/restricted

## Extension Systems

**[Hooks](https://docs.anthropic.com/en/docs/claude-code/hooks)**
- Shell command triggers at lifecycle events (PreToolUse, PostToolUse, Notification, Stop)
- Enables automated formatting, logging, notifications, permission controls
- **Read when**: Unexpected automated behaviors occur or users inquire about extending functionality

**[Sub agents](https://docs.anthropic.com/en/docs/claude-code/sub-agents)**
- Spawn specialized AI assistants with isolated contexts
- Custom prompts and tool permissions for specific tasks
- **Read when**: Users request complex task delegation or you need to preserve context while handling specialized work

**[MCP resources](https://docs.anthropic.com/en/docs/claude-code/mcp)**
- Model Context Protocol server connections
- Access to external tools, databases, and APIs
- **Read when**: You encounter unfamiliar tools/resources or users ask about extending your capabilities

## Integration Options

**[SDK documentation](https://docs.anthropic.com/en/docs/claude-code/sdk)**
- TypeScript, Python, CLI integration options
- **Read when**: Users discuss embedding you in their applications or automation workflows

**[GitHub Actions](https://docs.anthropic.com/en/docs/claude-code/github-actions)**
- Automated code review and PR creation in workflows
- **Read when**: GitHub workflow integration or automated PR processes are discussed

## Reading Strategy
- Documentation serves to clarify your capabilities when context requires it
- No need to preemptively understand all features
- Consult relevant sections when collaboration would benefit from deeper understanding