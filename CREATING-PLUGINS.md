# Creating Claude Code Plugins

Build your own plugin in under 5 minutes!

## Plugin Structure

```
my-plugin/
├── PLUGIN.json        # Plugin definition (required)
└── scripts/           # Helper scripts (optional)
    └── helper.sh      
```

## Plugin Format

Plugins use a simple JSON format with two main components:

1. **Commands**: Trigger strings that activate processes
2. **Processes**: Actions to perform when triggered

## Step 1: Create Plugin Directory

```bash
mkdir .claude-plugins/my-plugin
```

## Step 2: Create PLUGIN.json

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

## Step 3: Define Process Types

Processes can use specific fields for clarity:

- `action`: Natural language instructions
- `execute-bash-command`: Shell command to run
- `read-file`: File to read
- `search-pattern`: Pattern to search for
- `description`: What this process does

## Step 4: Aggregate Plugins

```bash
cd .claude-plugins
./aggregate-plugins.sh
```

## Example: Timer Plugin

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

## Example: Git Helper Plugin

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

## Current Limitations

- One command per process (no multiple triggers yet)
- No slash commands (use natural language triggers)
- Commands and processes are defined separately
- Plugins are loaded globally when activated

## Best Practices

1. **Keep triggers simple** - Use natural phrases users would type
2. **Clear process names** - Use descriptive action names
3. **Specific field types** - Use `execute-bash-command` for shell commands
4. **Test your JSON** - Ensure valid JSON syntax
5. **One purpose per plugin** - Keep plugins focused

## Tips

- Start with a single command/process pair
- Test with `aggregate-plugins.sh` after each change
- Use existing plugins as templates
- Keep the JSON structure flat and simple

Happy plugin building!