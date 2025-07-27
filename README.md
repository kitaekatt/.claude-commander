# Claude Code Plugin System

A simple, JSON-based plugin system for Claude Code that uses triggers and processes to extend functionality.

## Quick Start (< 5 minutes)

1. **Aggregate plugins:**
   ```bash
   cd .claude-plugins
   ./aggregate-plugins.sh
   ```

2. **Activate in Claude:**
   Say "load plugins" to activate plugin behavior

## What's Included

- **hello-world/** - Example greeting plugin
- **suggest-next-steps/** - Workflow enhancement plugin  
- **local-commands/** - Dynamic command creation plugin
- **unload-plugins/** - Plugin deactivation command
- **aggregate-plugins.sh** - Script to combine plugin JSON files
- **PLUGINS.json** - Generated file with all plugin definitions

## How It Works

1. Each plugin has a `PLUGIN.json` file defining triggers and processes
2. Triggers are simple strings that activate specific processes
3. Processes define actions using structured JSON
4. The aggregate-plugins.sh script combines all PLUGIN.json files
5. Claude loads these definitions when you say "load plugins"

## Creating Your Own Plugin

See CREATING-PLUGINS.md for a step-by-step guide.

## Example Usage

```
You: hello
Claude: Hello! It's great to see you. How can I assist you with your code today?

You: git status
Claude: [executes git status command and shows output]
```

## Plugin Control

- **Enable**: Say "load plugins" 
- **Triggers**: Natural language phrases like "hello" or "git status"

That's it! Simple, practical, and ready to use.