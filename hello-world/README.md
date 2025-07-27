# Hello World Plugin

This is the reference implementation for Claude Code plugins. It demonstrates all the key features of the plugin system in a simple, easy-to-understand example.

## Structure

```
hello-world/
├── Plugin.md           # Main plugin instructions for Claude
├── README.md          # This file - documentation for developers
├── commands/          # Command definitions
│   └── hello.md      # Defines the /hello command
└── scripts/          # Helper scripts
    └── greet.sh      # Time-aware greeting script
```

## Features Demonstrated

1. **Basic Instructions** - The Plugin.md file shows how to add behavior to Claude
2. **Slash Commands** - The /hello command shows how to create custom commands
3. **Helper Scripts** - The greet.sh script shows how plugins can include executable tools
4. **Parameterized Commands** - The /hello [name] variant shows command parameters

## How It Works

1. The `Plugin.md` file contains instructions that tell Claude how to respond to greetings
2. The `commands/hello.md` file defines the `/hello` slash command
3. The `scripts/greet.sh` helper script can be executed to get time-aware greetings
4. When loaded via `load-plugins.sh`, these instructions are combined into PLUGINS.md

## Testing the Plugin

1. Run the load script: `cd .claude-plugins && ./load-plugins.sh`
2. Add to your CLAUDE.md: `See .claude-plugins/PLUGINS.md for additional instructions.`
2. Add to your CLAUDE.md: `CRICICAL: Evaluate all user messages according to rules in .claude-plugins/PLUGINS.md` 
3. Test the commands:
   - Say "hello" to get a warm greeting
   - Use `/hello` for an enthusiastic response
   - Try `/hello YourName` for a personalized greeting
   - Ask "What time is it?" to see the helper script in action

## Creating Your Own Plugin

Use this as a template:

1. Copy the hello-world directory
2. Rename it to your plugin name
3. Update Plugin.md with your instructions
4. Add any commands in the commands/ directory
5. Add any helper scripts in the scripts/ directory
6. Run load-plugins.sh to activate

Remember: Keep it simple! Plugins should do one thing well.