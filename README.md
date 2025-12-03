# OpenTrace Claude Code Plugin

A Claude Code plugin that provides system architecture exploration and incident investigation capabilities using OpenTrace's knowledge graph.

## Features

- **40+ MCP Tools**: Full access to OpenTrace knowledge graph operations
- **Architecture Discovery**: Explore and map system architecture
- **Incident Response**: Rapid diagnosis and resolution guidance
- **Impact Analysis**: Assess the blast radius of changes
- **Dependency Tracing**: Understand service relationships

## Installation

### Prerequisites

1. An OpenTrace account with API access
2. Claude Code CLI installed

### Setup

1. **Get your API token**:
   - Go to [https://app.opentrace.ai/settings/api-tokens](https://app.opentrace.ai/settings/api-tokens)
   - Click "Create API Token"
   - Copy the token

2. **Set the environment variable**:
   ```bash
   export OPENTRACE_TOKEN="your-token-here"
   ```

   Or add to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):
   ```bash
   echo 'export OPENTRACE_TOKEN="your-token-here"' >> ~/.bashrc
   ```

3. **Add the plugin marketplace** (one-time setup):
   ```bash
   /plugin marketplace add opentrace/insight-claude-plugin
   ```

4. **Install the plugin**:
   ```bash
   /plugin install opentrace
   ```

## Available Tools

### Knowledge Graph Read Operations

| Tool | Description |
|------|-------------|
| `query_nodes` | Query nodes by type and filters |
| `search_nodes` | Full-text search across nodes |
| `find_similar_nodes` | Find nodes similar to a given node |
| `traverse_outgoing` | Follow outgoing relationships |
| `traverse_incoming` | Follow incoming relationships |
| `traverse_dependencies` | Traverse dependency chains |
| `get_neighbors` | Get all connected nodes |
| `find_path` | Find paths between nodes |
| `get_node_statistics` | Get statistics about a node |

### Knowledge Graph Write Operations

| Tool | Description |
|------|-------------|
| `save_repo_node` | Create/update repository nodes |
| `save_service_node` | Create/update service nodes |
| `save_class_node` | Create/update class nodes |
| `save_function_node` | Create/update function nodes |
| `save_calls_relationship` | Create call relationships |
| `save_defined_in_relationship` | Create definition relationships |
| `delete_node` | Remove nodes |
| `delete_relationship` | Remove relationships |

### Investigation Tools

| Tool | Description |
|------|-------------|
| `list_investigations` | List all investigations |
| `get_investigation` | Get investigation details |

### Integration Tools

| Tool | Description |
|------|-------------|
| `load_source` | Load source code from GitHub/GitLab |

## Available Prompts

The plugin exposes structured analysis workflows:

| Prompt | Description |
|--------|-------------|
| `discover_architecture` | System discovery with configurable depth |
| `impact_analysis` | Change impact assessment |
| `dependency_analysis` | Dependency structure analysis |
| `map_service_communication` | Service communication patterns |
| `investigate_incident` | General incident investigation |
| `diagnose_service_outage` | Service failure diagnosis |
| `trace_error_propagation` | Error flow tracing |
| `analyze_deployment_impact` | Deployment impact assessment |

## Usage Examples

### Discover Architecture

```
Use the discover_architecture prompt to map my system starting from the payment-service
```

### Investigate an Incident

```
Use the diagnose_service_outage prompt - the checkout service is returning 500 errors
```

### Trace Dependencies

```
Use traverse_outgoing to show me what the user-service depends on
```

### Find Impact of Changes

```
Use impact_analysis to assess what would be affected if I change the billing-api
```

## Commands (Coming Soon)

- `/discover` - Interactive architecture discovery
- `/impact` - Change impact analysis
- `/diagnose` - Service outage diagnosis
- `/explore` - Knowledge graph exploration

## Agents (Coming Soon)

- `architecture-explorer` - Specialized agent for architecture analysis
- `incident-responder` - Rapid incident diagnosis agent
- `knowledge-curator` - Knowledge graph maintenance agent

## Troubleshooting

### Authentication Errors

If you see authentication errors:

1. Check that `OPENTRACE_TOKEN` is set:
   ```bash
   echo $OPENTRACE_TOKEN
   ```

2. Verify the token is valid (not expired)

3. Ensure the token has correct permissions for your organization

### Connection Issues

If the MCP server is unreachable:

1. Check your internet connection
2. Verify the API is available: `curl https://api.opentrace.ai/health`
3. Check for any service status updates at [status.opentrace.ai](https://status.opentrace.ai)

### Permission Errors

If you see permission denied errors:

1. Verify your organization membership
2. Check your role has the required permissions (GraphRead, GraphWrite, etc.)
3. Contact your organization admin if needed

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Support

- Documentation: [https://docs.opentrace.ai](https://docs.opentrace.ai)
- Issues: [GitHub Issues](https://github.com/opentrace/insight-claude-plugin/issues)
- Community: [Discord](https://discord.gg/opentrace)
