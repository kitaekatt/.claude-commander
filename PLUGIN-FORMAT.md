# PLUGIN.json Format Documentation

## Overview

PLUGIN.json defines a Claude Code plugin's commands and processes. The format enables natural language command triggers that map to specific actions Claude should take.

## Structure

```json
{
  "plugin-commands": [
    {"<trigger>": "<plugin-processs-name>"}
  ],
  "plugin-processes": [
    {"<plugin-processs-name>": {
      "<action-type>": "<action-value>",
      "instructions": "<process-instructions>"
    }}
  ]
}
```

## Fields

### plugin-commands (required)
An array of command trigger mappings. Each entry is an object with a single key-value pair:
- **Key**: The exact phrase that triggers this command (case-sensitive)
- **Value**: The name of the plugin-process to execute

Example:
```json
"plugin-commands": [
  {"hello": "greeting-action"},
  {"git status": "git-status-action"}
]
```

### plugin-processes (required)
An array of plugin-process definitions. Each entry is an object with a single key (the plugin-process name) containing the plugin-process configuration:

#### Process Configuration
- **instructions** (required): Natural language instructions for Claude to follow. When referencing a sequence, use phrases like "Execute the sequence" or "Execute the following steps"
- **execute-bash-command** (optional): A specific bash command to execute directly
- **sequence** (optional): An array of step-by-step instructions to execute as a todo list

## Action Types

### 1. Natural Language Instructions
Use the `instructions` field for actions Claude should perform:

```json
{"greeting-action": {
  "instructions": "Respond with '🌟 Hello! I'm excited to help you build something amazing today!'"
}}
```

### 2. Bash Command Execution
Use the `execute-bash-command` field for specific plugin-commands:

```json
{"git-status-action": {
  "execute-bash-command": "git status",
  "instructions": "Check git repository status and report back to user"
}}
```

## Complete Example

```json
{
  "plugin-commands": [
    {"hello": "greeting-action"},
    {"git status": "git-status-action"},
    {"create command": "create-command-action"}
  ],
  "processes": [
    {"greeting-action": {
      "instructions": "Respond with '🌟 Hello! I'm excited to help you build something amazing today!'"
    }},
    {"git-status-action": {
      "execute-bash-command": "git status",
      "instructions": "Check git repository status and report back to user"
    }},
    {"create-command-action": {
      "instructions": "Prompt for command details, generate JSON definition, and save to local-commands.json"
    }}
  ]
}
```

## Sequential Workflow Processes

Plugins can define complex workflows using an optional `sequence` array. When present, the `instructions` field should indicate that the sequence should be executed.

### Example: Git Checkin Workflow

```json
{
  "plugin-commands": [
    {"git checkin": "git-checkin-workflow"}
  ],
  "plugin-processes": [
    {"git-checkin-workflow": {
      "instructions": "Execute the git checkin sequence: status check, staging, review, and commit",
      "sequence": [
        "Run 'git status' to check repository state",
        "Run 'git add .' to stage all changes", 
        "Run 'git diff --staged' to review staged changes",
        "Prompt user for commit message and run 'git commit -m \"<message>\"'"
      ]
    }}
  ]
}
```

### Sequential Process Fields

- **instructions**: Describes what to do. When using sequences, include phrases like "Execute the sequence" or "Execute the following steps"
- **sequence** (optional): Array of natural language instructions to execute as todo items in order

### How Sequential Workflows Work

When Claude encounters a process with a `sequence` array:

1. **Creates Todo List**: Each sequence item becomes a todo item
2. **Sequential Execution**: Steps execute in order, marked as in_progress → completed
3. **Error Handling**: Workflow stops if any step fails
4. **Natural Language**: Each step uses plain English instructions

### More Examples

**Testing and Deployment:**
```json
{"test-and-deploy": {
  "instructions": "Execute the test, build, and deploy sequence",
  "sequence": [
    "Run 'npm test' to validate functionality",
    "Run 'npm run build' for production",
    "Run 'git add .' to stage build changes",
    "Run 'git commit -m \"Build for deployment\"'",
    "Run 'git push origin main'"
  ]
}}
```

**Code Quality Check:**
```json
{"quality-check": {
  "instructions": "Execute the comprehensive code quality validation sequence",
  "sequence": [
    "Run 'npm run lint' to check code style",
    "Run 'npm run typecheck' to validate types",
    "Run 'npm test' to run test suite",
    "Run 'npm audit' to check for vulnerabilities"
  ]
}}
```

## Best Practices

1. **Clear Triggers**: Use natural, memorable phrases for command triggers
2. **Descriptive Names**: Process names should indicate their purpose (e.g., `greeting-action`, not `action1`)
3. **Helpful Descriptions**: Write instructionss that explain what the plugin-process does for users
4. **Action Clarity**: Make action instructions specific and unambiguous
5. **Consistent Format**: Follow the exact structure - the aggregator expects this format
6. **Sequential Steps**: For multi-step workflows, explicitly number the steps and describe the todo management approach

## Integration

Individual PLUGIN.json files are aggregated into PLUGINS.json by the `aggregate-plugins.sh` script:

```
.claude-plugins/
├── hello-world/
│   └── PLUGIN.json
├── local-commands/
│   └── PLUGIN.json
├── aggregate-plugins.sh
└── PLUGINS.json (generated)
```

The aggregated PLUGINS.json maintains a flat structure by merging all plugin-commands and plugin-processes:
```json
{
  "plugin-commands": [
    {"hello": "greeting-action"},
    {"git status": "git-status-action"},
    {"create command": "create-command-action"},
    {"show next steps": "suggest-steps-action"}
  ],
  "processes": [
    {"greeting-action": { /* plugin-process definition */ }},
    {"git-status-action": { /* pplugin-rocess definition */ }},
    {"create-command-action": { /* plugin-process definition */ }},
    {"suggest-steps-action": { /* plugin-process definition */ }}
  ]
}
```

**Important**: The aggregation process merges all plugin-commands and plugin-processes into single flat arrays, avoiding nested plugin namespaces. This ensures efficient command lookup and processing.

## Validation

- JSON must be valid (use a JSON validator)
- Each command trigger must map to a defined process
- Process names must be unique within the plugin
- Either `action` or `execute-bash-command` must be specified (not both)
