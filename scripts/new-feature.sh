#!/usr/bin/env bash
# Scaffold ai/features/<name>/{spec,tech,tasks}.md from the feature template.
# Usage: new-feature.sh <feature-name> [project-root]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$(dirname "$SCRIPT_DIR")/assets"

NAME="${1:-}"
if [ -z "$NAME" ]; then
  echo "usage: new-feature.sh <feature-name> [project-root]" >&2
  exit 1
fi
SLUG="$(printf '%s' "$NAME" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-*//; s/-*$//')"
if [ -z "$SLUG" ]; then
  echo "error: feature name must contain letters or numbers" >&2
  exit 1
fi

TARGET="${2:-$PWD}"
AI_DIR="$TARGET/ai"
FEATURE_DIR="$AI_DIR/features/$SLUG"

TEMPLATE="$AI_DIR/feature-template.md"
[ -f "$TEMPLATE" ] || TEMPLATE="$ASSETS_DIR/feature-template.md"
if [ ! -f "$TEMPLATE" ]; then
  echo "error: feature-template.md not found (run bootstrap.sh first)" >&2
  exit 1
fi

# Pull the nth ```md fenced block out of the template (1=spec, 2=tech, 3=tasks).
extract_block() {
  awk -v want="$2" '
    /^```md[[:space:]]*$/ { inblock=1; count++; next }
    /^```[[:space:]]*$/ && inblock { inblock=0; next }
    inblock && count==want { print }
  ' "$1"
}

mkdir -p "$FEATURE_DIR"
made=()
for i in 1 2 3; do
  case "$i" in 1) file=spec.md;; 2) file=tech.md;; 3) file=tasks.md;; esac
  if [ -e "$FEATURE_DIR/$file" ]; then
    continue
  fi
  extract_block "$TEMPLATE" "$i" \
    | sed "s/<Name>/$NAME/g; s/<feature-name>/$SLUG/g; s/<name>/$SLUG/g" \
    > "$FEATURE_DIR/$file"
  made+=("$file")
done

if [ "${#made[@]}" -eq 0 ]; then
  echo "feature already exists: $FEATURE_DIR (nothing overwritten)"
else
  echo "created ai/features/$SLUG/: ${made[*]}"
fi
