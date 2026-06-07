#!/usr/bin/env bash
#
# upstream-process installer
#
# Copia o framework SDD-lite para dentro de um projeto-alvo:
#   - <target>/.claude/agents/up-*.md      (agentes invocaveis)
#   - <target>/upstream-process/PROCESS.md (a espinha do processo)
#   - <target>/upstream-process/templates/ (proposal.md, spec.md)
#   - <target>/upstream-process/runs/      (onde cada POC vive)
#
# Os agentes referenciam templates/ e runs/ por path relativo ao repo do
# pacote. No alvo o conteudo fica sob upstream-process/, entao os paths sao
# reescritos para upstream-process/templates/ e upstream-process/runs/. O
# rewrite e idempotente: nao re-prefixa paths que ja tem o prefixo.
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

# reescreve `templates/ e `runs/ (precedidos por backtick ou espaco) para o
# prefixo do pacote. Paths ja prefixados (precedidos por /) nao casam.
rewrite() {
  sed -e "s#\([\` ]\)templates/#\1$PKG/templates/#g" \
      -e "s#\([\` ]\)runs/#\1$PKG/runs/#g"
}

# --- instalacao ------------------------------------------------------------
mkdir -p "$TARGET/.claude/agents" "$TARGET/$PKG/templates" "$TARGET/$PKG/runs"

for a in "${AGENTS[@]}"; do
  rewrite < "$SRC/.claude/agents/$a.md" > "$TARGET/.claude/agents/$a.md"
  echo "  + .claude/agents/$a.md"
done

rewrite < "$SRC/PROCESS.md" > "$TARGET/$PKG/PROCESS.md"
echo "  + $PKG/PROCESS.md"

cp "$SRC/templates/proposal.md" "$TARGET/$PKG/templates/proposal.md"
cp "$SRC/templates/spec.md"     "$TARGET/$PKG/templates/spec.md"
echo "  + $PKG/templates/{proposal,spec}.md"

[ -f "$TARGET/$PKG/runs/.gitkeep" ] || touch "$TARGET/$PKG/runs/.gitkeep"
echo "  + $PKG/runs/"

echo
echo "upstream-process instalado em: $TARGET"
echo "Comece com:  @up-discovery"
