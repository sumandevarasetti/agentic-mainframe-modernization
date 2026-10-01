#!/usr/bin/env bash
set -euo pipefail

# prepare-atlaspay-run.sh
#
# Prepare an isolated AtlasPay analysis workspace for a scored IBM Bob PP4Z run.
#
# Usage:
#   ./prepare-atlaspay-run.sh [DEST]
#
# DEST defaults to <repo-root>/.work/atlaspay-understand-001
#
# The script copies only the active application estate from examples/atlaspay/.
# It does NOT copy:
#   - archive/          (historical v0.1 fixtures)
#   - evals/            (evaluator ground truth — must never enter workspace)
#   - evidence/         (prior run evidence)
#   - .work/            (prior workspaces)
#
# After preparation:
#   1. Open DEST in IBM Bob.
#   2. Configure PP4Z / Z Understand.
#   3. Generate DD.json (strongly recommended).
#   4. Run /init to create AGENTS.md.
#   5. Merge AGENTS.framework.md into generated AGENTS.md.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
SOURCE="$ROOT/examples/atlaspay"
DEST="${1:-$ROOT/.work/atlaspay-understand-001}"

# -----------------------------------------------------------------------
# Guard: destination must not already exist
# -----------------------------------------------------------------------
if [[ -e "$DEST" ]]; then
  echo "Destination already exists: $DEST" >&2
  echo "Choose a new destination or remove it manually after confirming it is safe." >&2
  exit 1
fi

mkdir -p "$DEST"

# -----------------------------------------------------------------------
# Explicit allowlist — copy only active estate directories
# -----------------------------------------------------------------------
ALLOWLIST=(
  src
  architecture
  cics
  data
  db2
  docs
  jcl
  mq
  tests
  vsam
)

for item in "${ALLOWLIST[@]}"; do
  if [[ -e "$SOURCE/$item" ]]; then
    cp -R "$SOURCE/$item" "$DEST/$item"
  fi
done

# Top-level files
for f in README.md AGENTS.framework.md; do
  if [[ -f "$SOURCE/$f" ]]; then
    cp "$SOURCE/$f" "$DEST/$f"
  fi
done

# -----------------------------------------------------------------------
# The source repo uses AGENTS.framework.md as an overlay. A scored PP4Z run
# must let /init create the active AGENTS.md first, then merge this overlay
# manually. Remove any pre-existing AGENTS.md to ensure /init runs clean.
# -----------------------------------------------------------------------
rm -f "$DEST/AGENTS.md"

cat > "$DEST/RUN-ISOLATION.txt" <<'EOF'
AtlasPay PP4Z scored-run workspace.

This workspace was prepared from examples/atlaspay/ using an explicit allowlist.
Evaluator ground truth under evals/atlaspay/ is intentionally absent.
Historical archive material under examples/atlaspay/archive/ was not copied.
Prior modernization decision artifacts were not copied.

Run /init before merging AGENTS.framework.md into the generated AGENTS.md.
EOF

# -----------------------------------------------------------------------
# Validation: prohibited directories must NOT be present
# -----------------------------------------------------------------------
PROHIBITED_DIRS=(
  "$DEST/archive"
  "$DEST/modernization"
  "$DEST/evals"
  "$DEST/evidence"
  "$DEST/.work"
)

VALIDATION_FAILED=0

for dir in "${PROHIBITED_DIRS[@]}"; do
  if [[ -d "$dir" ]]; then
    echo "ERROR: prohibited directory present in workspace: $dir" >&2
    VALIDATION_FAILED=1
  fi
done

# Guard against evaluator ground truth ending up in the workspace via any path
if find "$DEST" -type f -name "ground-truth.yaml" | grep -q .; then
  echo "ERROR: evaluator ground truth (ground-truth.yaml) unexpectedly present in workspace" >&2
  VALIDATION_FAILED=1
fi

# Guard against prior run evidence directories
if find "$DEST" -type d -name "run-00*" | grep -q .; then
  echo "ERROR: prior run evidence directories found in workspace" >&2
  VALIDATION_FAILED=1
fi

if [[ "$VALIDATION_FAILED" -ne 0 ]]; then
  echo "Workspace preparation failed validation. Removing incomplete destination." >&2
  rm -rf "$DEST"
  exit 2
fi

echo "Prepared isolated AtlasPay workspace: $DEST"
echo "Active estate directories copied: ${ALLOWLIST[*]}"
echo "Next: open this directory in IBM Bob, configure PP4Z/Z Understand, generate DD.json, then run /init."
