#!/usr/bin/env bash
#
# sdd-lite installer
#
# Copies the SDD-lite framework into a target project:
#   - <target>/.claude/agents/*.md         (upstream: discovery, spec, spec-architect, spec-design, spec-qa)
#   - <target>/.claude/agents/build*.md    (downstream: build, build-qa)
#   - <target>/.codex/skills/*/            (Codex skills: discovery, spec, spec-architect, spec-design, spec-qa, build, build-qa)
#   - <target>/sdd-lite/PROCESS.md (the backbone of the process, includes the build-qa runbook)
#   - <target>/sdd-lite/sdd-templates/ (proposal.md, spec.md, design-brief.md, run-manifest.md, build-report.md, build-qa-report.md)
#   - <target>/sdd-docs/                     (YOUR outputs: each POC in sdd-docs/<slug>/)
#
# Outputs live in sdd-docs/ at the root of the project (separated from the framework) and
# resolve the same way standalone or installed, without rewrite. Only the path
# of sdd-templates/ from the agents is rewritten to sdd-lite/sdd-templates/ (the
# framework content lives under sdd-lite/ in the target). The rewrite is
# idempotent: does not re-prefix paths that already have the prefix.
#
# Usage (local, from a clone):
#   ./install.sh [TARGET_DIR] [--force]
#
# Usage (remote, without cloning — runs in the current directory):
#   curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- /path/to/project --force
#
#   TARGET_DIR        target project directory (default: current directory)
#   --force|--update  overwrites existing files without aborting
#
set -euo pipefail

PKG="sdd-lite"   # subdirectory created in the target
REF="${UP_REF:-main}"    # branch/tag from which to download in remote mode
RAW="https://raw.githubusercontent.com/persson86/sdd-lite/$REF"
VERSION=""               # filled after SRC is resolved

# SRC = directory of the script when run from a local clone; empty when
# piped (curl | bash), since BASH_SOURCE is undefined under `set -u`.
SRC=""
if [ -n "${BASH_SOURCE[0]:-}" ]; then
  SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
fi

# Local mode when the script is alongside the package files; otherwise remote.
if [ -n "$SRC" ] && [ -f "$SRC/PROCESS.md" ]; then
  MODE="local"
  VERSION="$(cat "$SRC/VERSION" 2>/dev/null || echo "unknown")"
else
  MODE="remote"
  command -v curl >/dev/null 2>&1 || { echo "error: curl is required in remote mode." >&2; exit 1; }
  VERSION="$(curl -fsSL "$RAW/VERSION" 2>/dev/null || echo "unknown")"
fi
VERSION="${VERSION// /}"   # strip whitespace

# fetch <relpath>: outputs the content of the package file to stdout.
fetch() {
  if [ "$MODE" = "local" ]; then
    cat "$SRC/$1"
  else
    curl -fsSL "$RAW/$1"
  fi
}

# --- argument parsing --------------------------------------------------
TARGET=""
FORCE=0
for arg in "$@"; do
  case "$arg" in
    --force|--update) FORCE=1 ;;
    -*)               echo "error: unknown flag: $arg" >&2; exit 2 ;;
    *)                TARGET="$arg" ;;
  esac
done
TARGET="${TARGET:-.}"

# --- validation --------------------------------------------------------
if [ ! -d "$TARGET" ]; then
  echo "error: target is not a directory: $TARGET" >&2
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"

if [ "$MODE" = "local" ] && [ "$TARGET" = "$SRC" ]; then
  echo "error: target is the package repo itself; install in another project." >&2
  exit 1
fi

if [ ! -d "$TARGET/.git" ]; then
  echo "warning: $TARGET does not appear to be a git repo (no .git)."
fi

AGENTS=(discovery spec spec-architect spec-design spec-qa build build-qa)

# --- collision check ---------------------------------------------------
if [ "$FORCE" -eq 0 ]; then
  collisions=()
  for a in "${AGENTS[@]}"; do
    [ -f "$TARGET/.claude/agents/$a.md" ] && collisions+=(".claude/agents/$a.md")
  done
  for s in discovery spec spec-architect spec-design spec-qa build build-qa; do
    [ -f "$TARGET/.codex/skills/$s/SKILL.md" ] && collisions+=(".codex/skills/$s/SKILL.md")
  done
  for f in PROCESS.md sdd-templates/proposal.md sdd-templates/spec.md sdd-templates/design-brief.md sdd-templates/run-manifest.md sdd-templates/build-report.md sdd-templates/build-qa-report.md .version; do
    [ -f "$TARGET/$PKG/$f" ] && collisions+=("$PKG/$f")
  done
  if [ "${#collisions[@]}" -gt 0 ]; then
    echo "error: files already exist in target (use --force to overwrite):" >&2
    printf '  %s\n' "${collisions[@]}" >&2
    exit 1
  fi
fi

# rewrites `sdd-templates/ (preceded by backtick or space) and `PROCESS.md`
# (delimited by backticks) to the package prefix. Paths already prefixed
# (preceded by /) do not match (idempotent).
rewrite() {
  sed \
    -e "s#\([\` ]\)sdd-templates/#\1$PKG/sdd-templates/#g" \
    -e "s#\`PROCESS\.md\`#\`$PKG/PROCESS.md\`#g"
}

# --- installation --------------------------------------------------
mkdir -p \
  "$TARGET/.claude/agents" \
  "$TARGET/$PKG/sdd-templates" \
  "$TARGET/sdd-docs"
for s in discovery spec spec-architect spec-design spec-qa build build-qa; do
  mkdir -p "$TARGET/.codex/skills/$s"
done

for a in "${AGENTS[@]}"; do
  fetch ".claude/agents/$a.md" | rewrite > "$TARGET/.claude/agents/$a.md"
  echo "  + .claude/agents/$a.md"
done

fetch "PROCESS.md" | rewrite > "$TARGET/$PKG/PROCESS.md"
echo "  + $PKG/PROCESS.md"

fetch "sdd-templates/proposal.md"        > "$TARGET/$PKG/sdd-templates/proposal.md"
fetch "sdd-templates/spec.md"            > "$TARGET/$PKG/sdd-templates/spec.md"
fetch "sdd-templates/design-brief.md"    > "$TARGET/$PKG/sdd-templates/design-brief.md"
fetch "sdd-templates/run-manifest.md"    > "$TARGET/$PKG/sdd-templates/run-manifest.md"
fetch "sdd-templates/build-report.md"    > "$TARGET/$PKG/sdd-templates/build-report.md"
fetch "sdd-templates/build-qa-report.md"  > "$TARGET/$PKG/sdd-templates/build-qa-report.md"
echo "  + $PKG/sdd-templates/{proposal,spec,design-brief,run-manifest,build-report,build-qa-report}.md"

for s in discovery spec spec-architect spec-design spec-qa build build-qa; do
  fetch ".codex/skills/$s/SKILL.md" | rewrite > "$TARGET/.codex/skills/$s/SKILL.md"
  echo "  + .codex/skills/$s/SKILL.md"
done

# --- cleanup of files removed from the framework ------------------------
# build-frontend/build-backend were removed in v0.7.0 (build implements
# all features directly). Remove them from targets updated from <= 0.6.x.
for obsolete in \
  ".claude/agents/build-frontend.md" \
  ".claude/agents/build-backend.md" \
  ".codex/skills/build-frontend/SKILL.md" \
  ".codex/skills/build-backend/SKILL.md"; do
  if [ -f "$TARGET/$obsolete" ]; then
    rm -f "$TARGET/$obsolete"
    echo "  - $obsolete  (obsolete, removed)"
  fi
done
rmdir "$TARGET/.codex/skills/build-frontend" "$TARGET/.codex/skills/build-backend" 2>/dev/null || true

printf '%s\n' "$VERSION" > "$TARGET/$PKG/.version"
echo "  + $PKG/.version  ($VERSION)"

echo "  + sdd-docs/  (your outputs go here)"

echo
echo "sdd-lite v$VERSION installed in: $TARGET"
echo "Start with:  @discovery"
