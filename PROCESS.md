# Upstream Process

Framework SDD-lite para transformar uma ideia crua em um `spec.md` testavel e fatiavel, com o usuario conduzindo as decisoes e os agentes atuando apenas sob demanda.

## Principios

- Humano conduz o fluxo. O processo nao tem engine, state machine, auto-handoff ou dependencia externa.
- Projeto autocontido: ignora as regras AIOX do diretorio-pai (`projetos/.claude/`). Ver `CLAUDE.md`.
- Cada POC mora em `up-docs/<slug>/` e contem `proposal.md`, `spec.md` e `qa-verdict.md`.
- `up-discovery` escreve o proposal somente quando o usuario pedir explicitamente.
- `up-spec` possui o artefato `spec.md` e decide, por gap, entre perguntar ao usuario, chamar uma lente isolada ou assumir registrando a assuncao.
- Spawns sao fechados: `@up-spec` so pode chamar `up-architect` ou `up-qa`.
- QA e gate, nao conselho opcional. O `up-qa` escreve seu veredito em `up-docs/<slug>/qa-verdict.md` (fonte de verdade); o `@up-spec` o copia verbatim para o `spec.md` mas nao pode edita-lo.

## Fases

| Fase | Agente | Entrada | Saida | Gate humano |
| --- | --- | --- | --- | --- |
| 1. Discovery | `@up-discovery` | Ideia, contexto e respostas do usuario | `up-docs/<slug>/proposal.md` | Usuario pede explicitamente para gerar |
| 2. Spec | `@up-spec` | `up-docs/<slug>/proposal.md` | `up-docs/<slug>/spec.md` | Usuario aprova o spec e o QA-gate nao esta em `FAIL` |

## Fase 1: Discovery

Objetivo: fundir insight, contexto e proposta em uma conversa socratica curta o suficiente para convergir, mas forte o suficiente para expor raciocinio fraco.

Operacao:

1. Fazer uma pergunta focada por vez.
2. Refletir o entendimento de volta quando houver nova informacao relevante.
3. Nomear explicitamente o que ainda esta nebuloso.
4. Desafiar propostas sem evidencia, escopo largo demais ou sucesso impossivel de verificar.
5. Sinalizar quando ha contexto suficiente, mas nao escrever arquivo sem comando claro do usuario.

O `up-docs/<slug>/proposal.md` deve caber aproximadamente em uma pagina. Ele registra problema/oportunidade, contexto, evidencia, opcoes consideradas, proposta recomendada, riscos e assuncoes abertas.

## Fase 2: Spec

Objetivo: transformar `up-docs/<slug>/proposal.md` em um `up-docs/<slug>/spec.md` implementavel, com JTBD, user stories, features numeradas e criterios de aceite testaveis.

Operacao do `@up-spec`:

1. Ler `up-docs/<slug>/proposal.md`.
2. Fazer um gap scan de intencao, prioridade, escopo, viabilidade tecnica, riscos e testabilidade.
3. Para cada gap, escolher um movimento:
   - perguntar ao usuario quando o gap for de intencao, prioridade ou escopo;
   - chamar `up-architect` quando a viabilidade tecnica exigir ler codigo, stack ou restricoes de implementacao;
   - assumir e sinalizar quando a assuncao for pequena, reversivel e nao bloquear o spec.
4. Rascunhar `up-docs/<slug>/spec.md`.
5. Chamar `up-qa` passando somente `proposal.md` e o draft de `spec.md`. O `up-qa` escreve o veredito em `up-docs/<slug>/qa-verdict.md`.
6. Ler `qa-verdict.md` e copiar o veredito verbatim na secao fixa de QA-gate do spec.
7. Finalizar apenas se o gate permitir.

## Regras De Spawn

- `@up-spec` pode spawnar somente `up-architect` e `up-qa`.
- `up-architect` e opcional e usado apenas para viabilidade tecnica que depende de ler codigo, stack ou restricoes concretas.
- `up-qa` e obrigatorio antes de finalizar qualquer `spec.md`.
- Helpers independentes podem rodar em paralelo quando a ferramenta suportar.
- Helpers nao possuem o artefato final. Eles retornam pareceres; `@up-spec` incorpora ou responde aos achados.

## QA-Gate

O `up-qa` recebe apenas:

- `up-docs/<slug>/proposal.md`;
- draft atual de `up-docs/<slug>/spec.md`.

Ele nao recebe a deliberacao do `@up-spec`, historico interno ou justificativas adicionais. **O proprio `up-qa` escreve o veredito em `up-docs/<slug>/qa-verdict.md`** — esse arquivo existe independente do `@up-spec`, que nao pode edita-lo.

Vereditos:

- `PASS`: o `spec.md` pode ser finalizado.
- `CONCERNS`: caminho padrao e resolver os achados (re-rodar `up-qa` ate `PASS`); waiver e excecao e exige pedido explicito do usuario, registrado no `spec.md`.
- `FAIL`: bloqueia a finalizacao. O `@up-spec` deve revisar o draft e rodar novo QA-gate (o `up-qa` reescreve `qa-verdict.md`).

O `@up-spec` nao pode editar, resumir ou descartar o veredito. Deve copia-lo verbatim de `qa-verdict.md` para a secao `QA-Gate` do `spec.md`.

## Artefatos

- Diretorio de cada POC: `up-docs/<slug>/` com `proposal.md`, `spec.md`, `qa-verdict.md`.
- Template de proposta: `templates/proposal.md`.
- Template de spec: `templates/spec.md`.
- Agentes de menu: `.claude/agents/up-discovery.md` e `.claude/agents/up-spec.md`.
- Alvos internos de spawn: `.claude/agents/up-architect.md` e `.claude/agents/up-qa.md`.

## Dry-Run De Validacao

1. Invocar `@up-discovery` com uma ideia pequena e definir o `<slug>`.
2. Confirmar que ele conversa primeiro e so escreve `up-docs/<slug>/proposal.md` quando o usuario pedir.
3. Invocar `@up-spec`.
4. Confirmar que ele pergunta ao usuario em gaps de escopo/intencao, nao spawna sem necessidade, roda `up-qa` e gera `up-docs/<slug>/spec.md` com features numeradas.
5. Confirmar que `up-qa` escreveu `up-docs/<slug>/qa-verdict.md`, que o veredito esta copiado verbatim no spec e que `FAIL` bloqueia a finalizacao.
