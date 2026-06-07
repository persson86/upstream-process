# upstream-process

Framework SDD-lite para transformar uma ideia crua em um `spec.md` testavel e
fatiavel, com o humano conduzindo as decisoes e os agentes atuando sob demanda.
Sem engine, sem state machine, sem dependencia externa.

Detalhes do processo: [`PROCESS.md`](PROCESS.md).

## Instalacao em outro projeto

### Via linha de comando (recomendado)

De dentro da pasta do projeto-alvo, rode:

```bash
curl -fsSL https://raw.githubusercontent.com/persson86/upstream-process/main/install.sh | bash
```

Variantes:

```bash
# alvo especifico em vez do diretorio atual
curl -fsSL https://raw.githubusercontent.com/persson86/upstream-process/main/install.sh | bash -s -- /caminho/do/projeto

# sobrescrever instalacao existente
curl -fsSL https://raw.githubusercontent.com/persson86/upstream-process/main/install.sh | bash -s -- . --force
```

> Prefere inspecionar antes de executar? Baixe e leia o script primeiro:
> ```bash
> curl -fsSL https://raw.githubusercontent.com/persson86/upstream-process/main/install.sh -o install.sh
> less install.sh && bash install.sh
> ```

### A partir de um clone local

```bash
./install.sh /caminho/do/projeto          # instala no projeto
./install.sh /caminho/do/projeto --force  # sobrescreve se ja existir
./install.sh                              # instala no diretorio atual
```

O que e criado no alvo:

```
<projeto>/
├── .claude/agents/up-discovery.md   # [menu] socratico -> proposal.md
├── .claude/agents/up-spec.md        # [menu] lider: possui o spec.md
├── .claude/agents/up-architect.md   # [spawn] viabilidade tecnica
├── .claude/agents/up-qa.md          # [spawn] QA-gate isolado
├── upstream-process/                # arquivos do framework (nao editar)
│   ├── PROCESS.md
│   └── templates/{proposal,spec}.md
└── up-docs/                         # SEUS outputs: cada POC em up-docs/<slug>/
```

Os outputs (`YYYY-MM-DD-proposal.md`, `YYYY-MM-DD-spec.md`, `YYYY-MM-DD-qa-verdict.md`) ficam em `up-docs/<slug>/`
na raiz do projeto — separados dos arquivos do framework. O instalador ajusta
apenas o path de `templates/` dos agentes para `upstream-process/templates/`, de
modo que resolva a partir da raiz do projeto-alvo.

## Versao e atualizacao

### Verificar versao instalada

```bash
cat upstream-process/.version
```

### Atualizar para a versao mais recente

Dentro da pasta do projeto-alvo:

```bash
curl -fsSL https://raw.githubusercontent.com/persson86/upstream-process/main/install.sh | bash -s -- . --update
```

### Fixar uma versao especifica

Use a variavel `UP_REF` para apontar para um commit, branch ou tag:

```bash
UP_REF=v0.2.0 curl -fsSL https://raw.githubusercontent.com/persson86/upstream-process/v0.2.0/install.sh | bash -s -- . --update
```

---

## Customizando o framework

O comportamento dos agentes e controlado pelos arquivos em `.claude/agents/` — Markdown puro, sem engine nem dependencia. Customizar o framework e editar esses arquivos.

### Via Claude Code (conversa)

Descreva a mudanca no chat. Exemplo:

> "quando criar algum documento, inclua a data ISO no nome do arquivo"

Claude localiza os arquivos de agentes relevantes e aplica a mudanca. Os arquivos que controlam o comportamento sao:

```
.claude/agents/up-discovery.md   # controla proposal.md
.claude/agents/up-spec.md        # controla spec.md e handoff para up-qa
.claude/agents/up-qa.md          # controla qa-verdict.md
.claude/agents/up-architect.md   # controla analise de viabilidade tecnica
```

### Via Claude Code CLI (linha de comando)

Fora de uma conversa interativa, passe a instrucao diretamente:

```bash
claude "edite .claude/agents/up-discovery.md, up-spec.md e up-qa.md para que os artefatos gerados usem o padrao YYYY-MM-DD-<doctype>.md"
```

### Via Codex

Se quiser delegar a edicao ao Codex:

```bash
claude "/codex:rescue edite os agentes do upstream-process para nomear arquivos com YYYY-MM-DD-<doctype>.md"
```

### Via editor direto

```bash
# editor de preferencia
vim .claude/agents/up-discovery.md
```

### Propagando para projetos ja instalados

O `install.sh` copia os agentes no momento da instalacao. Projetos existentes **nao recebem atualizacoes automaticas** — veja a secao "Versao e atualizacao" acima.

---

## Uso

Dentro do projeto onde foi instalado:

1. `@up-discovery` — dialogo socratico; ao seu comando explicito, gera
   `up-docs/<slug>/proposal.md`.
2. `@up-spec` — le o proposal, pergunta nos gaps de escopo, roda o QA-gate e
   emite `up-docs/<slug>/spec.md` com features numeradas.
