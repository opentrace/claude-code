#!/usr/bin/env bash
#
# PreToolUse guardrail for OpenTrace traversal/neighbor tools.
# Warns when maxDepth >= 3 with no filters — a common mistake that
# returns massive result sets and can hit MCP size limits.
#
# Reads the tool input JSON from stdin. Outputs structured JSON:
#   - Warning via additionalContext when risky params detected
#   - Empty {} for safe params (silent pass-through)

set -euo pipefail

input=$(cat)

# Extract tool_input from the hook payload
tool_input=$(echo "$input" | jq -r '.tool_input // empty')

if [ -z "$tool_input" ]; then
  echo '{}'
  exit 0
fi

# Extract maxDepth (default 1 if not set)
max_depth=$(echo "$tool_input" | jq -r '.maxDepth // 1')

# Check for any filter parameters that constrain the traversal
has_filters=$(echo "$tool_input" | jq '
  (has("edgeTypes") and (.edgeTypes | length > 0)) or
  (has("nodeTypes") and (.nodeTypes | length > 0)) or
  (has("filters") and (.filters | length > 0)) or
  (has("nodeFilter") and (.nodeFilter | length > 0)) or
  (has("edgeFilter") and (.edgeFilter | length > 0)) or
  (has("limit") and .limit != null)
')

if [ "$max_depth" -ge 3 ] 2>/dev/null && [ "$has_filters" = "false" ]; then
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "WARNING: This traversal has maxDepth >= 3 with no filters. Deep unfiltered traversals often return very large result sets that hit MCP size limits and produce noisy output. Consider: (1) reducing maxDepth to 1 or 2 for initial exploration, (2) adding edgeTypes or nodeTypes filters to narrow results, or (3) using limit to cap the number of returned nodes. Start shallow, then go deeper on interesting paths."
  }
}
EOF
else
  echo '{}'
fi

exit 0
