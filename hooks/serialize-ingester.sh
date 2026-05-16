#!/bin/bash
# Prevents concurrent ingester agent invocations by using a timestamp-based
# lockfile. Blocks the second Agent call until the first completes.
set -euo pipefail

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')

[ "$tool_name" = "Agent" ] || exit 0

# Only serialize ingester-related agent calls
description=$(echo "$input" | jq -r '.tool_input.description // empty')
subagent_type=$(echo "$input" | jq -r '.tool_input.subagent_type // empty')
prompt=$(echo "$input" | jq -r '.tool_input.prompt // empty')

is_ingester=false
for field in "$subagent_type" "$description" "$prompt"; do
  if [[ "$field" == *"ingester"* ]] || [[ "$field" == *"ingest"* ]]; then
    is_ingester=true
    break
  fi
done

$is_ingester || exit 0

cwd=$(echo "$input" | jq -r '.cwd')
cache_dir="${cwd}/.zk-cache"
lock_file="${cache_dir}/ingester.lock"

mkdir -p "$cache_dir"

if [ -f "$lock_file" ]; then
  lock_time=$(cat "$lock_file")
  now=$(date +%s)
  age=$((now - lock_time))

  # Treat locks older than 30 minutes as stale
  if [ "$age" -lt 1800 ]; then
    cat >&2 <<EOF
ingester is already running (lock age: ${age}s). Process files sequentially — wait for the current ingest to finish before starting the next one.
EOF
    exit 2
  fi

  rm -f "$lock_file"
fi

date +%s > "$lock_file"
exit 0
