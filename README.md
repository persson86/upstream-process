# upstream-process

Framework SDD-lite para transformar uma ideia crua em um `spec.md` testavel e
fatiavel, com o humano conduzindo as decisoes e os agentes atuando sob demanda.
Sem engine, sem state machine, sem dependencia externa.

Detalhes do processo: [`PROCESS.md`](PROCESS.md).

## Instalacao em outro projeto

A partir deste repo, rode o instalador apontando para o projeto-alvo:

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

Os outputs (`proposal.md`, `spec.md`, `qa-verdict.md`) ficam em `up-docs/<slug>/`
na raiz do projeto — separados dos arquivos do framework. O instalador ajusta
apenas o path de `templates/` dos agentes para `upstream-process/templates/`, de
modo que resolva a partir da raiz do projeto-alvo.

## Uso

Dentro do projeto onde foi instalado:

1. `@up-discovery` — dialogo socratico; ao seu comando explicito, gera
   `up-docs/<slug>/proposal.md`.
2. `@up-spec` — le o proposal, pergunta nos gaps de escopo, roda o QA-gate e
   emite `up-docs/<slug>/spec.md` com features numeradas.
