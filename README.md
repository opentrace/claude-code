# OpenTrace Claude Code Plugin

A Claude Code plugin that connects to OpenTrace's MCP server, providing access to your organization's knowledge graph for architecture exploration and incident investigation.

## Installation

### Prerequisites

- An OpenTrace account
- Claude Code CLI installed

### Setup

1. **Add the plugin marketplace**:
   ```
   /plugin marketplace add opentrace/claude-code
   ```

2. **Install the plugin**:
   ```
   /plugin install opentrace
   ```

3. **Authenticate**: On first use, you'll be prompted to sign in via your browser.

## Usage

Once installed, you can ask Claude to use OpenTrace tools and prompts:

```
Use discover_architecture to map my system starting from payment-service
```

```
Use diagnose_service_outage - the checkout service is returning 500 errors
```

```
Search for all services in the knowledge graph
```

## Links

- [OpenTrace Documentation](https://docs.opentrace.ai)
- [GitHub Issues](https://github.com/opentrace/insight-claude-plugin/issues)
