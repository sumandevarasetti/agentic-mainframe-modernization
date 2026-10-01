#!/usr/bin/env bash
# scripts/validate-book-baseline.sh
#
# Validates invariants for the v0.3.9 Book Reference Baseline.
# Exits non-zero if any required invariant fails.
#
# Usage:
#   ./scripts/validate-book-baseline.sh [--verbose]

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

VERBOSE=0
[[ "${1:-}" == "--verbose" ]] && VERBOSE=1

PASS=0
FAIL=0
WARNINGS=()

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1" >&2; FAIL=$((FAIL+1)); }
warn() { echo "  WARN: $1"; WARNINGS+=("$1"); }

# -----------------------------------------------------------------------
# The legacy term must be searched for WITHOUT embedding the full token
# literally in active book-facing source. Build it from two fragments.
# -----------------------------------------------------------------------
_L1="Agentic"
_L2="Strangler"
LEGACY_TERM="${_L1} ${_L2}"

echo "========================================"
echo " Book Baseline Validation — v0.3.9"
echo "========================================"
echo ""

# -----------------------------------------------------------------------
# 1. VERSION == 0.3.9
# -----------------------------------------------------------------------
echo "[1] VERSION == 0.3.9"
if [[ -f VERSION ]] && grep -q "^0\.3\.9" VERSION; then
  pass "VERSION is 0.3.9"
else
  fail "VERSION is not 0.3.9 (found: $(cat VERSION 2>/dev/null || echo 'MISSING'))"
fi

# -----------------------------------------------------------------------
# 2. README repository version == 0.3.9
# -----------------------------------------------------------------------
echo "[2] README repository version == 0.3.9"
if grep -q "Version.*0\.3\.9" README.md 2>/dev/null; then
  pass "README.md contains Version 0.3.9"
else
  fail "README.md does not contain Version 0.3.9"
fi

# -----------------------------------------------------------------------
# 3. MANIFEST repository version == 0.3.9
# -----------------------------------------------------------------------
echo "[3] MANIFEST.json repository version == 0.3.9"
if grep -q '"version".*"0\.3\.9"' MANIFEST.json 2>/dev/null; then
  pass "MANIFEST.json version is 0.3.9"
else
  fail "MANIFEST.json version is not 0.3.9"
fi

# -----------------------------------------------------------------------
# 4. docs/book/book-baseline.yaml says 0.3.9
# -----------------------------------------------------------------------
echo "[4] docs/book/book-baseline.yaml repository_version == 0.3.9"
if grep -q 'repository_version.*0\.3\.9' docs/book/book-baseline.yaml 2>/dev/null; then
  pass "docs/book/book-baseline.yaml has repository_version 0.3.9"
else
  fail "docs/book/book-baseline.yaml missing or does not have repository_version 0.3.9"
fi

# -----------------------------------------------------------------------
# 5. Canonical source root exists
# -----------------------------------------------------------------------
echo "[5] Canonical source root exists: examples/atlaspay/src/"
if [[ -d examples/atlaspay/src ]]; then
  pass "examples/atlaspay/src/ exists"
else
  fail "examples/atlaspay/src/ does not exist"
fi

# -----------------------------------------------------------------------
# 6. Canonical tests exist
# -----------------------------------------------------------------------
echo "[6] Canonical tests exist: examples/atlaspay/tests/golden-master/cases.yaml"
if [[ -f examples/atlaspay/tests/golden-master/cases.yaml ]]; then
  pass "examples/atlaspay/tests/golden-master/cases.yaml exists"
else
  fail "examples/atlaspay/tests/golden-master/cases.yaml does not exist"
fi

# -----------------------------------------------------------------------
# 7. Old current source path does not exist: examples/atlaspay/cobol/
# -----------------------------------------------------------------------
echo "[7] Old source path does NOT exist: examples/atlaspay/cobol/"
if [[ ! -d examples/atlaspay/cobol ]]; then
  pass "examples/atlaspay/cobol/ correctly absent"
else
  fail "examples/atlaspay/cobol/ still exists at old path (should be archived)"
fi

# -----------------------------------------------------------------------
# 8. Old chapter-03 path does not exist
# -----------------------------------------------------------------------
echo "[8] Old chapter-03 path does NOT exist: examples/atlaspay/modernization/chapter-03/"
if [[ ! -d "examples/atlaspay/modernization/chapter-03" ]]; then
  pass "examples/atlaspay/modernization/chapter-03/ correctly absent"
else
  fail "examples/atlaspay/modernization/chapter-03/ still exists (should be archived)"
fi

# -----------------------------------------------------------------------
# 9. Archive root exists
# -----------------------------------------------------------------------
echo "[9] Archive root exists: examples/atlaspay/archive/v0.1/"
if [[ -d examples/atlaspay/archive/v0.1 ]]; then
  pass "examples/atlaspay/archive/v0.1/ exists"
else
  fail "examples/atlaspay/archive/v0.1/ does not exist"
fi

# -----------------------------------------------------------------------
# 10. Current workflow path exists
# -----------------------------------------------------------------------
echo "[10] Current workflow path exists: workflows/full-agentic-modernization/"
if [[ -d workflows/full-agentic-modernization ]]; then
  pass "workflows/full-agentic-modernization/ exists"
else
  fail "workflows/full-agentic-modernization/ does not exist"
fi

# -----------------------------------------------------------------------
# 11. Old workflow path does NOT exist
# -----------------------------------------------------------------------
echo "[11] Old workflow path does NOT exist: workflows/full-agentic-strangler/"
if [[ ! -d workflows/full-agentic-strangler ]]; then
  pass "workflows/full-agentic-strangler/ correctly absent"
else
  fail "workflows/full-agentic-strangler/ still exists (should be renamed)"
fi

# -----------------------------------------------------------------------
# 12. Current framework definition exists
# -----------------------------------------------------------------------
echo "[12] Current framework definition exists: docs/agentic-mainframe-modernization.md"
if [[ -f docs/agentic-mainframe-modernization.md ]]; then
  pass "docs/agentic-mainframe-modernization.md exists"
else
  fail "docs/agentic-mainframe-modernization.md does not exist"
fi

# -----------------------------------------------------------------------
# 13. Old framework definition path does NOT exist
# -----------------------------------------------------------------------
echo "[13] Old framework definition does NOT exist: docs/agentic-strangler.md"
if [[ ! -f docs/agentic-strangler.md ]]; then
  pass "docs/agentic-strangler.md correctly absent"
else
  fail "docs/agentic-strangler.md still exists (should be renamed)"
fi

# -----------------------------------------------------------------------
# 14. prepare-atlaspay-run.sh excludes archive and prior modernization answers
# -----------------------------------------------------------------------
echo "[14] prepare-atlaspay-run.sh excludes archive and prior modernization artifacts"
SCRIPT="integrations/ibm-bob/understand/prepare-atlaspay-run.sh"
if [[ -f "$SCRIPT" ]]; then
  if grep -q "archive" "$SCRIPT" && grep -q "modernization" "$SCRIPT"; then
    pass "prepare-atlaspay-run.sh references archive and modernization exclusions"
  else
    fail "prepare-atlaspay-run.sh does not reference archive/modernization exclusions"
  fi
else
  fail "$SCRIPT does not exist"
fi

# -----------------------------------------------------------------------
# 15. Protected evaluator ground truth NOT copied under examples/ or evidence/
# -----------------------------------------------------------------------
echo "[15] Protected evaluator ground truth not copied to examples/ or evidence/"
GT_FOUND=0
if find examples/ -name "ground-truth.yaml" 2>/dev/null | grep -q .; then
  fail "ground-truth.yaml found under examples/"
  GT_FOUND=1
fi
if find evidence/ -name "ground-truth.yaml" 2>/dev/null | grep -q .; then
  fail "ground-truth.yaml found under evidence/"
  GT_FOUND=1
fi
if [[ $GT_FOUND -eq 0 ]]; then
  pass "ground-truth.yaml not found under examples/ or evidence/"
fi

# -----------------------------------------------------------------------
# 16. Evidence run directories required by the book exist
# -----------------------------------------------------------------------
echo "[16] Required evidence run directories exist"
REQUIRED_RUNS=(
  "evidence/atlaspay/runs/run-001-understand"
  "evidence/atlaspay/runs/run-002-decide"
  "evidence/atlaspay/runs/run-003-plan"
  "evidence/atlaspay/runs/run-004-transform"
  "evidence/atlaspay/runs/run-005-prove"
  "evidence/atlaspay/runs/run-006-prove-hardening"
)
for dir in "${REQUIRED_RUNS[@]}"; do
  if [[ -d "$dir" ]]; then
    pass "$dir exists"
  else
    fail "$dir is missing"
  fi
done

# -----------------------------------------------------------------------
# 17. README and book-mapping links point to existing files where practical
# -----------------------------------------------------------------------
echo "[17] Key linked files exist"
KEY_FILES=(
  "docs/agentic-mainframe-modernization.md"
  "docs/book/book-reference-baseline.md"
  "docs/book/book-baseline.yaml"
  "docs/book-mapping.md"
  "governance/human-gates.yaml"
  "governance/autonomy-policy.yaml"
  "workflows/full-agentic-modernization/workflow.yaml"
  "examples/atlaspay/README.md"
  "examples/atlaspay/AGENTS.framework.md"
  "examples/atlaspay/tests/golden-master/cases.yaml"
)
for f in "${KEY_FILES[@]}"; do
  if [[ -e "$f" ]]; then
    pass "$f exists"
  else
    fail "$f is missing"
  fi
done

# -----------------------------------------------------------------------
# 18. JSON files touched by this change parse successfully
# -----------------------------------------------------------------------
echo "[18] JSON files parse successfully"
JSON_FILES=(
  "MANIFEST.json"
)
for f in "${JSON_FILES[@]}"; do
  if [[ -f "$f" ]]; then
    if python3 -m json.tool "$f" > /dev/null 2>&1; then
      pass "$f is valid JSON"
    elif python -m json.tool "$f" > /dev/null 2>&1; then
      pass "$f is valid JSON"
    else
      fail "$f is not valid JSON"
    fi
  else
    warn "$f not found for JSON validation"
  fi
done

# -----------------------------------------------------------------------
# 19. YAML files touched by this change parse successfully
# -----------------------------------------------------------------------
echo "[19] YAML files parse successfully (if python3/PyYAML available)"
YAML_FILES=(
  "docs/book/book-baseline.yaml"
  "governance/autonomy-policy.yaml"
  "governance/human-gates.yaml"
  "workflows/full-agentic-modernization/workflow.yaml"
)
if python3 -c "import yaml" 2>/dev/null; then
  for f in "${YAML_FILES[@]}"; do
    if [[ -f "$f" ]]; then
      if python3 -c "import yaml, sys; yaml.safe_load(open('$f'))" 2>/dev/null; then
        pass "$f is valid YAML"
      else
        fail "$f is not valid YAML"
      fi
    else
      warn "$f not found for YAML validation"
    fi
  done
else
  warn "python3 PyYAML not available — YAML parsing skipped"
fi

# -----------------------------------------------------------------------
# 20. git diff --check is clean
# -----------------------------------------------------------------------
echo "[20] git diff --check is clean"
if git diff --check 2>/dev/null; then
  pass "git diff --check is clean"
else
  fail "git diff --check found whitespace issues"
fi

# -----------------------------------------------------------------------
# 21. Active book/framework files contain no old framework term
# -----------------------------------------------------------------------
echo "[21] Active book/framework files contain no legacy term"
ACTIVE_DIRS=(
  "docs"
  "agents"
  "playbooks"
  "prompts"
  "governance"
  "integrations"
  "workflows/full-agentic-modernization"
  "examples/atlaspay/AGENTS.framework.md"
  "examples/atlaspay/README.md"
  "README.md"
)
LEGACY_FOUND=0
for target in "${ACTIVE_DIRS[@]}"; do
  if [[ -e "$target" ]]; then
    # Exclude CHANGELOG.md (historical facts), archive dirs, evidence dirs
    if grep -rn "$LEGACY_TERM" "$target" \
        --include="*.md" --include="*.yaml" --include="*.json" --include="*.sh" \
        --exclude-dir="archive" \
        --exclude="CHANGELOG.md" \
        2>/dev/null | grep -q .; then
      MATCHES=$(grep -rn "$LEGACY_TERM" "$target" \
        --include="*.md" --include="*.yaml" --include="*.json" --include="*.sh" \
        --exclude-dir="archive" \
        --exclude="CHANGELOG.md" \
        2>/dev/null)
      echo "  FAIL: Legacy term found in active material:" >&2
      echo "$MATCHES" >&2
      ((FAIL++))
      LEGACY_FOUND=1
    fi
  fi
done
if [[ $LEGACY_FOUND -eq 0 ]]; then
  pass "No legacy term found in active book/framework files"
fi

# -----------------------------------------------------------------------
# 22. Synthetic AtlasPay active docs contain no real employer/institution name
# -----------------------------------------------------------------------
echo "[22] Active AtlasPay docs contain no real employer/institution name"
# Check for the specific real employer name that was removed
if grep -rn "U\.S\. Bank\|USBank" \
    examples/atlaspay/README.md \
    examples/atlaspay/AGENTS.framework.md \
    docs/ \
    2>/dev/null | grep -q .; then
  fail "Real employer/institution name found in active AtlasPay docs"
else
  pass "No real employer/institution name in active AtlasPay docs"
fi

# -----------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------
echo ""
echo "========================================"
echo " Validation Summary"
echo "========================================"
echo "  Total PASS: $PASS"
echo "  Total FAIL: $FAIL"
echo "  Warnings:   ${#WARNINGS[@]}"
if [[ ${#WARNINGS[@]} -gt 0 ]]; then
  for w in "${WARNINGS[@]}"; do
    echo "    - $w"
  done
fi
echo ""

if [[ $FAIL -gt 0 ]]; then
  echo "RESULT: VALIDATION_FAILED ($FAIL failures)"
  exit 1
else
  echo "RESULT: BOOK_BASELINE_READY_FOR_HUMAN_REVIEW"
  exit 0
fi
