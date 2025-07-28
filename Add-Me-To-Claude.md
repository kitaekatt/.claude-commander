<claude-plugins>
# CLAUDE.md - Plugin Integration Instructions

## 🔌 PLUGIN SYSTEM - MANUAL ACTIVATION
**Plugin Mode**: Plugins are INACTIVE by default. User controls plugin behavior:

**"load plugins"** - Activates strict plugin mode:
- Acknowledge: "✅ Plugins loaded. Checking PLUGINS.json before all responses."
- Load plugin patterns from .claude-plugins/PLUGINS.json into context
- Evaluate all future messages against plugin patterns

**During Active Plugin Mode**:
1. Evaluate user message against command triggers from PLUGINS.json
2. If message matches a trigger, execute the associated process
3. Only use standard response if no trigger matches
4. Note: After initial load, you should have plugin definitions in context - no need to re-read PLUGINS.json for each message

**Re-initialization**: User may say "load plugins" again to reinforce adherence

For complete plugin documentation and usage instructions, see `./.claude-plugins/CLAUDE.md`.
</claude-plugins>
