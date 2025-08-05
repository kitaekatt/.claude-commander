#!/bin/bash
# generate-commands.sh - Generate slash commands from plugin definitions

# Script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
COMMANDS_SOURCE_DIR="$SCRIPT_DIR/commands"
COMMANDS_TARGET_DIR="$PROJECT_ROOT/.claude/commands"

# Create commands directory if it doesn't exist
mkdir -p "$COMMANDS_TARGET_DIR"

echo "Generating slash commands from plugins..."
command_count=0
expected_commands=()

# Clean up old plugin-generated commands (but keep manually created ones)
find "$COMMANDS_TARGET_DIR" -name "*.md" -exec grep -l "from.*plugin" {} \; | xargs rm -f 2>/dev/null

# Copy all .md files from commands source to target
if [ -d "$COMMANDS_SOURCE_DIR" ]; then
    for command_file in "$COMMANDS_SOURCE_DIR"/*.md; do
        if [ -f "$command_file" ]; then
            command_name=$(basename "$command_file" .md)
            target_file="$COMMANDS_TARGET_DIR/$(basename "$command_file")"
            
            echo "  - Installing command: /$command_name"
            cp "$command_file" "$target_file"
            
            expected_commands+=("$(basename "$command_file")")
            ((command_count++))
        fi
    done
else
    echo "Commands source directory not found: $COMMANDS_SOURCE_DIR"
fi

echo "Generated slash commands for $command_count command(s)"
echo "Commands available in $COMMANDS_TARGET_DIR"
echo ""

# Check for orphaned commands
if [ -d "$COMMANDS_TARGET_DIR" ]; then
    orphaned_commands=()
    for existing_file in "$COMMANDS_TARGET_DIR"/*.md; do
        if [ -f "$existing_file" ]; then
            filename=$(basename "$existing_file")
            if [[ ! " ${expected_commands[@]} " =~ " ${filename} " ]]; then
                orphaned_commands+=("$filename")
            fi
        fi
    done
    
    if [ ${#orphaned_commands[@]} -gt 0 ]; then
        echo "⚠️  WARNING: Found orphaned command files (not from commands directory):"
        for orphan in "${orphaned_commands[@]}"; do
            echo "  - $orphan"
        done
        echo ""
        echo "💡 These may be manually created commands or old plugin files"
        echo ""
    fi
fi

echo "Available commands:"
if [ -d "$COMMANDS_TARGET_DIR" ]; then
    find "$COMMANDS_TARGET_DIR" -name "*.md" -printf "  /%f\n" | sed 's/.md$//' | sort
fi