#!/bin/bash

# Claude Code Plugin System Installation Script
# This script safely installs plugin instructions into your project's CLAUDE.md

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Heuristic for installation
INSTALL_HEURISTIC='Load plugin patterns from .claude-plugins/PLUGINS.json into context'

echo -e "${GREEN}Claude Code Plugin System Installer${NC}"
echo "======================================"

# Step 1: Verify CLAUDE.md exists in the expected location
PROJECT_CLAUDE="../CLAUDE.md"
if [ ! -f "$PROJECT_CLAUDE" ]; then
    echo -e "${RED}ERROR: CLAUDE.md not found at $PROJECT_CLAUDE${NC}"
    echo "This script must be run from within the .claude-plugins directory"
    echo "and your project must have a CLAUDE.md file one level up."
    exit 1
fi

echo -e "${GREEN}✓${NC} Found CLAUDE.md at $PROJECT_CLAUDE"

# Step 2: Check if plugin instructions are already installed
if grep -q "$INSTALL_HEURISTIC" "$PROJECT_CLAUDE"; then
    echo -e "${YELLOW}Plugin instructions already installed in CLAUDE.md${NC}"
    echo "No action needed. Your project is already configured for plugins."
    exit 0
fi

echo -e "${GREEN}✓${NC} Plugin instructions not yet installed"

# Step 3: Verify Add-Me-To-Claude.md exists and passes safety check
TEMPLATE_FILE="Add-Me-To-Claude.md"
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}ERROR: $TEMPLATE_FILE not found${NC}"
    echo "The installation template is missing."
    exit 1
fi

echo -e "${GREEN}✓${NC} Found installation template"

# Step 4: Safety check - verify template passes plugin detection heuristic
if ! grep -q "$INSTALL_HEURISTIC" "$TEMPLATE_FILE"; then
    echo -e "${RED}ERROR: Installation template failed safety check${NC}"
    echo "The template does not contain required plugin reference."
    echo "This prevents infinite installation loops."
    exit 1
fi

echo -e "${GREEN}✓${NC} Template passed safety checks"

# Step 5: Show user what will happen and get confirmation
echo
echo -e "${YELLOW}You may install manually if you prefer by copying the contents of Add-Me-To-Claude to the start of your CLAUDE.md: ${NC}"
echo "1. Backup your current CLAUDE.md to CLAUDE.md.bak"
echo "2. Create new CLAUDE.md with:"
echo "   - Plugin instructions from $TEMPLATE_FILE"
echo "   - Your existing CLAUDE.md content"
echo
echo -e "${YELLOW}This will modify your CLAUDE.md file.${NC}"
read -p "Do you want to proceed? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

# Step 6: Create backup
echo -e "${GREEN}Creating backup...${NC}"
cp "$PROJECT_CLAUDE" "${PROJECT_CLAUDE}.bak"
echo -e "${GREEN}✓${NC} Backup created at ${PROJECT_CLAUDE}.bak"

# Step 7: Install plugin instructions
echo -e "${GREEN}Installing plugin instructions...${NC}"

# Create temporary file with new content
TEMP_FILE=$(mktemp)
{
    cat "$TEMPLATE_FILE"
    echo
    cat "$PROJECT_CLAUDE"
} > "$TEMP_FILE"

# Replace original file
mv "$TEMP_FILE" "$PROJECT_CLAUDE"

echo -e "${GREEN}✓${NC} Plugin instructions installed successfully"

# Step 8: Verify installation
if grep -q ".claude-plugins/CLAUDE.md" "$PROJECT_CLAUDE"; then
    echo -e "${GREEN}✓${NC} Installation verified"
else
    echo -e "${RED}ERROR: Installation verification failed${NC}"
    echo "Restoring backup..."
    mv "${PROJECT_CLAUDE}.bak" "$PROJECT_CLAUDE"
    exit 1
fi

echo
echo -e "${GREEN}Installation Complete!${NC}"
echo "===================="
echo
echo "Next steps:"
echo "1. Run: ${YELLOW}./aggregate-plugins.sh${NC} (to generate PLUGINS.json)"
echo "2. In Claude Code, say: ${YELLOW}\"load plugins\"${NC} (to activate)"
echo "3. Try a plugin command like: ${YELLOW}\"hello\"${NC}"
echo
echo "Your original CLAUDE.md has been backed up to CLAUDE.md.bak"
echo "For plugin documentation, see: .claude-plugins/CLAUDE.md"
