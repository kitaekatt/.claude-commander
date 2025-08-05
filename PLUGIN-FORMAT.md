# PLUGIN.json Format Documentation

## Overview

PLUGIN.json defines a Claude Code plugin's command-actions. **Plugins are actions triggered by slash commands** - when you type `/hello` or `/git fast`, Claude Code loads the corresponding plugin and executes the defined actions.

The plugin directory name becomes the command name exactly (e.g., `hello/` becomes `/hello`), and the PLUGIN.json file defines what actions Claude should take when that command is invoked.

## Two Plugin Formats

### Format 1: Simple Single-Step Plugins

For plugins that perform a single action with no parameters.

**Command**: `/hello` (from `hello/` directory)  
**Purpose**: Greet the user with an encouraging message

```json
{
  "instructions": "Respond with '🌟 Hello! I'm excited to help you build something amazing today! What are you working on?'"
}
```

### Format 2: Parameter-Based Multi-Step Plugins  

For plugins that support parameters and/or multiple steps.

**Command**: `/git` (from `git/` directory)  
**Purpose**: Git operations with multiple subcommands  
**Usage**: `/git` (show help), `/git status`, `/git commit`, `/git commit-fast`

```json
{
  "instructions": "Identify the sequence to follow based on command parameters and execute the sequence of instructions in order. If you encounter errors, present them to the user.",
  "sequences": [
    {"default": "Show available git subcommands and their descriptions: 'status' (check repository state), 'commit' (interactive commit workflow), 'commit-fast' (auto-commit workflow)"},
    {"status": "Run 'git status' to check repository state and report current status"},
    {"commit": [
      "Run 'git status' to check repository state",
      "Run 'git add .' to stage all changes", 
      "Run 'git diff --staged' to review staged changes",
      "Ask user to confirm the suggested message or provide an alternative",
      "Run 'git commit -m \"<message>\"' with the confirmed message"
    ]},
    {"commit-fast": [
      "Run 'git status' to check repository state",
      "Run 'git add .' to stage all changes", 
      "Run 'git diff --staged' to review staged changes",
      "Run 'git commit -m \"<message>\"' immediately with auto-generated message"
    ]}
  ]
}
```

## Field Definitions

### instructions (required)
- **Format 1**: Natural language instruction describing the single action to perform
- **Format 2**: Standard guidance for Claude on how to interpret and execute sequences (typically the same across all plugins)

### sequences (optional, only for Format 2)
An array of parameter-to-sequence mappings. Each entry is an object with a single key (the parameter name) containing an array of step-by-step instructions.

- **"default"** (required if sequences present): Array of steps to execute when no parameters are provided
- **"parameter-name"** (optional): Array of steps to execute when that parameter is provided

**Important**: If `sequences` is present, it must include a "default" sequence to handle the no-parameter case.

## Complete Examples

### Example 1: Hello World Plugin

**Command**: `/hello` (from `hello/` directory)  
**Purpose**: Greet the user with an encouraging message  
**Usage**: `/hello`

```json
{
  "instructions": "Respond with '🌟 Hello! I'm excited to help you build something amazing today! What are you working on?'"
}
```

### Example 2: Git Workflow Plugin

**Command**: `/git` (from `git/` directory)  
**Purpose**: Git operations with multiple subcommands  
**Usage**: `/git` (show help), `/git status` (check status), `/git commit` (interactive), `/git commit-fast` (auto-commit)

```json
{
  "instructions": "Identify the sequence to follow based on command parameters and execute the sequence of instructions in order. If you encounter errors, present them to the user.",
  "sequences": [
    {"default": "Show available git subcommands and their descriptions: 'status' (check repository state), 'commit' (interactive commit workflow), 'commit-fast' (auto-commit workflow)"},
    {"status": "Run 'git status' to check repository state and report current status"},
    {"commit": [
      "Run 'git status' to check repository state",
      "Run 'git add .' to stage all changes", 
      "Run 'git diff --staged' to review staged changes",
      "Analyze the changes and suggest a commit message based on the diff",
      "Ask user to confirm the suggested message or provide an alternative",
      "Run 'git commit -m \"<message>\"' with the confirmed message"
    ]},
    {"commit-fast": [
      "Run 'git status' to check repository state",
      "Run 'git add .' to stage all changes", 
      "Run 'git diff --staged' to review staged changes",
      "Analyze the changes and generate a commit message based on the diff",
      "Run 'git commit -m \"<message>\"' immediately with the generated message"
    ]}
  ]
}
```

### Example 3: Suggest Next Steps Plugin

**Command**: `/suggest` (from `suggest/` directory)  
**Purpose**: Analyze context and suggest likely next actions  
**Usage**: `/suggest`

```json
{
  "instructions": "Analyze the current context and determine six potential next steps, present the three most likely to be selected by the user"
}
```

### Example 4: Create Command Plugin

**Command**: `/create` (from `create/` directory)  
**Purpose**: Interactive command creation wizard  
**Usage**: `/create`

```json
{
  "instructions": "Prompt for command details, generate JSON definition, and save to PLUGIN-local.json"
}
```

## Plugin Directory to Command Mapping

**Required**: Plugin directory names must exactly match the command name.

- `hello/` → `/hello` command
- `git/` → `/git` command  
- `suggest/` → `/suggest` command
- `create/` → `/create` command

## Generated Slash Commands

Each plugin becomes a slash command file containing the complete JSON structure:

**Simple plugin generates:**
```markdown
---
description: "hello command from hello plugin"
argument-hint: ""
---

```json
{
  "instructions": "Respond with '🌟 Hello! I'm excited to help you build something amazing today! What are you working on?'"
}
```

**Parameter-based plugin generates:**
```markdown
---
description: "git command from git plugin"
argument-hint: ""
---

```json
{
  "instructions": "Identify the sequence to follow based on command parameters and execute the sequence of instructions in order. If you encounter errors, present them to the user.",
  "sequences": [
    {"default": [
      "Run 'git status' to check repository state",
      "Run 'git add .' to stage all changes", 
      "Run 'git diff --staged' to review staged changes",
      "Ask user to confirm the suggested message or provide an alternative",
      "Run 'git commit -m \"<message>\"' with the confirmed message"
    ]},
    {"fast": [
      "Run 'git status' to check repository state",
      "Run 'git add .' to stage all changes", 
      "Run 'git diff --staged' to review staged changes",
      "Run 'git commit -m \"<message>\"' immediately with auto-generated message"
    ]}
  ]
}
```

## Integration

Individual PLUGIN.json files are processed by the `generate-commands.sh` script to create slash commands:

```
.claude-commands/
├── hello/
│   └── PLUGIN.json
├── git/
│   └── PLUGIN.json
├── suggest/
│   └── PLUGIN.json
├── create/
│   └── PLUGIN.json
├── generate-commands.sh
└── .claude/commands/ (generated)
    ├── hello.md
    ├── git.md
    ├── suggest.md
    └── create.md
```

## Validation Rules

- JSON must be valid (use a JSON validator)
- **Plugin directory name must exactly match the command name**
- `instructions` field is always required
- If `sequences` is present, it must include a "default" sequence
- Parameter names must be unique within the plugin  
- All sequence values must be arrays of strings (steps)
- Arrays must have at least one entry

## Best Practices

1. **Choose the right format**: Use Format 1 for simple single actions, Format 2 for parameters or multi-step workflows
2. **Clear parameter names**: Use descriptive parameter names like "fast", "verbose", "dry-run"
3. **Descriptive steps**: Write clear, actionable step descriptions
4. **Include bash commands**: Use natural language like "Run 'git status'" for shell commands
5. **Consistent instructions**: Use the standard instructions text for Format 2 plugins
6. **Test your JSON**: Validate JSON syntax before using