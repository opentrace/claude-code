#!/bin/bash

# OpenTrace UserPromptSubmit Hook
# Detects architecture/dependency-related queries and suggests OpenTrace tools

# Read JSON input from stdin
input_json=$(cat)

# Extract the user's prompt
prompt=$(echo "$input_json" | jq -r '.prompt // ""' 2>/dev/null)

# Convert to lowercase for matching
prompt_lower=$(echo "$prompt" | tr '[:upper:]' '[:lower:]')

# Core keywords for architecture/dependency exploration
ARCHITECTURE_KEYWORDS=(
    "architecture"
    "dependenc"
    "upstream"
    "downstream"
    "impact"
    "outage"
    "incident"
    "root cause"
)

# Check if prompt matches any architecture keywords
matches_architecture=false
for keyword in "${ARCHITECTURE_KEYWORDS[@]}"; do
    if echo "$prompt_lower" | grep -qE "$keyword"; then
        matches_architecture=true
        break
    fi
done

# If architecture-related, output suggestion
if [ "$matches_architecture" = true ]; then
    cat << 'EOF'
{
  "additionalContext": "<user-prompt-submit-hook>\nOpenTrace MCP may help with this query. Consider using:\n- `search_nodes` / `query_nodes` - find components in knowledge graph\n- `traverse_dependencies` - trace service relationships\n- `get_neighbors` - explore immediate connections\n</user-prompt-submit-hook>"
}
EOF
else
    echo '{}'
fi

exit 0
