#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DEST="${1:-$ROOT/.work/atlaspay-understand-001}"

if [[ -e "$DEST" ]]; then
  echo "Destination already exists: $DEST" >&2
  echo "Choose a new destination or remove it manually after confirming it is safe." >&2
  exit 1
fi

mkdir -p "$DEST"
cp -R "$ROOT/examples/atlaspay/." "$DEST/"

# The source repo uses AGENTS.framework.md as an overlay. A scored PP4Z run should
# let /init create the active AGENTS.md first, then merge this overlay manually.
rm -f "$DEST/AGENTS.md"

cat > "$DEST/RUN-ISOLATION.txt" <<'EOF'
AtlasPay PP4Z scored-run workspace.

This workspace was prepared from examples/atlaspay only.
Evaluator ground truth under evals/atlaspay/ is intentionally absent.

Run /init before merging AGENTS.framework.md into the generated AGENTS.md.
EOF

if find "$DEST" -type f -path '*/evals/atlaspay/*' | grep -q .; then
  echo "ERROR: evaluator ground truth unexpectedly present" >&2
  exit 2
fi

echo "Prepared isolated AtlasPay workspace: $DEST"
echo "Next: open this directory in IBM Bob, configure PP4Z/Z Understand, generate DD.json, then run /init."
