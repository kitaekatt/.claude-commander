# Claude Code Plugins - Complete User Guide

A simple plugin system for Claude Code that works through configuration augmentation.

## 🚀 Quick Start (< 5 minutes)

### Using Existing Plugins

1. **Activate plugins** in Claude Code by saying **"load plugins"**
2. Claude responds: "✅ Plugins loaded. Checking PLUGINS.json before all responses."
3. Use plugin commands like "hello" or "git status"

### Installing New Plugins

1. Copy plugin to your project:
   ```bash
   cp -r some-plugin .claude-plugins/
   ```

2. Aggregate plugins:
   ```bash
   cd .claude-plugins
   ./aggregate-plugins.sh
   ```

3. Activate in Claude Code by saying **"load plugins"**

## 🔌 Plugin Activation

**Plugins are INACTIVE by default.** You control when plugins are active:

**To activate:** Say **"load plugins"** in your Claude Code session.

**During Active Plugin Mode:**
1. Claude evaluates your messages against command triggers from PLUGINS.json
2. If a message matches a trigger, Claude executes the associated process
3. Only uses standard response if no trigger matches
4. Plugin definitions remain in context - no need to reload

**Re-initialization:** Say "load plugins" again to reinforce adherence.

## 🛠️ What This Is

This project creates plugins for Claude Code using its existing capabilities:
- JSON-based triggers and processes in PLUGIN.json files
- Natural language command triggers
- Structured process definitions
- Helper scripts that Claude can execute

**No complex infrastructure. No runtime code. Just configuration that works.**

## 📁 How It Works

Plugins are directories containing:
```
my-plugin/
├── PLUGIN.json        # Plugin definition with triggers and processes
└── helper.sh          # Helper scripts (optional)
```

A simple script combines all plugin definitions into PLUGINS.json. You control when plugins are active.

## 🎯 Available Plugins

### Hello World Plugin
```
hello-world/
└── PLUGIN.json         # Defines "hello" command with greeting action
```

### Local Commands Plugin
```
local-commands/
├── PLUGIN.json         # Defines "git status" and "create command" triggers
└── manage-commands.sh  # Helper script for command management
```

### Suggest Next Steps Plugin
```
suggest-next-steps/
└── PLUGIN.json         # Workflow enhancement suggestions
```

### Unload Plugins
```
unload-plugins/
└── PLUGIN.json         # Plugin deactivation command
```

## 🔧 Creating Your Own Plugin

### Step 1: Create Plugin Directory

```bash
mkdir .claude-plugins/my-plugin
```

### Step 2: Create PLUGIN.json

Create `my-plugin/PLUGIN.json`:

```json
{
  "commands": [
    {"trigger phrase": "process-name"}
  ],
  "processes": [
    {"process-name": {
      "action": "Natural language description of what to do",
      "description": "Brief description for documentation"
    }}
  ]
}
```

### Step 3: Define Process Types

Processes can use specific fields for clarity:

- `action`: Natural language instructions
- `execute-bash-command`: Shell command to run
- `read-file`: File to read
- `search-pattern`: Pattern to search for
- `description`: What this process does

### Step 4: Aggregate Plugins

```bash
cd .claude-plugins
./aggregate-plugins.sh
```

### Example: Timer Plugin

**PLUGIN.json:**
```json
{
  "commands": [
    {"start timer": "start-timer-action"},
    {"stop timer": "stop-timer-action"},
    {"show timers": "show-timers-action"}
  ],
  "processes": [
    {"start-timer-action": {
      "action": "Note the current time and ask what task is being timed",
      "description": "Start tracking time for a task"
    }},
    {"stop-timer-action": {
      "action": "Calculate elapsed time since timer started and report it",
      "description": "Stop timer and show duration"
    }},
    {"show-timers-action": {
      "action": "Display all active timers with their start times",
      "description": "List all running timers"
    }}
  ]
}
```

### Example: Git Helper Plugin

**PLUGIN.json:**
```json
{
  "commands": [
    {"git status": "git-status-action"},
    {"show changes": "git-diff-action"},
    {"list branches": "git-branches-action"}
  ],
  "processes": [
    {"git-status-action": {
      "execute-bash-command": "git status",
      "description": "Show git repository status"
    }},
    {"git-diff-action": {
      "execute-bash-command": "git diff",
      "description": "Show uncommitted changes"
    }},
    {"git-branches-action": {
      "execute-bash-command": "git branch -a",
      "description": "List all git branches"
    }}
  ]
}
```

## 📤 Plugin Distribution

The entire `.claude-plugins/` directory is designed to be self-contained:
```bash
# Share your plugins via git
cd .claude-plugins
git init
git add .
git commit -m "My Claude Code plugins"
git push

# Use in another project
cd my-other-project
git clone <plugin-repo> .claude-plugins
./claude-plugins/aggregate-plugins.sh
# Say "load plugins" in Claude Code to activate
```

## 🧠 Philosophy

- **Simple**: If it takes more than 5 minutes to understand, it's too complex
- **Native**: Use Claude Code's existing features, don't reinvent them
- **Practical**: Build plugins that solve real problems
- **Transparent**: You can see exactly what each plugin does

## 🔍 Current Limitations

- One command per process (no multiple triggers yet)
- No slash commands (use natural language triggers)
- Commands and processes are defined separately
- Plugins are loaded globally when activated

## ✅ Best Practices

1. **Keep triggers simple** - Use natural phrases users would type
2. **Clear process names** - Use descriptive action names
3. **Specific field types** - Use `execute-bash-command` for shell commands
4. **Test your JSON** - Ensure valid JSON syntax
5. **One purpose per plugin** - Keep plugins focused

## 💡 Tips

- Start with a single command/process pair
- Test with `aggregate-plugins.sh` after each change
- Use existing plugins as templates
- Keep the JSON structure flat and simple

## 🔧 Troubleshooting

### Plugins Not Working
1. Ensure you said "load plugins" in your Claude Code session
2. Check that PLUGINS.json exists in .claude-plugins directory
3. Run `./aggregate-plugins.sh` to regenerate plugin definitions
4. Verify your PLUGIN.json files have valid JSON syntax

### Creating Plugins
1. Always test your PLUGIN.json syntax
2. Keep command triggers simple and clear
3. Write descriptive process definitions
4. Test plugins after running aggregate-plugins.sh

## 🤝 Contributing

Make plugins that:
- Solve real problems
- Are easy to understand
- Include clear documentation
- Work reliably

Submit your plugins as PRs to the main project.

## 📋 Example Usage

```
You: hello
Claude: Hello! It's great to see you. How can I assist you with your code today?

You: git status
Claude: [executes git status command and shows output]

You: load plugins
Claude: ✅ Plugins loaded. Checking PLUGINS.json before all responses.
```

Happy plugin building!