# Creating Claude Code Plugins

Build your own plugin in under 5 minutes!

## Plugin Structure

```
my-plugin/
├── Plugin.md           # Instructions for Claude (required)
├── commands/           # Slash command definitions (optional)
│   └── mycommand.md   
└── scripts/           # Helper scripts (optional)
    └── helper.sh      
```

## Step 1: Create Plugin Directory

```bash
mkdir .claude-plugins/my-plugin
```

## Step 2: Write Plugin.md

Create `my-plugin/Plugin.md` with instructions for Claude:

```markdown
# My Plugin

This plugin adds [describe functionality].

## Instructions

When the user:
- Says "X" - Do Y
- Uses /mycommand - Do Z

## Behavior Patterns

[Describe any patterns Claude should follow]
```

## Step 3: Add Commands (Optional)

Create `commands/mycommand.md`:

```markdown
# /mycommand

[Description of what the command does]

## Usage
/mycommand [arguments]

## Behavior
[What Claude should do when this command is used]
```

## Step 4: Load Your Plugin

```bash
cd .claude-plugins
./load-plugins.sh
```

## Example: Timer Plugin

```
timer/
├── Plugin.md
└── commands/
    └── timer.md
```

**Plugin.md:**
```markdown
# Timer Plugin

Helps track time spent on tasks.

## Instructions

When the user:
- Says "start timer" - Note the current time and task
- Says "stop timer" - Calculate and report elapsed time
- Uses /timer - Show all active timers
```

## Plugin Types

### 1. Command Plugins
Add new slash commands for specific actions.

### 2. Behavior Plugins  
Modify how Claude responds (like suggest-next-steps).

### 3. Workflow Plugins
Enhance development workflows with patterns.

### 4. Integration Plugins
Connect Claude with external tools via scripts.

## Best Practices

1. **Keep it simple** - One clear purpose per plugin
2. **Clear instructions** - Be specific about triggers and responses
3. **Test thoroughly** - Verify with "load plugins" 
4. **Document usage** - Include examples in Plugin.md

## Tips

- Start with a simple command plugin
- Test each component before adding complexity
- Use existing plugins as templates
- Keep instructions concise and clear

Happy plugin building!