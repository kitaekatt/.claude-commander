# Claude Code Plugins - Complete User Guide

A simple plugin system for Claude Code that works through slash command generation.

## 🚀 Quick Start

### Using Plugins

**Commands work immediately:**
1. Use slash commands directly: `/hello`, `/git checkin`, `/suggest`
2. No activation needed - commands work immediately after installation
3. Tab completion and built-in help available

### Installing New Plugins

1. Copy plugin to your project:
   ```bash
   cp -r some-plugin .claude-commands/
   ```

2. Generate commands:
   ```bash
   cd .claude-commands
   ./generate-commands.sh
   ```

3. Commands are immediately available as `/hello`, `/suggest`, etc.

## 🔌 Plugin System

**How It Works:**
- **Command-triggers:** Slash commands like `/hello`, `/git checkin`
- **Command-actions:** Sequence definitions that execute when commands are used
- **Immediate availability:** No activation required - commands work once generated

## 📁 Plugin Structure

Plugins are directories containing:
```
my-plugin/
├── PLUGIN.json        # Plugin definition with command-triggers and command-actions
└── helper.sh          # Helper scripts (optional)
```

A generation script converts plugin definitions into Claude Code slash commands stored in `.claude/commands/`.

## 🎯 Available Plugins

### Hello World Plugin
```
hello-world/
└── PLUGIN.json         # Defines "/hello" command with greeting action
```

**Usage:** `/hello`

### Git Checkin Workflow Plugin
```
git-checkin-workflow/
└── PLUGIN.json         # Git commit workflows with smart suggestions
```

**Usage:** `/git checkin` or `/git checkin --fast`

### Suggest Next Steps Plugin
```
suggest-next-steps/
└── PLUGIN.json         # Workflow enhancement suggestions
```

**Usage:** `/suggest`

### Local Commands Plugin
```
local-commands/
├── PLUGIN.json         # Command creation framework
├── PLUGIN-local.json   # User-created commands (git-ignored)
└── manage-commands.sh  # Helper script for command management
```

**Usage:** `/create command`

## 🔧 Creating Your Own Plugin

### Step 1: Create Plugin Directory

```bash
mkdir .claude-commands/my-plugin
```

### Step 2: Create PLUGIN.json

Create `my-plugin/PLUGIN.json`:

```json
{
  "commands": [
    {"command-trigger": "command-action-name"}
  ],
  "sequences": [
    {"command-action-name": {
      "instructions": "Natural language description of what to do"
    }}
  ]
}
```

### Step 3: Define Command-Action Types

Command-actions use the following fields:

- `instructions`: Natural language instructions for Claude to follow
- `sequence`: Array of steps for multi-step workflows (optional)

### Step 4: Generate Commands

```bash
cd .claude-commands
./generate-commands.sh
```

Your plugin is now available as slash commands!

### Example: Timer Plugin

**PLUGIN.json:**
```json
{
  "commands": [
    {"start timer": "start-timer-action"},
    {"stop timer": "stop-timer-action"},
    {"show timers": "show-timers-action"}
  ],
  "sequences": [
    {"start-timer-action": {
      "instructions": "Note the current time and ask what task is being timed"
    }},
    {"stop-timer-action": {
      "instructions": "Calculate elapsed time since timer started and report it"
    }},
    {"show-timers-action": {
      "instructions": "Display all active timers with their start times"
    }}
  ]
}
```

**Generated Commands:** `/start timer`, `/stop timer`, `/show timers`

### Example: Git Helper Plugin

**PLUGIN.json:**
```json
{
  "commands": [
    {"git status": "git-status-action"},
    {"show changes": "git-diff-action"},
    {"list branches": "git-branches-action"}
  ],
  "sequences": [
    {"git-status-action": {
      "instructions": "Show git repository status"
    }},
    {"git-diff-action": {
      "instructions": "Show uncommitted changes"
    }},
    {"git-branches-action": {
      "instructions": "List all git branches"
    }}
  ]
}
```

**Generated Commands:** `/git status`, `/show changes`, `/list branches`

## 📤 Plugin Distribution

The entire `.claude-commands/` directory is designed to be self-contained:
```bash
# Share your plugins via git
cd .claude-commands
git init
git add .
git commit -m "My Claude Code plugins"
git push

# Use in another project
cd my-other-project
git clone <plugin-repo> .claude-commands
./claude-commands/generate-commands.sh
# Commands immediately available
```

## 🧠 Philosophy

- **Simple**: If it takes more than 5 minutes to understand, it's too complex
- **Native**: Use Claude Code's slash command system directly
- **Practical**: Build plugins that solve real problems
- **Transparent**: You can see exactly what each plugin does

## 🔍 Current Features

### Slash Command System
- ✅ Native Claude Code integration
- ✅ Tab completion and help
- ✅ Parameterized commands (`/git checkin --fast`)
- ✅ Immediate availability (no activation needed)
- ✅ Auto-generated from plugin definitions

## ✅ Best Practices

1. **Keep command-triggers simple** - Use natural phrases users would type
2. **Clear command-action names** - Use descriptive action names
4. **Test your JSON** - Ensure valid JSON syntax
5. **One purpose per plugin** - Keep plugins focused

## 💡 Tips

- Start with a single command/sequence pair
- Test with `generate-commands.sh` after each change
- Use existing plugins as templates  
- Keep the JSON structure flat and simple

## 🔧 Troubleshooting

### Commands Not Available
1. Run `./generate-commands.sh` to regenerate command definitions
2. Check that `.claude/commands/` directory contains your command files
3. Verify your PLUGIN.json files have valid JSON syntax
4. Restart Claude Code if commands don't appear

### Creating Plugins
1. Always test your PLUGIN.json syntax
2. Keep command-triggers simple and clear
3. Write descriptive command-action definitions
4. Test plugins after running generate-commands.sh

## 🤝 Contributing

Make plugins that:
- Solve real problems
- Are easy to understand
- Include clear documentation
- Work reliably

Submit your plugins as PRs to the main project.

## 📋 Example Usage

```
# Commands work immediately
/hello
🌟 Hello! I'm excited to help you build something amazing today! What are you working on?

/git checkin
[executes git status, adds files, shows diff, suggests commit message]
Based on the changes, I suggest this commit message:
"Update plugin system documentation and add git workflow"

Would you like to use this message or provide your own?

/git checkin --fast
[executes full git checkin workflow with auto-generated message]
```

## 🎉 Sequential Workflows

Plugins can define multi-step workflows using the `sequence` field:

```json
{"my-workflow": {
  "instructions": "Execute the following sequence",
  "sequence": [
    "Step 1 description",
    "Step 2 description", 
    "Step 3 description"
  ]
}}
```

Claude will create a todo list and execute each step in order.

Happy plugin building!

## 📚 Additional Resources

- **[ClaudeCodeFeatures.md](./ClaudeCodeFeatures.md)** - Comprehensive guide to Claude Code capabilities and when to consult documentation for specific features like hooks, sub-agents, MCP resources, and integrations