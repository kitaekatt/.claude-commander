# PLUGIN.json Format Documentation

## Overview

PLUGIN.json defines a Claude Code plugin's commands and processes. The format enables natural language command triggers that map to specific actions Claude should take.

## Structure

```json
{
  "commands": [
    {"<trigger>": "<process-name>"}
  ],
  "processes": [
    {"<process-name>": {
      "<action-type>": "<action-value>",
      "description": "<process-description>"
    }}
  ]
}
```

## Fields

### commands (required)
An array of command trigger mappings. Each entry is an object with a single key-value pair:
- **Key**: The exact phrase that triggers this command (case-sensitive)
- **Value**: The name of the process to execute

Example:
```json
"commands": [
  {"hello": "greeting-action"},
  {"git status": "git-status-action"}
]
```

### processes (required)
An array of process definitions. Each entry is an object with a single key (the process name) containing the process configuration:

#### Process Configuration
- **action** or **execute-bash-command**: The action to perform
  - `action`: A natural language instruction for Claude to follow
  - `execute-bash-command`: A specific bash command to execute
- **description**: Human-readable description of what this process does

## Action Types

### 1. Natural Language Actions
Use the `action` field for instructions Claude should interpret:

```json
{"greeting-action": {
  "action": "Respond with '🌟 Hello! I'm excited to help you build something amazing today!'",
  "description": "Greet the user with enthusiasm"
}}
```

### 2. Bash Command Execution
Use the `execute-bash-command` field for specific commands:

```json
{"git-status-action": {
  "execute-bash-command": "git status",
  "description": "Check git repository status"
}}
```

## Complete Example

```json
{
  "commands": [
    {"hello": "greeting-action"},
    {"git status": "git-status-action"},
    {"create command": "create-command-action"}
  ],
  "processes": [
    {"greeting-action": {
      "action": "Respond with '🌟 Hello! I'm excited to help you build something amazing today!'",
      "description": "Greet the user with enthusiasm"
    }},
    {"git-status-action": {
      "execute-bash-command": "git status",
      "description": "Check git repository status and report back to user"
    }},
    {"create-command-action": {
      "action": "Prompt for command details, generate JSON definition, and save to commands.json",
      "description": "Create a new command dynamically"
    }}
  ]
}
```

## Best Practices

1. **Clear Triggers**: Use natural, memorable phrases for command triggers
2. **Descriptive Names**: Process names should indicate their purpose (e.g., `greeting-action`, not `action1`)
3. **Helpful Descriptions**: Write descriptions that explain what the process does for users
4. **Action Clarity**: Make action instructions specific and unambiguous
5. **Consistent Format**: Follow the exact structure - the aggregator expects this format

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

The aggregated PLUGINS.json maintains a flat structure by merging all commands and processes:
```json
{
  "commands": [
    {"hello": "greeting-action"},
    {"git status": "git-status-action"},
    {"create command": "create-command-action"},
    {"show next steps": "suggest-steps-action"}
  ],
  "processes": [
    {"greeting-action": { /* process definition */ }},
    {"git-status-action": { /* process definition */ }},
    {"create-command-action": { /* process definition */ }},
    {"suggest-steps-action": { /* process definition */ }}
  ]
}
```

**Important**: The aggregation process merges all plugin commands and processes into single flat arrays, avoiding nested plugin namespaces. This ensures efficient command lookup and processing.

## Validation

- JSON must be valid (use a JSON validator)
- Each command trigger must map to a defined process
- Process names must be unique within the plugin
- Either `action` or `execute-bash-command` must be specified (not both)