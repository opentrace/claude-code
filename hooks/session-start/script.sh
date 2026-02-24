#!/usr/bin/env bash

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "You have access to OpenTrace, a knowledge graph that maps the user's system architecture, service relationships, and project metadata. Use your local tools (Read, Grep, Glob, etc.) for anything within the current codebase. Use OpenTrace when you need context beyond the local project — such as discovering upstream/downstream services, finding related classes or endpoints in other repositories, understanding deployment topology, looking up issues and tickets, or tracing how components connect across the system. When a question touches anything outside the current repo, consider checking OpenTrace. Always inform the user when you are about to use OpenTrace and briefly explain what you are looking for.\n\nProactively query OpenTrace (search_nodes, get_neighbors, traverse_dependencies) before starting work when the user's message:\n- References named services, APIs, or external integrations\n- Mentions system components, pipelines, or infrastructure\n- Involves incidents, outages, production issues, or on-call concerns\n- Asks about dependencies, impact, blast radius, or upstream/downstream effects\n- Involves editing code that integrates with external services or shared middleware\n\nAfter receiving OpenTrace tool results, automatically call the most useful follow-up tool to deepen the exploration rather than stopping to ask the user what to do next. Choose the follow-up based on which tool just ran:\n- search_nodes or query_nodes → call get_neighbors on the most relevant node\n- get_node → call get_neighbors or traverse_incoming/traverse_outgoing to understand the node's role\n- get_neighbors → call traverse_dependencies to go deeper, or find_path between two interesting neighbors\n- traverse_dependencies, traverse_incoming, or traverse_outgoing → call get_node for details on the most relevant result, or find_path between notable endpoints\n- find_path → call get_node to inspect the most critical intermediate node\n- get_node_statistics → call search_nodes to explore the most connected node types\n- find_similar_nodes → call get_neighbors to compare connection patterns\n- load_source or load_source_from_node → no follow-up needed\nDo not re-call the tool that just ran. Pick the single best follow-up. If the user's question has already been fully answered, stop and present the answer instead of exploring further."
  },
  "systemMessage": "\n\n\tOpenTrace is active — system architecture insights are available."
}
EOF

exit 0
