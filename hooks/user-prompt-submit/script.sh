#!/bin/bash

# OpenTrace UserPromptSubmit Hook
# Detects architecture/dependency-related queries and suggests OpenTrace tools

# Read JSON input from stdin
input_json=$(cat)

# Extract the user's prompt
prompt=$(echo "$input_json" | jq -r '.prompt // ""' 2>/dev/null)

# Convert to lowercase for matching
prompt_lower=$(echo "$prompt" | tr '[:upper:]' '[:lower:]')

# Keywords that suggest architecture/dependency exploration
ARCHITECTURE_KEYWORDS=(
    "architecture"
    "dependenc"
    "depend.* on"
    "what.*call"
    "who.*call"
    "what.*use"
    "who.*use"
    "downstream"
    "upstream"
    "service.*diagram"
    "system.*overview"
    "how does.*connect"
    "how does.*work"
    "trace.*error"
    "trace.*request"
    "impact.*change"
    "what would break"
    "blast radius"
    "outage"
    "incident"
    "500 error"
    "failing"
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
  "additionalContext": "<user-prompt-submit-hook>\nOpenTrace MCP is connected. Consider using:\n- `discover_architecture` - explore system structure\n- `dependency_analysis` - map upstream/downstream dependencies\n- `impact_analysis` - assess change impact\n- `search_nodes` / `query_nodes` - find components in knowledge graph\n- `traverse_dependencies` - trace service relationships\n</user-prompt-submit-hook>"
}
EOF
else
    echo '{}'
fi

exit 0
