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

O que e copiado para o alvo:

```
<projeto>/
├── .claude/agents/up-discovery.md   # [menu] socratico -> proposal.md
├── .claude/agents/up-spec.md        # [menu] lider: possui o spec.md
├── .claude/agents/up-architect.md   # [spawn] viabilidade tecnica
├── .claude/agents/up-qa.md          # [spawn] QA-gate isolado
└── upstream-process/
    ├── PROCESS.md
    ├── templates/{proposal,spec}.md
    └── runs/                        # cada POC vive em runs/<slug>/
```

O instalador ajusta os paths dos agentes (`templates/`, `runs/`) para o prefixo
`upstream-process/`, de modo que resolvam a partir da raiz do projeto-alvo. Nao
copia `CLAUDE.md` (reset de escopo especifico do Ops/AIOX) nem `PLAN.md`.

## Uso

Dentro do projeto onde foi instalado:

1. `@up-discovery` — dialogo socratico; ao seu comando explicito, gera
   `upstream-process/runs/<slug>/proposal.md`.
2. `@up-spec` — le o proposal, pergunta nos gaps de escopo, roda o QA-gate e
   emite `upstream-process/runs/<slug>/spec.md` com features numeradas.
