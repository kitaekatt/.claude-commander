# Claude Code Plugin System

A simple, configuration-based plugin system for Claude Code that requires no runtime modifications.

## Quick Start (< 5 minutes)

1. **Enable plugins in your project:**
   Add this line to your project's CLAUDE.md:
   ```
   # Include plugin instructions
   See .claude-plugins/PLUGINS.md for additional instructions.
   ```

2. **Load plugins:**
   ```bash
   cd .claude-plugins
   ./load-plugins.sh
   ```

3. **Activate in Claude:**
   Say "load plugins" to activate plugin behavior

## What's Included

- **hello-world/** - Example greeting plugin with commands
- **suggest-next-steps/** - Workflow enhancement plugin
- **load-plugins.sh** - Script to combine plugin instructions
- **PLUGINS.md** - Generated file with all plugin instructions

## How It Works

1. Each plugin has a `Plugin.md` file with instructions for Claude
2. The load-plugins.sh script combines all Plugin.md files into PLUGINS.md
3. Your CLAUDE.md references PLUGINS.md to give Claude the instructions
4. Claude follows these instructions when you say "load plugins"

## Creating Your Own Plugin

See CREATING-PLUGINS.md for a step-by-step guide.

## Example Usage

```
You: hello
Claude: Hello! It's great to see you. How can I assist you with your code today?

You: /hello Christina  
Claude: 🌟 Hello Christina! It's wonderful to be working with you today! What exciting project shall we tackle?
```

## Plugin Control

- **Enable**: Say "load plugins" 
- **Disable**: Say "unload plugins"
- **Manual trigger**: Use slash commands like `/hello`

That's it! Simple, practical, and ready to use.