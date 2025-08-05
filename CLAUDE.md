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

Plugins are individual command files in the `commands/` directory:
```
commands/
├── hello.md           # Hello world command
├── git.md             # Git workflow commands
├── suggest.md         # Suggestion commands
└── my-command.md      # Your custom command
```

The generation script copies these `.md` files directly to `.claude/commands/` where Claude Code discovers them as slash commands.

## 🎯 Available Plugins

### Hello World Command
```
commands/hello.md       # Defines "/hello" command with greeting action
```

**Usage:** `/hello`

### Git Workflow Commands
```
commands/git.md         # Git commit workflows with smart suggestions
```

**Usage:** `/git commit` or `/git commit-fast`

### Suggest Next Steps Command
```
commands/suggest.md     # Workflow enhancement suggestions
```

**Usage:** `/suggest`

### Plugin Management Commands
```
commands/plugin.md      # Plugin system management
```

**Usage:** `/plugin list`, `/plugin create`, `/plugin generate`

## 🔧 Creating Your Own Plugin

### Step 1: Create Command File

Create a new `.md` file in the `commands/` directory:

```bash
touch .claude-commands/commands/my-command.md
```

### Step 2: Define Command Structure

Edit your command file with this structure:

```markdown
---
description: "my-command description"
argument-hint: "optional | arguments"
---

\`\`\`json
{
  "instructions": "Natural language description of what to do",
  "sequences": [
    {"default": "Default action when no arguments provided"},
    {"action-name": "Action for specific arguments"}
  ]
}
\`\`\`
```

### Step 3: Generate Commands

```bash
cd .claude-commands
./generate-commands.sh
```

Your command is now available as `/my-command`!

### Example: Timer Command

**commands/timer.md:**
```markdown
---
description: "Timer management commands"
argument-hint: "start | stop | show"
---

\`\`\`json
{
  "instructions": "Identify the sequence to follow based on command parameters and execute the sequence of instructions in order. If you encounter errors, present them to the user.",
  "sequences": [
    {"default": "Show available timer commands: start, stop, show"},
    {"start": "Note the current time and ask what task is being timed"},
    {"stop": "Calculate elapsed time since timer started and report it"},
    {"show": "Display all active timers with their start times"}
  ]
}
\`\`\`
```

**Generated Commands:** `/timer start`, `/timer stop`, `/timer show`

### Example: Git Helper Command

**commands/git-helper.md:**
```markdown
---
description: "Git helper commands"
argument-hint: "status | changes | branches"
---

\`\`\`json
{
  "instructions": "Identify the sequence to follow based on command parameters and execute the sequence of instructions in order. If you encounter errors, present them to the user.",
  "sequences": [
    {"default": "Show available git helper commands: status, changes, branches"},
    {"status": "Show git repository status"},
    {"changes": "Show uncommitted changes"},
    {"branches": "List all git branches"}
  ]
}
\`\`\`
```

**Generated Commands:** `/git-helper status`, `/git-helper changes`, `/git-helper branches`

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

1. **Keep command names simple** - Use natural phrases users would type
2. **Clear sequence names** - Use descriptive action names for sequences
3. **Test your JSON** - Ensure valid JSON syntax in the embedded code block
4. **One purpose per command** - Keep commands focused
5. **Use argument-hint** - Help users understand available options

## 💡 Tips

- Start with a single command with default sequence
- Test with `generate-commands.sh` after each change
- Use existing commands as templates  
- Keep the JSON structure flat and simple
- Edit `.md` files directly - what you see is what gets deployed

## 🔧 Troubleshooting

### Commands Not Available
1. Run `./generate-commands.sh` to regenerate command definitions
2. Check that `.claude/commands/` directory contains your command files
3. Verify your `.md` files have valid JSON syntax in the code blocks
4. Restart Claude Code if commands don't appear

### Creating Commands
1. Always test your JSON syntax in the code block
2. Keep command names simple and clear
3. Write descriptive sequence definitions
4. Test commands after running generate-commands.sh

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