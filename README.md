# OpenTrace Claude Code Plugin

Connect Claude Code to your organization's knowledge graph for architecture exploration and incident investigation.

## Installation

1. **Add the plugin marketplace**:
   ```
   /plugin marketplace add opentrace/claude-code
   ```

2. **Install the plugin**:
   ```
   /plugin install opentrace
   ```

3. **Authenticate**: On first use, you'll be prompted to sign in via your browser.

## Usage Examples

### 1. Discover System Architecture

```
Use discover_architecture to explore my system starting from payment-service
```

Maps dependencies, identifies architectural patterns, and provides insights about a component's role.

### 2. Analyze Dependencies

```
Use dependency_analysis to understand how payment-service connects to other components
```

Maps upstream dependencies (what it relies on) and downstream dependents (what relies on it).

### 3. Search the Knowledge Graph

```
Search for all services related to authentication
```

or use the tools directly:

```
Use search_nodes to find services matching "payment"
Use query_nodes to list all Service nodes
```

### 4. Impact Analysis

```
Use impact_analysis to check what would be affected if we modify billing-api
```

Identifies all dependent components and highlights critical paths.

## Available Tools

| Category | Tools |
|----------|-------|
| **Discovery** | `search_nodes`, `query_nodes`, `get_node`, `find_similar_nodes` |
| **Traversal** | `traverse_dependencies`, `traverse_incoming`, `traverse_outgoing`, `get_neighbors` |
| **Analysis** | `find_path`, `get_node_statistics` |
| **Investigations** | `list_investigations`, `get_investigation` |
| **Source** | `load_source` (GitHub/GitLab integration) |

**Analysis Prompts**: `discover_architecture`, `impact_analysis`, `dependency_analysis`

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Authentication failed | Ensure you have an active OpenTrace account and are a member of an organization |
| No results found | Your knowledge graph may not have data yet, or check component name spelling |
| Connection errors | Check internet connection; verify https://api.opentrace.ai is accessible |

## Links

- [OpenTrace Documentation](https://docs.opentrace.ai)
- [GitHub Issues](https://github.com/opentrace/insight-claude-plugin/issues)
