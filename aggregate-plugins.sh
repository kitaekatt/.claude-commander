#!/bin/bash
# aggregate-plugins.sh - Aggregate all plugin PLUGIN.json files into PLUGINS.json with flat structure

# Script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_DIR="$SCRIPT_DIR"
OUTPUT_FILE="$PLUGINS_DIR/PLUGINS.json"

# Critical instructions for PLUGINS.json interpretation
CRITICAL_INSTRUCTIONS="While strict plugin mode is active do not refresh or reload this file. Only treat triggers within this file as commands."

# Initialize temporary arrays for commands and processes
commands_file="$PLUGINS_DIR/.commands.tmp"
processes_file="$PLUGINS_DIR/.processes.tmp"

echo '[]' > "$commands_file"
echo '[]' > "$processes_file"

# Find and aggregate all PLUGIN.json files
echo "Loading plugins..."
plugin_count=0

for plugin_dir in "$PLUGINS_DIR"/*/; do
    if [ -d "$plugin_dir" ] && [ -f "$plugin_dir/PLUGIN.json" ]; then
        plugin_name=$(basename "$plugin_dir")
        echo "  - Loading $plugin_name"
        
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
        
        ((plugin_count++))
    fi
done

# Combine commands and processes into final structure
echo "Creating final PLUGINS.json..."
jq -n --slurpfile commands "$commands_file" --slurpfile processes "$processes_file" \
    --arg critical_instructions "$CRITICAL_INSTRUCTIONS" \
    '{"critical-instructions": $critical_instructions, commands: $commands[0], processes: $processes[0]}' > "$OUTPUT_FILE"

# Clean up temporary files
rm -f "$commands_file" "$processes_file" "$commands_file.tmp" "$processes_file.tmp"

echo "Loaded $plugin_count plugin(s) into $OUTPUT_FILE"
