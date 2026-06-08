#!/usr/bin/env bash
#
# sdd-lite installer
#
# Copia o framework SDD-lite para dentro de um projeto-alvo:
#   - <target>/.claude/agents/*.md         (upstream: discovery, spec, spec-architect, spec-qa)
#   - <target>/.claude/agents/build*.md    (downstream: build, build-frontend, build-backend, build-qa)
#   - <target>/.codex/skills/*/            (skills Codex: discovery, spec, spec-architect, spec-qa, build, build-frontend, build-backend, build-qa)
#   - <target>/sdd-lite/PROCESS.md (a espinha do processo, inclui o runbook do build-qa)
#   - <target>/sdd-lite/sdd-templates/ (proposal.md, spec.md, run-manifest.md, build-report.md, build-qa-report.md)
#   - <target>/sdd-docs/                     (SEUS outputs: cada POC em sdd-docs/<slug>/)
#
# Outputs ficam em sdd-docs/ na raiz do projeto (separados do framework) e
# resolvem do mesmo jeito standalone ou instalado, sem rewrite. Apenas o path
# de sdd-templates/ dos agentes e reescrito para sdd-lite/sdd-templates/ (o
# conteudo do framework vive sob sdd-lite/ no alvo). O rewrite e
# idempotente: nao re-prefixa paths que ja tem o prefixo.
#
# Uso (local, a partir de um clone):
#   ./install.sh [TARGET_DIR] [--force]
#
# Uso (remoto, sem clonar — roda no diretorio atual):
#   curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- /caminho/do/projeto --force
#
#   TARGET_DIR        diretorio do projeto-alvo (default: diretorio atual)
#   --force|--update  sobrescreve arquivos existentes sem abortar
#
set -euo pipefail

PKG="sdd-lite"   # subdiretorio criado no alvo
REF="${UP_REF:-main}"    # branch/tag de onde baixar no modo remoto
RAW="https://raw.githubusercontent.com/persson86/sdd-lite/$REF"
VERSION=""               # preenchido apos SRC ser resolvido

# SRC = diretorio do script quando rodado de um clone local; vazio quando
# piped (curl | bash), pois BASH_SOURCE fica indefinido sob `set -u`.
SRC=""
if [ -n "${BASH_SOURCE[0]:-}" ]; then
  SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
fi

# Modo local quando o script esta ao lado dos arquivos do pacote; senao remoto.
if [ -n "$SRC" ] && [ -f "$SRC/PROCESS.md" ]; then
  MODE="local"
  VERSION="$(cat "$SRC/VERSION" 2>/dev/null || echo "unknown")"
else
  MODE="remote"
  command -v curl >/dev/null 2>&1 || { echo "erro: curl e necessario no modo remoto." >&2; exit 1; }
  VERSION="$(curl -fsSL "$RAW/VERSION" 2>/dev/null || echo "unknown")"
fi
VERSION="${VERSION// /}"   # strip whitespace

# fetch <relpath>: emite o conteudo do arquivo do pacote em stdout.
fetch() {
  if [ "$MODE" = "local" ]; then
    cat "$SRC/$1"
  else
    curl -fsSL "$RAW/$1"
  fi
}

# --- parse de argumentos ---------------------------------------------------
TARGET=""
FORCE=0
for arg in "$@"; do
  case "$arg" in
    --force|--update) FORCE=1 ;;
    -*)               echo "erro: flag desconhecida: $arg" >&2; exit 2 ;;
    *)                TARGET="$arg" ;;
  esac
done
TARGET="${TARGET:-.}"

# --- validacao -------------------------------------------------------------
if [ ! -d "$TARGET" ]; then
  echo "erro: alvo nao e um diretorio: $TARGET" >&2
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"

if [ "$MODE" = "local" ] && [ "$TARGET" = "$SRC" ]; then
  echo "erro: o alvo e o proprio repo do pacote; instale em outro projeto." >&2
  exit 1
fi

if [ ! -d "$TARGET/.git" ]; then
  echo "aviso: $TARGET nao parece um repo git (sem .git)."
fi

AGENTS=(discovery spec spec-architect spec-qa build build-frontend build-backend build-qa)

# --- checagem de colisao ---------------------------------------------------
if [ "$FORCE" -eq 0 ]; then
  collisions=()
  for a in "${AGENTS[@]}"; do
    [ -f "$TARGET/.claude/agents/$a.md" ] && collisions+=(".claude/agents/$a.md")
  done
  for s in discovery spec spec-architect spec-qa build build-frontend build-backend build-qa; do
    [ -f "$TARGET/.codex/skills/$s/SKILL.md" ] && collisions+=(".codex/skills/$s/SKILL.md")
  done
  for f in PROCESS.md sdd-templates/proposal.md sdd-templates/spec.md sdd-templates/run-manifest.md sdd-templates/build-report.md sdd-templates/build-qa-report.md .version; do
    [ -f "$TARGET/$PKG/$f" ] && collisions+=("$PKG/$f")
  done
  if [ "${#collisions[@]}" -gt 0 ]; then
    echo "erro: arquivos ja existem no alvo (use --force para sobrescrever):" >&2
    printf '  %s\n' "${collisions[@]}" >&2
    exit 1
  fi
fi

# reescreve `sdd-templates/ (precedido por backtick ou espaco) e `PROCESS.md`
# (delimitado por backticks) para o prefixo do pacote. Paths ja prefixados
# (precedidos por /) nao casam (idempotente).
rewrite() {
  sed \
    -e "s#\([\` ]\)sdd-templates/#\1$PKG/sdd-templates/#g" \
    -e "s#\`PROCESS\.md\`#\`$PKG/PROCESS.md\`#g"
}

# --- instalacao ------------------------------------------------------------
mkdir -p \
  "$TARGET/.claude/agents" \
  "$TARGET/$PKG/sdd-templates" \
  "$TARGET/sdd-docs"
for s in discovery spec spec-architect spec-qa build build-frontend build-backend build-qa; do
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
fetch "sdd-templates/run-manifest.md"    > "$TARGET/$PKG/sdd-templates/run-manifest.md"
fetch "sdd-templates/build-report.md"    > "$TARGET/$PKG/sdd-templates/build-report.md"
fetch "sdd-templates/build-qa-report.md"  > "$TARGET/$PKG/sdd-templates/build-qa-report.md"
echo "  + $PKG/sdd-templates/{proposal,spec,run-manifest,build-report,build-qa-report}.md"

for s in discovery spec spec-architect spec-qa build build-frontend build-backend build-qa; do
  fetch ".codex/skills/$s/SKILL.md" | rewrite > "$TARGET/.codex/skills/$s/SKILL.md"
  echo "  + .codex/skills/$s/SKILL.md"
done

printf '%s\n' "$VERSION" > "$TARGET/$PKG/.version"
echo "  + $PKG/.version  ($VERSION)"

echo "  + sdd-docs/  (seus outputs vao aqui)"

echo
echo "sdd-lite v$VERSION instalado em: $TARGET"
echo "Comece com:  @discovery"
