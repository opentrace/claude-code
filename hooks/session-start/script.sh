#!/usr/bin/env bash

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "You have access to OpenTrace, a knowledge graph that maps the user's system architecture, service relationships, and project metadata. Use your local tools (Read, Grep, Glob, etc.) for anything within the current codebase. Use OpenTrace when you need context beyond the local project — such as discovering upstream/downstream services, finding related classes or endpoints in other repositories, understanding deployment topology, looking up issues and tickets, or tracing how components connect across the system. When a question touches anything outside the current repo, consider checking OpenTrace. Always inform the user when you are about to use OpenTrace and briefly explain what you are looking for."
  }
}
EOF

exit 0
