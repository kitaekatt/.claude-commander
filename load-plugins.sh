#!/bin/bash
# load-plugins.sh - Concatenate all plugin Plugin.md files into PLUGINS.md

# Script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_DIR="$SCRIPT_DIR"
OUTPUT_FILE="$PLUGINS_DIR/PLUGINS.md"

# Header for the combined file
cat > "$OUTPUT_FILE" << 'EOF'
# Claude Code Plugins

CRITICAL: Evaluate each user message received against these rules before acting.

---

EOF

# Find and concatenate all Plugin.md files
echo "Loading plugins..."
plugin_count=0

for plugin_dir in "$PLUGINS_DIR"/*/; do
    if [ -d "$plugin_dir" ] && [ -f "$plugin_dir/Plugin.md" ]; then
        plugin_name=$(basename "$plugin_dir")
        echo "  - Loading $plugin_name"
        
        # Add plugin header
        echo -e "\n## Plugin: $plugin_name\n" >> "$OUTPUT_FILE"
        
        # Add plugin content
        cat "$plugin_dir/Plugin.md" >> "$OUTPUT_FILE"
        
        # Add separator
        echo -e "\n---\n" >> "$OUTPUT_FILE"
        
        ((plugin_count++))
    fi
done

echo "Loaded $plugin_count plugin(s) into $OUTPUT_FILE"

# Show instructions if this is the first run
if [ $plugin_count -gt 0 ]; then
    echo ""
    echo "To enable these plugins in your project:"
    echo "1. Add this line to your project's CLAUDE.md:"
    echo "   # Include plugin instructions"
    echo "   See .claude-plugins/PLUGINS.md for additional instructions."
    echo ""
    echo "To disable plugins, simply remove that line from CLAUDE.md."
fi