# Contributing to OpenTrace Claude Code Plugin

## Local Development Setup

1. **Clone the repository** (with submodules):
   ```bash
   git clone --recurse-submodules git@github.com:opentrace/claude-code.git
   ```

   If you already cloned without submodules:
   ```bash
   git submodule update --init --recursive
   ```

2. **Add the local repository as a marketplace**:
   ```bash
   claude plugin marketplace add /path/to/claude-code
   ```

3. **Install the plugin from the marketplace**:
   ```bash
   claude plugin install opentrace
   ```

4. **Restart Claude Code** to pick up the plugin.

To reinstall after changes, remove and re-add the marketplace:
```bash
claude plugin marketplace remove opentrace-marketplace
claude plugin marketplace add /path/to/claude-code
claude plugin install opentrace
```

## Project Structure

```
.claude/             # Shared Claude Code settings (git submodule)
hooks/
  session-start      # Hook that runs when a Claude Code session starts
mcp-servers/
  opentrace.json     # MCP server configuration for OpenTrace
README.md
CONTRIBUTING.md
```

## Making Changes

- **Hooks** live in `hooks/`. Changes are picked up on the next Claude Code session.
- **MCP server config** lives in `mcp-servers/opentrace.json`. Restart Claude Code after changes.
- **Shared settings** are in the `.claude` submodule. If you need to modify shared settings, submit changes to the [.claude repository](https://github.com/opentrace/.claude) separately.

## Submitting Changes

1. Create a branch from `main`.
2. Make your changes and test locally by running Claude Code with the plugin installed.
3. Open a pull request against `main`.