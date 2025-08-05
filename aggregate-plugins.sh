#!/bin/bash
# aggregate-plugins.sh - Generate slash commands from plugin definitions

# Script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_DIR="$SCRIPT_DIR"
COMMANDS_DIR="$PLUGINS_DIR/.claude/commands"

# Create commands directory if it doesn't exist
mkdir -p "$COMMANDS_DIR"

echo "Generating slash commands from plugins..."
plugin_count=0

# Clean up old generated commands (but keep manually created ones)
rm -f "$COMMANDS_DIR/plugin-load.md" "$COMMANDS_DIR/plugin-list.md"

# Process each plugin directory
for plugin_dir in "$PLUGINS_DIR"/*/; do
    if [ -d "$plugin_dir" ] && [ -f "$plugin_dir/PLUGIN.json" ]; then
        plugin_name=$(basename "$plugin_dir")
        echo "  - Processing $plugin_name"
        
        # Extract commands and create slash command files
        jq -c '.commands[]' "$plugin_dir/PLUGIN.json" 2>/dev/null | while read -r cmd; do
            # Parse command structure: {"trigger": "process"}
            trigger=$(echo "$cmd" | jq -r 'keys[0]')
            process=$(echo "$cmd" | jq -r '.[keys[0]]')
            
            # Skip if we can't parse
            if [ "$trigger" = "null" ] || [ "$process" = "null" ]; then
                continue
            fi
            
            echo "    - Creating command: $trigger"
            
            # Get process definition
            process_def=$(jq -r ".processes[] | select(keys[0] == \"$process\") | .\"$process\"" "$plugin_dir/PLUGIN.json")
            
            if [ "$process_def" != "null" ]; then
                # Create command file based on trigger
                command_file="$COMMANDS_DIR/${trigger// /-}.md"
                
                # Generate command content
                {
                    echo "---"
                    echo "description: \"$trigger command from $plugin_name plugin\""
                    echo "argument-hint: \"\""
                    echo "---"
                    echo ""
                    
                    # Extract instructions
                    instructions=$(echo "$process_def" | jq -r '.instructions // empty')
                    if [ -n "$instructions" ]; then
                        echo "$instructions"
                        echo ""
                    fi
                    
                    # Extract sequence if exists
                    sequence=$(echo "$process_def" | jq -r '.sequence // empty')
                    if [ -n "$sequence" ] && [ "$sequence" != "null" ]; then
                        echo "Execute the following sequence:"
                        echo "$process_def" | jq -r '.sequence[]' | sed 's/^/- /'
                        echo ""
                    fi
                    
                    # Extract bash command if exists
                    bash_cmd=$(echo "$process_def" | jq -r '."execute-bash-command" // empty')
                    if [ -n "$bash_cmd" ]; then
                        echo "Execute: \`$bash_cmd\`"
                        echo ""
                    fi
                } > "$command_file"
            fi
        done
        
        ((plugin_count++))
    fi
done

# Create legacy compatibility commands for /plugin load and /plugin list
echo "Creating plugin management commands..."

# Keep existing plugin.md file if it exists, but ensure it has load/list functionality
if [ ! -f "$COMMANDS_DIR/plugin.md" ]; then
    cat > "$COMMANDS_DIR/plugin.md" << 'EOF'
---
description: "Plugin system management commands"
argument-hint: "load | list | create | unload"
---

# Plugin Management Commands

Manage the plugin system based on the provided action: $ARGUMENTS

## Available Actions:

**load**: Load plugin patterns from PLUGINS.json for backwards compatibility
**list**: Show available slash commands generated from plugins  
**create**: Interactive plugin creation wizard
**unload**: Deactivate legacy plugin system

Use `/plugin load` for backwards compatibility with natural language triggers.
All new functionality uses direct slash commands like `/git`, `/hello`, `/suggest`.
EOF
fi

echo "Generated slash commands for $plugin_count plugin(s)"
echo "Commands available in $COMMANDS_DIR"

# Also maintain PLUGINS.json for backwards compatibility
echo "Maintaining PLUGINS.json for backwards compatibility..."
OUTPUT_FILE="$PLUGINS_DIR/PLUGINS.json"

# Initialize temporary arrays for commands and processes
commands_file="$PLUGINS_DIR/.commands.tmp"
processes_file="$PLUGINS_DIR/.processes.tmp"

echo '[]' > "$commands_file"
echo '[]' > "$processes_file"

# Find and aggregate all PLUGIN.json files for legacy support
for plugin_dir in "$PLUGINS_DIR"/*/; do
    if [ -d "$plugin_dir" ] && [ -f "$plugin_dir/PLUGIN.json" ]; then
        # Extract and merge commands
        jq -c '.commands[]' "$plugin_dir/PLUGIN.json" 2>/dev/null | while read -r cmd; do
            echo "$cmd" >> "$commands_file.new"
        done
        
        # Extract and merge processes
        jq -c '.processes[]' "$plugin_dir/PLUGIN.json" 2>/dev/null | while read -r proc; do
            echo "$proc" >> "$processes_file.new"
        done
        
        # Merge into existing arrays
        if [ -f "$commands_file.new" ]; then
            jq -s 'add' "$commands_file" <(echo "["; cat "$commands_file.new" | paste -sd "," -; echo "]") > "$commands_file.tmp"
            mv "$commands_file.tmp" "$commands_file"
            rm "$commands_file.new"
        fi
        
        if [ -f "$processes_file.new" ]; then
            jq -s 'add' "$processes_file" <(echo "["; cat "$processes_file.new" | paste -sd "," -; echo "]") > "$processes_file.tmp"
            mv "$processes_file.tmp" "$processes_file"
            rm "$processes_file.new"
        fi
    fi
done

# Combine commands and processes into final structure
jq -n --slurpfile commands "$commands_file" --slurpfile processes "$processes_file" \
    --arg critical_instructions "Legacy natural language plugin system. Use slash commands instead." \
    '{"critical-instructions": $critical_instructions, commands: $commands[0], processes: $processes[0]}' > "$OUTPUT_FILE"

# Clean up temporary files
rm -f "$commands_file" "$processes_file" "$commands_file.tmp" "$processes_file.tmp"
