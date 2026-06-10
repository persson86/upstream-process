#!/usr/bin/env bash
#
# sdd-lite installer
#
# Copies the SDD-lite framework into a target project:
#   - <target>/.claude/agents/*.md         (upstream: discovery, spec, spec-architect, spec-design, spec-qa)
#   - <target>/.claude/agents/build*.md    (downstream: build, build-qa)
#   - ~/.codex/skills/*/                   (Codex skills — global; Codex only loads from ~/.codex/skills/)
#   - <target>/sdd-lite/PROCESS.md (the backbone of the process, includes the build-qa runbook)
#   - <target>/sdd-lite/UI_BASELINE.md (UI/UX quality baseline + default UI tokens)
#   - <target>/sdd-lite/sdd-templates/ (proposal.md, spec.md, design-brief.md, run-manifest.md, build-report.md, build-qa-report.md)
#   - <target>/sdd-docs/                     (YOUR outputs: each POC in sdd-docs/<slug>/)
#
# Outputs live in sdd-docs/ at the root of the project (separated from the framework) and
# resolve the same way standalone or installed, without rewrite. Only the path
# of sdd-templates/, PROCESS.md, and UI_BASELINE.md from the agents is rewritten
# to the sdd-lite/ package prefix (the framework content lives under sdd-lite/
# in the target). The rewrite is idempotent: does not re-prefix paths that
# already have the prefix.
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

echo "sdd-lite installer starting..." >&2

PKG="sdd-lite"   # subdirectory created in the target
REF="${UP_REF:-main}"    # branch/tag from which to download in remote mode
VERSION=""               # filled after SRC is resolved
TMP_ROOT=""

cleanup() {
  if [ -n "$TMP_ROOT" ]; then
    rm -rf "$TMP_ROOT"
  fi
}
trap cleanup EXIT

download_url() {
  url="$1"
  label="$2"
  attempt=1
  max_attempts=5
  status=0

  while [ "$attempt" -le "$max_attempts" ]; do
    if curl -fsSL --connect-timeout 10 --max-time 30 "$url"; then
      return 0
    else
      status=$?
    fi

    if [ "$attempt" -lt "$max_attempts" ]; then
      echo "warning: failed to download $label (attempt $attempt/$max_attempts); retrying..." >&2
      sleep 1
    fi
    attempt=$((attempt + 1))
  done

  echo "error: failed to download $label from $url" >&2
  return "$status"
}

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
  command -v tar >/dev/null 2>&1 || { echo "error: tar is required in remote mode." >&2; exit 1; }
  TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sdd-lite-install.XXXXXX")"
  ARCHIVE="$TMP_ROOT/sdd-lite.tar.gz"
  ARCHIVE_URL="https://codeload.github.com/persson86/sdd-lite/tar.gz/$REF"
  echo "Downloading sdd-lite ($REF) from GitHub..." >&2
  if ! download_url "$ARCHIVE_URL" "sdd-lite archive ($REF)" > "$ARCHIVE"; then
    exit 1
  fi
  if ! tar -xzf "$ARCHIVE" -C "$TMP_ROOT"; then
    echo "error: failed to extract sdd-lite archive." >&2
    exit 1
  fi
  PACKAGE_DIRS=("$TMP_ROOT"/sdd-lite-*)
  if [ ! -d "${PACKAGE_DIRS[0]}" ]; then
    echo "error: extracted archive did not contain sdd-lite package files." >&2
    exit 1
  fi
  SRC="${PACKAGE_DIRS[0]}"
  MODE="local"
  VERSION="$(cat "$SRC/VERSION" 2>/dev/null || echo "unknown")"
  echo "Archive extracted. Installing files..." >&2
fi
VERSION="${VERSION// /}"   # strip whitespace

# fetch <relpath>: outputs the content of the package file to stdout.
fetch() {
  if [ "$MODE" = "local" ]; then
    cat "$SRC/$1"
  else
    echo "error: remote package was not resolved before fetching $1." >&2
    exit 1
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
CODEX_SKILLS_DIR="$HOME/.codex/skills"

# --- collision check ---------------------------------------------------
if [ "$FORCE" -eq 0 ]; then
  collisions=()
  for a in "${AGENTS[@]}"; do
    [ -f "$TARGET/.claude/agents/$a.md" ] && collisions+=(".claude/agents/$a.md")
  done
  for s in discovery spec spec-architect spec-design spec-qa build build-qa; do
    [ -f "$CODEX_SKILLS_DIR/$s/SKILL.md" ] && collisions+=("~/.codex/skills/$s/SKILL.md")
  done
  for f in PROCESS.md UI_BASELINE.md sdd-templates/proposal.md sdd-templates/spec.md sdd-templates/design-brief.md sdd-templates/run-manifest.md sdd-templates/build-report.md sdd-templates/build-qa-report.md .version; do
    [ -f "$TARGET/$PKG/$f" ] && collisions+=("$PKG/$f")
  done
  if [ "${#collisions[@]}" -gt 0 ]; then
    echo "error: files already exist in target (use --force to overwrite):" >&2
    printf '  %s\n' "${collisions[@]}" >&2
    exit 1
  fi
fi

# rewrites `sdd-templates/ (preceded by backtick or space), `PROCESS.md`, and
# `UI_BASELINE.md` (delimited by backticks) to the package prefix. Paths already
# prefixed (preceded by /) do not match (idempotent).
rewrite() {
  sed \
    -e "s#\([\` ]\)sdd-templates/#\1$PKG/sdd-templates/#g" \
    -e "s#\`PROCESS\.md\`#\`$PKG/PROCESS.md\`#g" \
    -e "s#\`UI_BASELINE\.md\`#\`$PKG/UI_BASELINE.md\`#g"
}

install_file() {
  relpath="$1"
  dest="$2"
  transform="${3:-raw}"
  tmp="$(mktemp "$dest.tmp.XXXXXX")"

  if [ "$transform" = "rewrite" ]; then
    if ! fetch "$relpath" | rewrite > "$tmp"; then
      rm -f "$tmp"
      echo "error: failed to install $relpath" >&2
      exit 1
    fi
  else
    if ! fetch "$relpath" > "$tmp"; then
      rm -f "$tmp"
      echo "error: failed to install $relpath" >&2
      exit 1
    fi
  fi

  mv "$tmp" "$dest"
}

# --- installation --------------------------------------------------
mkdir -p \
  "$TARGET/.claude/agents" \
  "$TARGET/$PKG/sdd-templates" \
  "$TARGET/sdd-docs"
for s in discovery spec spec-architect spec-design spec-qa build build-qa; do
  mkdir -p "$CODEX_SKILLS_DIR/$s/agents"
done

for a in "${AGENTS[@]}"; do
  install_file ".claude/agents/$a.md" "$TARGET/.claude/agents/$a.md" rewrite
  echo "  + .claude/agents/$a.md"
done

install_file "PROCESS.md" "$TARGET/$PKG/PROCESS.md" rewrite
echo "  + $PKG/PROCESS.md"

install_file "UI_BASELINE.md" "$TARGET/$PKG/UI_BASELINE.md"
echo "  + $PKG/UI_BASELINE.md"

install_file "sdd-templates/proposal.md" "$TARGET/$PKG/sdd-templates/proposal.md"
install_file "sdd-templates/spec.md" "$TARGET/$PKG/sdd-templates/spec.md"
install_file "sdd-templates/design-brief.md" "$TARGET/$PKG/sdd-templates/design-brief.md"
install_file "sdd-templates/run-manifest.md" "$TARGET/$PKG/sdd-templates/run-manifest.md"
install_file "sdd-templates/build-report.md" "$TARGET/$PKG/sdd-templates/build-report.md"
install_file "sdd-templates/build-qa-report.md" "$TARGET/$PKG/sdd-templates/build-qa-report.md"
echo "  + $PKG/sdd-templates/{proposal,spec,design-brief,run-manifest,build-report,build-qa-report}.md"

for s in discovery spec spec-architect spec-design spec-qa build build-qa; do
  install_file ".codex/skills/$s/SKILL.md" "$CODEX_SKILLS_DIR/$s/SKILL.md" rewrite
  install_file ".codex/skills/$s/agents/openai.yaml" "$CODEX_SKILLS_DIR/$s/agents/openai.yaml"
  echo "  + ~/.codex/skills/$s/{SKILL.md,agents/openai.yaml}"
done

# --- cleanup of files removed from the framework ------------------------
# build-frontend/build-backend were removed in v0.7.0 (build implements
# all features directly). Remove them from targets updated from <= 0.6.x.
for obsolete in \
  ".claude/agents/build-frontend.md" \
  ".claude/agents/build-backend.md"; do
  if [ -f "$TARGET/$obsolete" ]; then
    rm -f "$TARGET/$obsolete"
    echo "  - $obsolete  (obsolete, removed)"
  fi
done
# remove obsolete project-level skill dirs (used before v0.9.1)
for obsolete_skill in build-frontend build-backend build build-qa discovery spec spec-architect spec-design spec-qa; do
  rm -f "$TARGET/.codex/skills/$obsolete_skill/SKILL.md" \
        "$TARGET/.codex/skills/$obsolete_skill/agents/openai.yaml" 2>/dev/null || true
  rmdir "$TARGET/.codex/skills/$obsolete_skill/agents" \
        "$TARGET/.codex/skills/$obsolete_skill" 2>/dev/null || true
done
rmdir "$TARGET/.codex/skills" "$TARGET/.codex" 2>/dev/null || true
# remove obsolete global skills from pre-v0.9.1 manual copy
for obsolete_global in build-frontend build-backend; do
  rm -f "$CODEX_SKILLS_DIR/$obsolete_global/SKILL.md" \
        "$CODEX_SKILLS_DIR/$obsolete_global/agents/openai.yaml" 2>/dev/null || true
  rmdir "$CODEX_SKILLS_DIR/$obsolete_global/agents" \
        "$CODEX_SKILLS_DIR/$obsolete_global" 2>/dev/null || true
done

printf '%s\n' "$VERSION" > "$TARGET/$PKG/.version"
echo "  + $PKG/.version  ($VERSION)"

echo "  + sdd-docs/  (your outputs go here)"

echo
echo "sdd-lite v$VERSION installed in: $TARGET"
echo "Codex skills installed in: $CODEX_SKILLS_DIR"
echo "Restart Codex to activate the skills, then start with:  \$discovery"
