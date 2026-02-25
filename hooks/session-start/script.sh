#!/usr/bin/env bash

CREDENTIALS_FILE="${HOME}/.claude/.credentials.json"
OPENTRACE_API_URL="https://api.opentrace.ai"

# ---------------------------------------------------------------------------
# 0. Dependency check — jq is required for JSON output, curl for API fetch
# ---------------------------------------------------------------------------
missing_deps=()
command -v jq &>/dev/null  || missing_deps+=(jq)
command -v curl &>/dev/null || missing_deps+=(curl)

if [[ " ${missing_deps[*]} " == *" jq "* ]]; then
    # jq is required for JSON output — fall back to static heredoc
    install_list=$(IFS=", "; echo "${missing_deps[*]}")
    cat << FALLBACK
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "You have access to OpenTrace, a knowledge graph that maps the user's system architecture, service relationships, and project metadata. Use your local tools (Read, Grep, Glob, etc.) for anything within the current codebase. Use OpenTrace when you need context beyond the local project — such as discovering upstream/downstream services, finding related classes or endpoints in other repositories, understanding deployment topology, looking up issues and tickets, or tracing how components connect across the system. When a question touches anything outside the current repo, consider checking OpenTrace. Always inform the user when you are about to use OpenTrace and briefly explain what you are looking for."
  },
  "systemMessage": "\n\n\tOpenTrace is active — system architecture insights are available.\n\n\t⚠ Missing dependencies: ${install_list}. Install with: brew install ${install_list} (macOS) or sudo apt install ${install_list} (Linux)."
}
FALLBACK
    exit 0
fi

HAS_CURL=true
if [[ " ${missing_deps[*]} " == *" curl "* ]]; then
    HAS_CURL=false
fi

# ---------------------------------------------------------------------------
# 1. Extract OpenTrace OAuth access token from Claude Code credentials
# ---------------------------------------------------------------------------
access_token=""
if [ -f "$CREDENTIALS_FILE" ]; then
    access_token=$(jq -r '
        [.mcpOAuth // {} | to_entries[] |
         select(.value.serverName == "plugin:opentrace:opentrace"
                and .value.accessToken != ""
                and .value.accessToken != null) |
         .value.accessToken] | first // empty
    ' "$CREDENTIALS_FILE" 2>/dev/null) || true
fi

# ---------------------------------------------------------------------------
# 2. Fetch user / org / connection info from the OpenTrace API
# ---------------------------------------------------------------------------
connection_info=""
if [ -n "$access_token" ] && [ "$HAS_CURL" = true ]; then
    response=$(curl -s -f -X GET "${OPENTRACE_API_URL}/info" \
        -H "accept: application/json" \
        -H "Authorization: Bearer ${access_token}" \
        --connect-timeout 5 \
        --max-time 10 2>/dev/null) || true

    if [ -n "$response" ]; then
        user_org_info=$(echo "$response" | jq -r '
            "User: " + (."user.name" // ."user.id" // "unknown") +
            " | Organization: " + (."organization.name" // ."organization.id" // "unknown") +
            " (role: " + (."user.org.role" // "unknown") + ")"
        ' 2>/dev/null) || true

        connection_info=$(echo "$response" | jq -r '
            "OpenTrace Connection Info:" +
            "\n- User: " + (."user.name" // ."user.id" // "unknown") +
            "\n- Organization: " + (."organization.name" // ."organization.id" // "unknown") +
                " (role: " + (."user.org.role" // "unknown") + ")" +

            "\n\nSource Code Access:" +
            "\nUse load_source and load_source_from_node to fetch source code from: " +
                ([."user.oauths"[]?.name] |
                if length == 0 then "no providers connected."
                else join(", ") + "." end) +
            " This is useful for reading code in other services, reviewing implementations across repos, or understanding how external dependencies work — without the user needing to clone the repo locally." +

            "\n\nOrganization Integrations:" +
            "\nThe following data sources are connected and enrich the OpenTrace knowledge graph:" +
            "\n" + ([."org.integrations"[]? |
                "- " + .name + " [" + .data_type + "]"] |
                if length == 0 then "- none"
                else join("\n") end) +
            "\nSource integrations provide repository and code data; trace integrations provide request flow and latency data; issue tracking integrations provide ticket and project context; observability integrations provide dashboard and alerting context."
        ' 2>/dev/null) || true
    fi
fi

# ---------------------------------------------------------------------------
# 3. Base additionalContext — OpenTrace usage instructions for Claude
# ---------------------------------------------------------------------------
read -r -d '' base_context << 'BASEEOF' || true
You have access to OpenTrace, a knowledge graph that maps the user's system architecture, service relationships, and project metadata. Use your local tools (Read, Grep, Glob, etc.) for anything within the current codebase. Use OpenTrace when you need context beyond the local project — such as discovering upstream/downstream services, finding related classes or endpoints in other repositories, understanding deployment topology, looking up issues and tickets, or tracing how components connect across the system. When a question touches anything outside the current repo, consider checking OpenTrace. Always inform the user when you are about to use OpenTrace and briefly explain what you are looking for.

Proactively query OpenTrace (search_nodes, get_neighbors, traverse_dependencies) before starting work when the user's message:
- References named services, APIs, or external integrations
- Mentions system components, pipelines, or infrastructure
- Involves incidents, outages, production issues, or on-call concerns
- Asks about dependencies, impact, blast radius, or upstream/downstream effects
- Involves editing code that integrates with external services or shared middleware

After receiving OpenTrace tool results, automatically call the most useful follow-up tool to deepen the exploration rather than stopping to ask the user what to do next. Choose the follow-up based on which tool just ran:
- search_nodes or query_nodes → call get_neighbors on the most relevant node
- get_node → call get_neighbors or traverse_incoming/traverse_outgoing to understand the node's role
- get_neighbors → call traverse_dependencies to go deeper, or find_path between two interesting neighbors
- traverse_dependencies, traverse_incoming, or traverse_outgoing → call get_node for details on the most relevant result, or find_path between notable endpoints
- find_path → call get_node to inspect the most critical intermediate node
- get_node_statistics → call search_nodes to explore the most connected node types
- find_similar_nodes → call get_neighbors to compare connection patterns
- load_source or load_source_from_node → no follow-up needed
Do not re-call the tool that just ran. Pick the single best follow-up. If the user's question has already been fully answered, stop and present the answer instead of exploring further.

For multi-step architecture exploration — such as dependency mapping, blast radius analysis, cross-service investigation, or incident diagnosis — prefer delegating to the `opentrace:explore` agent (via the Task tool with subagent_type) rather than making direct OpenTrace calls or using the built-in Explore agent. The `opentrace:explore` agent has full access to both local codebase tools and OpenTrace's knowledge graph, with built-in traversal best practices and auto-follow-up logic. Use it whenever the question spans beyond the current repository or requires chaining multiple OpenTrace tool calls.
BASEEOF

# ---------------------------------------------------------------------------
# 4. Combine context and build system message
# ---------------------------------------------------------------------------
if [ -n "$connection_info" ]; then
    full_context=$(printf '%s\n\n%s' "$base_context" "$connection_info")
else
    full_context="$base_context"
fi

if [ -n "$user_org_info" ]; then
    system_msg=$(printf '\n\n\tOpenTrace is active — system architecture insights are available.\n\t%s' "$user_org_info")
elif [ "$HAS_CURL" = false ]; then
    system_msg=$'\n\n\tOpenTrace is active — system architecture insights are available.\n\n\t⚠ Missing dependency: curl. Install with: brew install curl (macOS) or sudo apt install curl (Linux).'
else
    system_msg=$'\n\n\tOpenTrace is active — system architecture insights are available.'
fi

# ---------------------------------------------------------------------------
# 5. Output hook JSON (jq handles all escaping)
# ---------------------------------------------------------------------------
jq -n \
    --arg ctx "$full_context" \
    --arg msg "$system_msg" \
    '{
        hookSpecificOutput: {
            hookEventName: "SessionStart",
            additionalContext: $ctx
        },
        systemMessage: $msg
    }'

exit 0
