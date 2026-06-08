# sdd-lite

Framework SDD-lite em **dois regimes**, com a linha tracada no `spec.md`:
**upstream** (Discovery → Spec) o humano conduz, passo a passo; **downstream**
(Build → Build-QA) e autonomo — com o spec aprovado, `@build` constroi, valida
via `build-qa` em loop e entrega sem gate humano, escalando so por excecao. Sem
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
├── .claude/agents/                   # voce chama: @discovery, @spec, @build
│   ├── discovery.md                  # [menu]  upstream  socratico -> proposal.md
│   ├── spec.md                       # [menu]  upstream  possui o spec.md
│   ├── spec-architect.md             # [spawn] do spec   viabilidade tecnica
│   ├── spec-qa.md                    # [spawn] do spec   QA-gate isolado
│   ├── build.md                      # [menu]  downstream orquestra o loop autonomo
│   ├── build-frontend.md             # [spawn] do build  UI contra o contrato
│   ├── build-backend.md              # [spawn] do build  servidor/API contra o contrato
│   └── build-qa.md                   # [spawn] do build  validacao (ou standalone)
├── .codex/skills/<nome>/SKILL.md     # skills Codex — mesma cobertura, mesmos nomes
├── sdd-lite/                         # arquivos do framework (nao editar)
│   ├── PROCESS.md                    # espinha do processo (inclui o runbook do build-qa)
│   └── sdd-templates/{proposal,spec,run-manifest,build-report,build-qa-report}.md
└── sdd-docs/                         # SEUS outputs: cada POC em sdd-docs/<slug>/
```

Os outputs (`YYYY-MM-DD-proposal.md`, `YYYY-MM-DD-spec.md`,
`YYYY-MM-DD-qa-verdict.md`, `YYYY-MM-DD-run-manifest.md`,
`YYYY-MM-DD-build-report.md`, `YYYY-MM-DD-build-qa-report.md`) ficam em
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
UP_REF=v0.5.0 curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/v0.5.0/install.sh | bash -s -- . --update
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
.claude/agents/discovery.md   # controla proposal.md
.claude/agents/spec.md        # controla spec.md e handoff para spec-qa
.claude/agents/spec-qa.md          # controla qa-verdict.md e contract-completeness gate
.claude/agents/spec-architect.md   # controla analise de viabilidade tecnica
.claude/agents/build.md     # controla o loop downstream + build-report.md/run-manifest.md
.claude/agents/build-frontend.md # controla a implementacao de UI
.claude/agents/build-backend.md  # controla a implementacao de servidor/API
.claude/agents/build-qa.md        # controla build-qa-report.md

# skills Codex (mesma cobertura)
.codex/skills/discovery/SKILL.md
.codex/skills/spec/SKILL.md
.codex/skills/spec-architect/SKILL.md
.codex/skills/spec-qa/SKILL.md
.codex/skills/build/SKILL.md
.codex/skills/build-frontend/SKILL.md
.codex/skills/build-backend/SKILL.md
.codex/skills/build-qa/SKILL.md
```

### Via Claude Code CLI (linha de comando)

Fora de uma conversa interativa, passe a instrucao diretamente:

```bash
claude "edite .claude/agents/discovery.md, spec.md e spec-qa.md para que os artefatos gerados usem o padrao YYYY-MM-DD-<doctype>.md"
```

### Via Codex

Se quiser delegar a edicao ao Codex:

```bash
claude "/codex:rescue edite os agentes do sdd-lite para nomear arquivos com YYYY-MM-DD-<doctype>.md"
```

### Via editor direto

```bash
# editor de preferencia
vim .claude/agents/discovery.md
```

### Propagando para projetos ja instalados

O `install.sh` copia os agentes no momento da instalacao. Projetos existentes **nao recebem atualizacoes automaticas** — veja a secao "Versao e atualizacao" acima.

---

## Uso

Dentro do projeto onde foi instalado. Cada fase tem agente Claude Code (`@nome`) e
skill Codex equivalente (`/nome`).

**Upstream — humano conduz, passo a passo:**

1. `@discovery` / `/discovery` — dialogo socratico; ao seu comando
   explicito, gera `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`.
2. `@spec` / `/spec` — le o proposal, pergunta nos gaps de escopo, roda o
   QA-gate (que inclui o contract-completeness gate) e emite
   `sdd-docs/<slug>/YYYY-MM-DD-spec.md` com features numeradas. Voce aprova o spec.

**Downstream — autonomo a partir do spec aprovado (um unico comando):**

3. `@build` / `/build` — le o spec, constroi (direto ou spawnando
   `build-frontend`/`build-backend`), spawna `build-qa` em loop e entrega: escreve
   `run-manifest.md` + `build-report.md` com status `DELIVERED`. Sem gate humano no
   meio; escala (`ESCALATED`) so por teto de iteracoes, `BLOCKED`, sem-progresso ou
   lacuna no spec. O `@build-qa` tambem roda standalone se voce quiser validar a mao.

> **Permissoes:** "sem revisao humana" nao significa "sem permissao". Para o
> downstream rodar desatendido, configure auto-accept/allowlist no Claude Code;
> caso contrario o harness ainda pede permissao para edicoes e comandos.
