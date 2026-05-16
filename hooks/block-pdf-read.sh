#!/bin/bash
# Intercepts Read calls on .pdf files, auto-converts with pdftotext, and
# redirects the agent to read the cached .txt instead.
set -euo pipefail

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')

[ "$tool_name" = "Read" ] || exit 0

file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

[[ "$file_path" =~ \.pdf$ ]] || exit 0

cwd=$(echo "$input" | jq -r '.cwd')
cache_dir="${cwd}/.zk-cache"
stem=$(basename "$file_path" .pdf)
cache_txt="${cache_dir}/${stem}.txt"

mkdir -p "$cache_dir"

# Reuse cache when it is newer than the PDF source
if [ -f "$cache_txt" ] && [ "$cache_txt" -nt "$file_path" ]; then
  echo "PDF auto-converted (cached). Read this file instead: ${cache_txt}" >&2
  exit 2
fi

# Locate pdftotext
PDFTOTEXT=""
for candidate in \
  "C:/Program Files/Git/mingw64/bin/pdftotext.exe" \
  "/mingw64/bin/pdftotext.exe" \
  "pdftotext"; do
  if [ -f "$candidate" ] || command -v "$candidate" &>/dev/null; then
    PDFTOTEXT="$candidate"
    break
  fi
done

if [ -z "$PDFTOTEXT" ]; then
  cat >&2 <<'EOF'
ERROR: pdftotext not found. Cannot read PDF files directly.
Install options:
  - Windows (Git for Windows): already bundled at C:/Program Files/Git/mingw64/bin/pdftotext.exe
  - macOS: brew install poppler
  - Linux: apt install poppler-utils
EOF
  exit 2
fi

if "$PDFTOTEXT" -enc UTF-8 -layout "$file_path" "$cache_txt" 2>/dev/null; then
  echo "PDF converted to text. Read this file instead: ${cache_txt}" >&2
  exit 2
else
  echo "ERROR: PDF conversion failed. File may be encrypted or corrupt: ${file_path}" >&2
  exit 2
fi
