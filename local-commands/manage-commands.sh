#!/bin/bash
# Helper script for managing commands in the local-commands plugin

PLUGIN_DIR="${CLAUDE_PLUGINS_DIR:-.claude-plugins}"
COMMANDS_FILE="$PLUGIN_DIR/local-commands/commands.json"

case "$1" in
    "add")
        # Add a new command
        name="$2"
        description="$3"
        usage="$4"
        process="$5"
        
        # Create the command object
        jq --arg name "$name" \
           --arg desc "$description" \
           --arg usage "$usage" \
           --argjson process "$process" \
           '.commands[$name] = {"description": $desc, "usage": $usage, "process": $process}' \
           "$COMMANDS_FILE" > "$COMMANDS_FILE.tmp" && \
        mv "$COMMANDS_FILE.tmp" "$COMMANDS_FILE"
        
        echo "Added command: $name"
        ;;
        
    "list")
        # List all commands
        jq -r '.commands | to_entries[] | "\(.key): \(.value.description)"' "$COMMANDS_FILE"
        ;;
        
    "get")
        # Get a specific command
        name="$2"
        jq --arg name "$name" '.commands[$name]' "$COMMANDS_FILE"
        ;;
        
    "remove")
        # Remove a command
        name="$2"
        jq --arg name "$name" 'del(.commands[$name])' "$COMMANDS_FILE" > "$COMMANDS_FILE.tmp" && \
        mv "$COMMANDS_FILE.tmp" "$COMMANDS_FILE"
        echo "Removed command: $name"
        ;;
        
    *)
        echo "Usage: $0 {add|list|get|remove} [args...]"
        exit 1
        ;;
esac