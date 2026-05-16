#!/bin/bash
# Removes the ingester lockfile after an Agent call completes (success or error).
set -euo pipefail

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')

[ "$tool_name" = "Agent" ] || exit 0

cwd=$(echo "$input" | jq -r '.cwd')
lock_file="${cwd}/.zk-cache/ingester.lock"

rm -f "$lock_file"
exit 0
