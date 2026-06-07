# upstream-process — projeto autocontido

Este projeto é **independente e autocontido**. Apesar de morar fisicamente em `Ops/projetos/`, ele **não faz parte do AIOX** e não herda suas convenções.

## Reset de escopo

- **Ignore as regras AIOX** carregadas pelo diretório-pai (`projetos/.claude/CLAUDE.md` e `projetos/.claude/rules/`): constitution, story-driven development, personas Synkra (`@dev`/Dex, `@qa`/Quinn, `@architect`/Aria etc.), gates constitucionais, workflow-execution, agent-authority, agent-handoff. Nada disso se aplica aqui.
- **Não invoque agentes AIOX** (`@aiox-master`, `@pm`, `@po`, `@sm`, `@devops`, ...). Não use comandos `*` do AIOX nem `/AIOX:agents:*`.
- **Não use `/council`** dentro deste fluxo (o usuário pode usá-lo manualmente fora dele).

## O que vale aqui

A única fonte de processo é o **`PROCESS.md`** deste diretório. Os únicos agentes são os deste projeto, prefixados `up-` para evitar colisão de nomes com o AIOX:

- `@up-discovery` — fase Discovery (socrático → `runs/<slug>/proposal.md`).
- `@up-spec` — fase Spec (líder; possui `runs/<slug>/spec.md`).
- `up-architect`, `up-qa` — alvos internos de spawn do `@up-spec` (não são de menu).

Cada POC vive em `runs/<slug>/`. Sem engine, sem state machine, sem dependência externa.
