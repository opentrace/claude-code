#!/usr/bin/env bash

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "You have access to OpenTrace, a knowledge graph that maps the user's system architecture, service relationships, and project metadata. Use your local tools (Read, Grep, Glob, etc.) for anything within the current codebase. Use OpenTrace when you need context beyond the local project — such as discovering upstream/downstream services, finding related classes or endpoints in other repositories, understanding deployment topology, looking up issues and tickets, or tracing how components connect across the system. When a question touches anything outside the current repo, consider checking OpenTrace. Always inform the user when you are about to use OpenTrace and briefly explain what you are looking for.\n\nProactively query OpenTrace (search_nodes, get_neighbors, traverse_dependencies) before starting work when the user's message:\n- References named services, APIs, or external integrations\n- Mentions system components, pipelines, or infrastructure\n- Involves incidents, outages, production issues, or on-call concerns\n- Asks about dependencies, impact, blast radius, or upstream/downstream effects\n- Involves editing code that integrates with external services or shared middleware"
  },
  "systemMessage": "\n\n\tOpenTrace is active — system architecture insights are available."
}
EOF

exit 0
