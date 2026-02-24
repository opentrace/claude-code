# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

This is the **OpenTrace Claude Code Plugin** — a Claude Code plugin that connects Claude to OpenTrace's knowledge graph for system architecture exploration and incident investigation. It is distributed via the Claude Code plugin marketplace.

## Architecture

The repository has two layers:

1. **Plugin layer** (this repo) — Contains the plugin manifest, MCP server configuration, and plugin-specific hooks. This is what gets installed via `claude plugin install`.
2. **Shared `.claude` submodule** — A git submodule (`opentrace/.claude`) containing shared agents, commands, hooks, and settings used across OpenTrace projects. Changes to shared settings must be submitted to the [.claude repository](https://github.com/opentrace/.claude) separately.

### Key Files

- `.claude-plugin/plugin.json` — Plugin manifest: name, version, MCP server references, and hook definitions
- `.claude-plugin/marketplace.json` — Marketplace metadata for plugin discovery
- `mcp-servers/opentrace.json` — MCP server configuration pointing to `https://api.opentrace.ai/mcp/v1`
- `hooks/` — Plugin hooks (see below)
- `.claude/` — Git submodule with shared agents, commands, and settings (do not edit directly in this repo)

### Plugin Hooks

Hooks are defined in `.claude-plugin/plugin.json` and reference scripts in `hooks/`:

| Hook | Trigger | Purpose |
|------|---------|---------|
| `SessionStart` | Every session | Injects system context telling Claude that OpenTrace is available and when to use it |
| `PreToolUse` (traversal) | Traversal/neighbor tool calls | Guardrail: warns when `maxDepth >= 3` with no filters to prevent oversized results |
| `PostToolUse` (navigation) | After any OpenTrace tool call | Prompt-based hook: suggests logical next exploration steps based on which tool was just used |

Hook scripts use `${CLAUDE_PLUGIN_ROOT}` to resolve paths relative to the plugin installation directory.

## Development Workflow

### Prerequisites
- Claude Code CLI (`claude`) must be installed
- `jq` is required by the PreToolUse guardrail hook

### Make Targets

```
make dev                  # Full dev reinstall: uninstall, refresh marketplace, reinstall
make install              # Install the plugin from the marketplace
make uninstall            # Uninstall the plugin
make validate             # Validate the plugin manifest
make marketplace-add      # Register CWD as a local marketplace
make marketplace-remove   # Remove the marketplace
make marketplace-reinstall # Remove and re-add the marketplace
make list                 # List installed plugins
```

The standard development cycle is: edit files → `make dev` → restart Claude Code → test.

### First-Time Setup

```bash
git clone --recurse-submodules git@github.com:opentrace/claude-code.git
cd claude-code
make marketplace-add
make install
```

If cloned without submodules: `git submodule update --init --recursive`

### Testing Changes

There is no automated test suite. Testing is manual:
1. Run `make dev` to reinstall the plugin with your changes
2. Start a new Claude Code session
3. Verify hook behavior and MCP tool availability

## Conventions

- Hook scripts must output valid JSON to stdout. Return `{}` for silent pass-through.
- The `PreToolUse` guardrail pattern: read tool input from stdin via `jq`, check parameters, output structured JSON with `additionalContext` warnings or empty `{}`.
- The `PostToolUse` navigation pattern: prompt-based hook (`.txt` file) that provides contextual suggestions without blocking.
- Plugin version is in `.claude-plugin/plugin.json` — bump it when releasing changes.
