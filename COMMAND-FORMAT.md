# Command Format Documentation

## Overview

Commands are defined as `.md` files in the `commands/` directory. **Commands are actions triggered by slash commands** - when you type `/hello` or `/git commit`, Claude Code loads the corresponding command and executes the defined actions.

The command filename becomes the command name exactly (e.g., `hello.md` becomes `/hello`), and the markdown file defines what actions Claude should take when that command is invoked.

## Command File Structure

Each command file is a markdown file with frontmatter and an embedded JSON code block:

```markdown
---
description: "Brief description of what this command does"
argument-hint: "optional | argument | hints"
---

```json
{
  "instructions": "Natural language instruction for Claude",
  "sequences": [
    {"default": "Default action when no arguments provided"},
    {"parameter-name": "Action for specific arguments"}
  ]
}
```
```

## Two Command Formats

### Format 1: Simple Single-Step Commands

For commands that perform a single action with no parameters.

**File**: `commands/hello.md`  
**Command**: `/hello`  
**Purpose**: Greet the user with an encouraging message

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
```

### Format 2: Parameter-Based Multi-Step Commands  

For commands that support parameters and/or multiple steps.

**File**: `commands/git.md`  
**Command**: `/git`  
**Purpose**: Git operations with multiple subcommands  
**Usage**: `/git` (show help), `/git status`, `/git commit`, `/git commit-fast`

```markdown
---
description: "git command from git plugin"
argument-hint: "status | commit | commit-fast"
---

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
```

## Field Definitions

### Frontmatter Fields

- **description** (required): Brief description shown in Claude Code command help
- **argument-hint** (optional): Hints shown to users about available arguments/parameters

### JSON Fields

- **instructions** (required): 
  - **Format 1**: Natural language instruction describing the single action to perform
  - **Format 2**: Standard guidance for Claude on how to interpret and execute sequences (typically the same across all commands)

- **sequences** (optional, only for Format 2): Array of parameter-to-sequence mappings. Each entry is an object with a single key (the parameter name) containing either a string or array of step-by-step instructions.
  - **"default"** (required if sequences present): Action or steps to execute when no parameters are provided
  - **"parameter-name"** (optional): Action or steps to execute when that parameter is provided

**Important**: If `sequences` is present, it must include a "default" sequence to handle the no-parameter case.

## Complete Examples

### Example 1: Hello World Command

**File**: `commands/hello.md`  
**Command**: `/hello`  
**Purpose**: Greet the user with an encouraging message  
**Usage**: `/hello`

```markdown
---
description: "Friendly greeting command"
argument-hint: ""
---

```json
{
  "instructions": "Respond with '🌟 Hello! I'm excited to help you build something amazing today! What are you working on?'"
}
```
```

### Example 2: Timer Management Command

**File**: `commands/timer.md`  
**Command**: `/timer`  
**Purpose**: Timer management with multiple operations  
**Usage**: `/timer` (show help), `/timer start`, `/timer stop`, `/timer show`

```markdown
---
description: "Timer management commands"
argument-hint: "start | stop | show"
---

```json
{
  "instructions": "Identify the sequence to follow based on command parameters and execute the sequence of instructions in order. If you encounter errors, present them to the user.",
  "sequences": [
    {"default": "Show available timer commands: start, stop, show"},
    {"start": "Note the current time and ask what task is being timed"},
    {"stop": "Calculate elapsed time since timer started and report it"},
    {"show": "Display all active timers with their start times"}
  ]
}
```
```

### Example 3: Multi-Step Workflow Command

**File**: `commands/deploy.md`  
**Command**: `/deploy`  
**Purpose**: Application deployment workflow  
**Usage**: `/deploy` (show help), `/deploy staging`, `/deploy production`

```markdown
---
description: "Application deployment workflows"
argument-hint: "staging | production"
---

```json
{
  "instructions": "Identify the sequence to follow based on command parameters and execute the sequence of instructions in order. If you encounter errors, present them to the user.",
  "sequences": [
    {"default": "Show available deployment targets: staging, production"},
    {"staging": [
      "Run 'npm run build' to build the application",
      "Run 'npm run test' to ensure all tests pass",
      "Run deployment script for staging environment",
      "Verify deployment was successful"
    ]},
    {"production": [
      "Confirm this is a production deployment",
      "Run 'npm run build' to build the application",
      "Run 'npm run test' to ensure all tests pass",
      "Run deployment script for production environment",
      "Verify deployment was successful",
      "Notify team of successful deployment"
    ]}
  ]
}
```
```

## Command File to Command Mapping

**Required**: Command filenames must exactly match the desired command name.

- `hello.md` → `/hello` command
- `git.md` → `/git` command  
- `timer.md` → `/timer` command
- `my-tool.md` → `/my-tool` command

## Generated Slash Commands

The generation script copies command files directly to `.claude/commands/` where Claude Code discovers them:

```
.claude-commands/
├── commands/
│   ├── hello.md
│   ├── git.md
│   ├── timer.md
│   └── my-tool.md
├── generate-commands.sh
└── .claude/commands/ (generated)
    ├── hello.md
    ├── git.md
    ├── timer.md
    └── my-tool.md
```

## Integration Workflow

1. **Create**: Create or edit `.md` files in `commands/` directory
2. **Generate**: Run `./generate-commands.sh` to copy files to `.claude/commands/`
3. **Use**: Commands are immediately available as slash commands in Claude Code

## Validation Rules

- Markdown frontmatter must be valid YAML
- JSON must be valid (use a JSON validator)
- **Command filename must exactly match the desired command name**
- `instructions` field is always required
- If `sequences` is present, it must include a "default" sequence
- Parameter names must be unique within the command  
- Sequence values can be strings (single action) or arrays of strings (multi-step)
- Arrays must have at least one entry

## Best Practices

1. **Choose the right format**: Use Format 1 for simple single actions, Format 2 for parameters or multi-step workflows
2. **Clear parameter names**: Use descriptive parameter names like "fast", "verbose", "staging"
3. **Descriptive steps**: Write clear, actionable step descriptions
4. **Include shell commands**: Use natural language like "Run 'git status'" for shell commands
5. **Consistent instructions**: Use the standard instructions text for Format 2 commands
6. **Helpful argument hints**: Use the argument-hint field to guide users
7. **Test your JSON**: Validate JSON syntax before using
8. **Direct editing**: Edit command files directly - what you see is what gets deployed

## Creating New Commands

### Quick Start Template

```markdown
---
description: "Description of your command"
argument-hint: "param1 | param2"
---

```json
{
  "instructions": "Identify the sequence to follow based on command parameters and execute the sequence of instructions in order. If you encounter errors, present them to the user.",
  "sequences": [
    {"default": "Show available options or perform default action"},
    {"param1": "Action for parameter 1"},
    {"param2": [
      "Step 1 for parameter 2",
      "Step 2 for parameter 2",
      "Step 3 for parameter 2"
    ]}
  ]
}
```
```

### Simple Command Template

```markdown
---
description: "Description of your simple command"
argument-hint: ""
---

```json
{
  "instructions": "Single action description here"
}
```
```

## Troubleshooting

### Commands Not Appearing
1. Check filename matches desired command name
2. Validate markdown frontmatter syntax
3. Validate JSON syntax in code block
4. Run `./generate-commands.sh` to regenerate
5. Restart Claude Code if needed

### JSON Validation Errors
1. Use a JSON validator online
2. Check for missing commas, quotes, or brackets
3. Ensure all strings are properly quoted
4. Verify array and object syntax

### Command Not Working as Expected
1. Check the `instructions` field is clear and actionable
2. Verify sequence names match the parameters you're using
3. Test with simple instructions first, then add complexity
4. Review existing working commands as examples