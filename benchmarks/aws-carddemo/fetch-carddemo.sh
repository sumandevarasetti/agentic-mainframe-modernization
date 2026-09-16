#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/aws-samples/aws-mainframe-modernization-carddemo.git"
PINNED_COMMIT="59cc6c2fd7ebd7ef7925cad552a01a4b8b6e4d5e"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${SCRIPT_DIR}/worktree"

if [[ -d "${TARGET}/.git" ]]; then
  echo "CardDemo already cloned at ${TARGET}; refreshing upstream metadata..."
  git -C "${TARGET}" fetch --all --tags
else
  rm -rf "${TARGET}"
  git clone "${UPSTREAM}" "${TARGET}"
fi

git -C "${TARGET}" checkout --detach "${PINNED_COMMIT}"

echo "CardDemo ready at: ${TARGET}"
echo "Pinned commit: $(git -C "${TARGET}" rev-parse HEAD)"
