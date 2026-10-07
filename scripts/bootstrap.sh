#!/usr/bin/env bash
# Bootstrap the AI Dev Blueprint `ai/` folder into a project.
# Idempotent: never overwrites existing files.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$(dirname "$SCRIPT_DIR")/assets"

TARGET="${1:-$PWD}"
if [ ! -d "$TARGET" ]; then
  echo "error: target directory does not exist: $TARGET" >&2
  exit 1
fi

AI_DIR="$TARGET/ai"
mkdir -p "$AI_DIR/features" "$AI_DIR/dependencies"

copied=()
skipped=()
for f in workflow.md overview.md architecture.md roadmap.md feature-template.md; do
  if [ -e "$AI_DIR/$f" ]; then
    skipped+=("$f")
  else
    cp "$ASSETS_DIR/$f" "$AI_DIR/$f"
    copied+=("$f")
  fi
done

echo "ai/ bootstrapped in: $AI_DIR"
[ "${#copied[@]}" -gt 0 ] && echo "  created: ${copied[*]}"
[ "${#skipped[@]}" -gt 0 ] && echo "  kept existing: ${skipped[*]}"
echo "Next: say \"set up the project\" to begin Phase 1."
