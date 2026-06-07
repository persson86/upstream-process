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
# Uso:
#   ./install.sh [TARGET_DIR] [--force]
#
#   TARGET_DIR   diretorio do projeto-alvo (default: diretorio atual)
#   --force      sobrescreve arquivos existentes sem abortar
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG="upstream-process"   # subdiretorio criado no alvo

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

if [ "$TARGET" = "$SRC" ]; then
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
  rewrite < "$SRC/.claude/agents/$a.md" > "$TARGET/.claude/agents/$a.md"
  echo "  + .claude/agents/$a.md"
done

rewrite < "$SRC/PROCESS.md" > "$TARGET/$PKG/PROCESS.md"
echo "  + $PKG/PROCESS.md"

cp "$SRC/templates/proposal.md" "$TARGET/$PKG/templates/proposal.md"
cp "$SRC/templates/spec.md"     "$TARGET/$PKG/templates/spec.md"
echo "  + $PKG/templates/{proposal,spec}.md"

echo "  + up-docs/  (seus outputs vao aqui)"

echo
echo "upstream-process instalado em: $TARGET"
echo "Comece com:  @up-discovery"
