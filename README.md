# sdd-lite

Framework SDD-lite em **dois regimes**, com a linha tracada no `spec.md`:
**upstream** (Discovery → Spec) o humano conduz, passo a passo; **downstream**
(Build → Down-QA) e autonomo — com o spec aprovado, `@build-lead` constroi, valida
via `down-qa` em loop e entrega sem gate humano, escalando so por excecao. Sem
engine nem state machine; o loop roda na invocacao do lider.

Detalhes do processo: [`PROCESS.md`](PROCESS.md).

## Instalacao em outro projeto

### Via linha de comando (recomendado)

De dentro da pasta do projeto-alvo, rode:

```bash
curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/main/install.sh | bash
```

Variantes:

```bash
# alvo especifico em vez do diretorio atual
curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/main/install.sh | bash -s -- /caminho/do/projeto

# sobrescrever instalacao existente
curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/main/install.sh | bash -s -- . --force
```

> Prefere inspecionar antes de executar? Baixe e leia o script primeiro:
> ```bash
> curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/main/install.sh -o install.sh
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
├── .claude/agents/build-lead.md     # [menu] downstream autonomo: build + entrega
├── .claude/agents/build-frontend.md # [spawn] UI contra o contrato
├── .claude/agents/build-backend.md  # [spawn] servidor/API contra o contrato
├── .claude/agents/down-qa.md        # [menu/spawn] QA pos-implementacao
├── .codex/skills/up-discovery/      #
├── .codex/skills/up-spec/           #
├── .codex/skills/up-architect/      # skills Codex — mesma cobertura
├── .codex/skills/up-qa/             #  dos agentes Claude Code
├── .codex/skills/build-lead/        #
├── .codex/skills/build-frontend/    #
├── .codex/skills/build-backend/     #
├── .codex/skills/down-qa/SKILL.md   #
├── sdd-lite/                # arquivos do framework (nao editar)
│   ├── PROCESS.md           # espinha do processo (inclui o runbook do down-qa)
│   └── sdd-templates/{proposal,spec,run-manifest,build-report,down-qa-report}.md
└── sdd-docs/                         # SEUS outputs: cada POC em sdd-docs/<slug>/
```

Os outputs (`YYYY-MM-DD-proposal.md`, `YYYY-MM-DD-spec.md`,
`YYYY-MM-DD-qa-verdict.md`, `YYYY-MM-DD-run-manifest.md`,
`YYYY-MM-DD-build-report.md`, `YYYY-MM-DD-down-qa-report.md`) ficam em
`sdd-docs/<slug>/` na raiz do projeto — separados dos arquivos do framework. O instalador ajusta
apenas o path de `sdd-templates/` dos agentes para `sdd-lite/sdd-templates/`, de
modo que resolva a partir da raiz do projeto-alvo.

## Versao e atualizacao

### Verificar versao instalada

```bash
cat sdd-lite/.version
```

### Atualizar para a versao mais recente

Dentro da pasta do projeto-alvo:

```bash
curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/main/install.sh | bash -s -- . --update
```

### Fixar uma versao especifica

Use a variavel `UP_REF` para apontar para um commit, branch ou tag:

```bash
UP_REF=v0.4.0 curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/v0.4.0/install.sh | bash -s -- . --update
```

---

## Customizando o framework

O comportamento dos agentes e controlado pelos arquivos em `.claude/agents/` — Markdown puro, sem engine nem dependencia. Customizar o framework e editar esses arquivos.

### Via Claude Code (conversa)

Descreva a mudanca no chat. Exemplo:

> "quando criar algum documento, inclua a data ISO no nome do arquivo"

Claude localiza os arquivos de agentes relevantes e aplica a mudanca. Os arquivos que controlam o comportamento sao:

```
# agentes Claude Code
.claude/agents/up-discovery.md   # controla proposal.md
.claude/agents/up-spec.md        # controla spec.md e handoff para up-qa
.claude/agents/up-qa.md          # controla qa-verdict.md e contract-completeness gate
.claude/agents/up-architect.md   # controla analise de viabilidade tecnica
.claude/agents/build-lead.md     # controla o loop downstream + build-report.md/run-manifest.md
.claude/agents/build-frontend.md # controla a implementacao de UI
.claude/agents/build-backend.md  # controla a implementacao de servidor/API
.claude/agents/down-qa.md        # controla down-qa-report.md

# skills Codex (mesma cobertura)
.codex/skills/up-discovery/SKILL.md
.codex/skills/up-spec/SKILL.md
.codex/skills/up-architect/SKILL.md
.codex/skills/up-qa/SKILL.md
.codex/skills/build-lead/SKILL.md
.codex/skills/build-frontend/SKILL.md
.codex/skills/build-backend/SKILL.md
.codex/skills/down-qa/SKILL.md
```

### Via Claude Code CLI (linha de comando)

Fora de uma conversa interativa, passe a instrucao diretamente:

```bash
claude "edite .claude/agents/up-discovery.md, up-spec.md e up-qa.md para que os artefatos gerados usem o padrao YYYY-MM-DD-<doctype>.md"
```

### Via Codex

Se quiser delegar a edicao ao Codex:

```bash
claude "/codex:rescue edite os agentes do sdd-lite para nomear arquivos com YYYY-MM-DD-<doctype>.md"
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

Dentro do projeto onde foi instalado. Cada fase tem agente Claude Code (`@nome`) e
skill Codex equivalente (`/nome`).

**Upstream — humano conduz, passo a passo:**

1. `@up-discovery` / `/up-discovery` — dialogo socratico; ao seu comando
   explicito, gera `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`.
2. `@up-spec` / `/up-spec` — le o proposal, pergunta nos gaps de escopo, roda o
   QA-gate (que inclui o contract-completeness gate) e emite
   `sdd-docs/<slug>/YYYY-MM-DD-spec.md` com features numeradas. Voce aprova o spec.

**Downstream — autonomo a partir do spec aprovado (um unico comando):**

3. `@build-lead` / `/build-lead` — le o spec, constroi (direto ou spawnando
   `build-frontend`/`build-backend`), spawna `down-qa` em loop e entrega: escreve
   `run-manifest.md` + `build-report.md` com status `DELIVERED`. Sem gate humano no
   meio; escala (`ESCALATED`) so por teto de iteracoes, `BLOCKED`, sem-progresso ou
   lacuna no spec. O `@down-qa` tambem roda standalone se voce quiser validar a mao.

> **Permissoes:** "sem revisao humana" nao significa "sem permissao". Para o
> downstream rodar desatendido, configure auto-accept/allowlist no Claude Code;
> caso contrario o harness ainda pede permissao para edicoes e comandos.
