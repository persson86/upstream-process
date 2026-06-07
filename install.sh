#!/usr/bin/env bash
#
# upstream-process installer
#
# Copia o framework SDD-lite para dentro de um projeto-alvo:
#   - <target>/.claude/agents/up-*.md      (agentes invocaveis)
#   - <target>/upstream-process/PROCESS.md (a espinha do processo)
#   - <target>/upstream-process/templates/ (proposal.md, spec.md)
#   - <target>/up-docs/                     (SEUS outputs: cada POC em up-docs/<slug>/)
#
# Outputs ficam em up-docs/ na raiz do projeto (separados do framework) e
# resolvem do mesmo jeito standalone ou instalado, sem rewrite. Apenas o path
# de templates/ dos agentes e reescrito para upstream-process/templates/ (o
# conteudo do framework vive sob upstream-process/ no alvo). O rewrite e
# idempotente: nao re-prefixa paths que ja tem o prefixo.
#
# Uso (local, a partir de um clone):
#   ./install.sh [TARGET_DIR] [--force]
#
# Uso (remoto, sem clonar — roda no diretorio atual):
#   curl -fsSL https://raw.githubusercontent.com/persson86/upstream-process/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- /caminho/do/projeto --force
#
#   TARGET_DIR   diretorio do projeto-alvo (default: diretorio atual)
#   --force      sobrescreve arquivos existentes sem abortar
#
set -euo pipefail

PKG="upstream-process"   # subdiretorio criado no alvo
REF="${UP_REF:-main}"    # branch/tag de onde baixar no modo remoto
RAW="https://raw.githubusercontent.com/persson86/upstream-process/$REF"

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"

# Modo local quando o script esta ao lado dos arquivos do pacote; senao remoto.
if [ -n "$SRC" ] && [ -f "$SRC/PROCESS.md" ]; then
  MODE="local"
else
  MODE="remote"
  command -v curl >/dev/null 2>&1 || { echo "erro: curl e necessario no modo remoto." >&2; exit 1; }
fi

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
    --force) FORCE=1 ;;
    -*)      echo "erro: flag desconhecida: $arg" >&2; exit 2 ;;
    *)       TARGET="$arg" ;;
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

AGENTS=(up-discovery up-spec up-architect up-qa)

# --- checagem de colisao ---------------------------------------------------
if [ "$FORCE" -eq 0 ]; then
  collisions=()
  for a in "${AGENTS[@]}"; do
    [ -f "$TARGET/.claude/agents/$a.md" ] && collisions+=(".claude/agents/$a.md")
  done
  for f in PROCESS.md templates/proposal.md templates/spec.md; do
    [ -f "$TARGET/$PKG/$f" ] && collisions+=("$PKG/$f")
  done
  if [ "${#collisions[@]}" -gt 0 ]; then
    echo "erro: arquivos ja existem no alvo (use --force para sobrescrever):" >&2
    printf '  %s\n' "${collisions[@]}" >&2
    exit 1
  fi
fi

# reescreve `templates/ (precedido por backtick ou espaco) para o prefixo do
# pacote. Paths ja prefixados (precedidos por /) nao casam (idempotente).
rewrite() {
  sed -e "s#\([\` ]\)templates/#\1$PKG/templates/#g"
}

# --- instalacao ------------------------------------------------------------
mkdir -p "$TARGET/.claude/agents" "$TARGET/$PKG/templates" "$TARGET/up-docs"

for a in "${AGENTS[@]}"; do
  fetch ".claude/agents/$a.md" | rewrite > "$TARGET/.claude/agents/$a.md"
  echo "  + .claude/agents/$a.md"
done

fetch "PROCESS.md" | rewrite > "$TARGET/$PKG/PROCESS.md"
echo "  + $PKG/PROCESS.md"

fetch "templates/proposal.md" > "$TARGET/$PKG/templates/proposal.md"
fetch "templates/spec.md"     > "$TARGET/$PKG/templates/spec.md"
echo "  + $PKG/templates/{proposal,spec}.md"

echo "  + up-docs/  (seus outputs vao aqui)"

echo
echo "upstream-process instalado em: $TARGET"
echo "Comece com:  @up-discovery"
