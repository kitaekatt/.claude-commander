# Create Command

Creates a new command dynamically by prompting for details and saving to commands.json

## Usage
/create-command <name>

## Process
1. Prompt user for command description
2. Ask for implementation details
3. Generate structured JSON
4. Save to local-commands/commands.json
5. Run aggregator to update PLUGINS.json