# SDD-lite

Framework SDD-lite para transformar uma ideia crua em um `spec.md` testavel e fatiavel, com o usuario conduzindo as decisoes e os agentes atuando apenas sob demanda.

## Principios

O fluxo tem **dois regimes**, com a linha tracada no `spec.md`:

- **Upstream (Discovery, Spec): humano conduz**, passo a passo. Sem auto-handoff;
  cada fase avanca por decisao do usuario.
- **Downstream (Build, Down-QA): autonomo** a partir do spec aprovado. O humano
  aciona uma vez; o `build-lead` constroi, valida via `down-qa` e entrega sem gate
  humano, escalando so pelo disjuntor. Auto-handoff build↔down-qa existe **apenas
  aqui**, e ainda sem engine/state machine (o loop roda na invocacao do lider).

Demais principios:

- Projeto autocontido: sem heranca de outros frameworks; o que for util de fora, copia-se para dentro.
- Cada POC mora em `sdd-docs/<slug>/` e contem `YYYY-MM-DD-proposal.md`, `YYYY-MM-DD-spec.md`, `YYYY-MM-DD-qa-verdict.md`, `YYYY-MM-DD-run-manifest.md`, `YYYY-MM-DD-build-report.md` e `YYYY-MM-DD-down-qa-report.md`.
- `up-discovery` escreve o proposal somente quando o usuario pedir explicitamente.
- `up-spec` possui o artefato `spec.md` e decide, por gap, entre perguntar ao usuario, chamar uma lente isolada ou assumir registrando a assuncao.
- Spawns sao fechados: `@up-spec` so chama `up-architect`/`up-qa`; `@build-lead` so chama `build-frontend`, `build-backend` ou `down-qa`.
- **O gate `up-qa` e load-bearing.** Como o downstream entrega sem revisao humana, o spec e a unica garantia: o `up-qa` da `FAIL` se uma feature cruza fronteira FE/BE e o `Contrato de Integracao` esta ausente/ambiguo. QA e gate, nao conselho opcional; o `up-qa` escreve `qa-verdict.md` (fonte de verdade) e o `@up-spec` o copia verbatim, sem editar.
- **Isolamento creator/verifier no downstream:** o `build-lead` constroi e corrige; o `down-qa` so le `spec.md` + `run-manifest.md` (nunca o `build-report.md`) e julga. PASS exige cobertura total dos criterios.

## Fases

| Fase | Regime | Agente | Entrada | Saida | Gate humano |
| --- | --- | --- | --- | --- | --- |
| 1. Discovery | upstream | `@up-discovery` | Ideia, contexto e respostas do usuario | `sdd-docs/<slug>/YYYY-MM-DD-proposal.md` | Usuario pede explicitamente para gerar |
| 2. Spec | upstream | `@up-spec` | `sdd-docs/<slug>/YYYY-MM-DD-proposal.md` | `sdd-docs/<slug>/YYYY-MM-DD-spec.md` | Usuario aprova o spec e o QA-gate nao esta em `FAIL` |
| 3. Build | downstream | `@build-lead` | `sdd-docs/<slug>/YYYY-MM-DD-spec.md` aprovado | `run-manifest.md` + `build-report.md` (`DELIVERED`/`ESCALATED`) | Apenas aciona; sem gate ate `DELIVERED` ou disjuntor escalar |
| 4. Down-QA | downstream | `@down-qa` (spawn do `build-lead` ou standalone) | `spec.md` + `run-manifest.md` | `sdd-docs/<slug>/YYYY-MM-DD-down-qa-report.md` | Nenhum no loop autonomo; standalone, o usuario decide |

## Fase 1: Discovery

Objetivo: fundir insight, contexto e proposta em uma conversa socratica curta o suficiente para convergir, mas forte o suficiente para expor raciocinio fraco.

Operacao:

1. Fazer uma pergunta focada por vez.
2. Refletir o entendimento de volta quando houver nova informacao relevante.
3. Nomear explicitamente o que ainda esta nebuloso.
4. Desafiar propostas sem evidencia, escopo largo demais ou sucesso impossivel de verificar.
5. Sinalizar quando ha contexto suficiente, mas nao escrever arquivo sem comando claro do usuario.

O `sdd-docs/<slug>/YYYY-MM-DD-proposal.md` deve caber aproximadamente em uma pagina. Ele registra problema/oportunidade, contexto, evidencia, opcoes consideradas, proposta recomendada, riscos e assuncoes abertas.

## Fase 2: Spec

Objetivo: transformar `sdd-docs/<slug>/proposal.md` em um `sdd-docs/<slug>/spec.md` implementavel, com JTBD, user stories, features numeradas e criterios de aceite testaveis.

Operacao do `@up-spec`:

1. Ler `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`.
2. Fazer um gap scan de intencao, prioridade, escopo, viabilidade tecnica, riscos e testabilidade.
3. Para cada gap, escolher um movimento:
   - perguntar ao usuario quando o gap for de intencao, prioridade ou escopo;
   - chamar `up-architect` quando a viabilidade tecnica exigir ler codigo, stack ou restricoes de implementacao;
   - assumir e sinalizar quando a assuncao for pequena, reversivel e nao bloquear o spec.
4. Rascunhar `sdd-docs/<slug>/YYYY-MM-DD-spec.md`.
5. Chamar `up-qa` passando somente `YYYY-MM-DD-proposal.md` e o draft de `YYYY-MM-DD-spec.md`. O `up-qa` escreve o veredito em `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md`.
6. Ler `YYYY-MM-DD-qa-verdict.md` e copiar o veredito verbatim na secao fixa de QA-gate do spec.
7. Finalizar apenas se o gate permitir.

## Regras De Spawn

- `@up-spec` pode spawnar somente `up-architect` e `up-qa`.
- `@build-lead` pode spawnar somente `build-frontend`, `build-backend` e `down-qa`.
- `up-architect` e opcional e usado apenas para viabilidade tecnica que depende de ler codigo, stack ou restricoes concretas.
- `up-qa` e obrigatorio antes de finalizar qualquer `spec.md`.
- `down-qa` e obrigatorio em cada iteracao do downstream; roda fresh com a allowlist `{spec.md, run-manifest.md}`.
- Helpers independentes podem rodar em paralelo quando a ferramenta suportar (ex.: `build-frontend ‖ build-backend`).
- Helpers nao possuem o artefato final. Eles retornam pareceres/codigo; `@up-spec`/`@build-lead` incorpora ou responde aos achados.

## QA-Gate

O `up-qa` recebe apenas:

- `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`;
- draft atual de `sdd-docs/<slug>/YYYY-MM-DD-spec.md`.

Ele nao recebe a deliberacao do `@up-spec`, historico interno ou justificativas adicionais. **O proprio `up-qa` escreve o veredito em `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md`** — esse arquivo existe independente do `@up-spec`, que nao pode edita-lo.

Vereditos:

- `PASS`: o `spec.md` pode ser finalizado.
- `CONCERNS`: caminho padrao e resolver os achados (re-rodar `up-qa` ate `PASS`); waiver e excecao e exige pedido explicito do usuario, registrado no `spec.md`.
- `FAIL`: bloqueia a finalizacao. O `@up-spec` deve revisar o draft e rodar novo QA-gate (o `up-qa` reescreve `qa-verdict.md`).

O `@up-spec` nao pode editar, resumir ou descartar o veredito. Deve copia-lo verbatim de `qa-verdict.md` para a secao `QA-Gate` do `spec.md`. Alem dos vereditos acima, o `up-qa` da `FAIL` quando uma feature cruza fronteira FE/BE ou integracao externa e o `Contrato de Integracao` do spec esta ausente, incompleto ou ambiguo (contract-completeness gate) — a lacuna se resolve no Spec, nao no downstream.

## Fase 3: Build

Objetivo: transformar o `spec.md` aprovado em implementacao entregue, de forma
**autonoma**. O humano aciona `@build-lead` uma vez; nao ha gate humano ate
`DELIVERED` ou ate o disjuntor escalar.

Operacao do `@build-lead`:

1. Ler o spec; montar o grafo de features e escolher o modo: **DIRETO** (pequeno/
   acoplado, o lider implementa) ou **PARALELO** (UI e servidor independentes).
2. Derivar o contrato da secao `Contrato de Integracao` do spec (nao inventar). Se
   faltar para feature que cruza fronteira → escalar `lacuna-spec`.
3. Implementar direto, ou spawnar `build-frontend ‖ build-backend` contra o
   contrato verbatim, e integrar.
4. Rodar `build`/`lint`/`test` e escrever `run-manifest.md` (neutro: como rodar).
5. Spawnar `down-qa` (allowlist `{spec.md, run-manifest.md}`) e tratar o veredito:
   - `PASS` (cobertura total) → `DELIVERED` no `build-report.md`. Fim.
   - `PARTIAL`/`FAIL` → corrigir a causa raiz pelos findings `DQ-NN` e re-rodar.
6. Registrar cada iteracao no `build-report.md`.

Disjuntor (na primeira condicao → `ESCALATED` com gatilho):

- `teto-de-iteracoes`: 3 ciclos build↔down-qa sem `PASS`.
- `BLOCKED`: o down-qa retornou `BLOCKED` (`env-blocked`).
- `sem-progresso`: o mesmo `DQ-NN` persiste apos uma tentativa de fix.
- `lacuna-spec`: finding `missing-spec-field` ou o contrato exige definicao ausente.

O `build-lead` e o unico que corrige codigo e escreve o `build-report.md` (auditoria,
nao visto pelo down-qa). Isolamento creator/verifier preservado.

## Fase 4: Down-QA

Objetivo: validar a implementacao contra o `spec.md` usando fluxo real e
evidencia observavel. Para web, o caminho preferencial e navegador real com
Playwright, browser CLI ou ferramenta equivalente. Roda como spawn do `build-lead`
no loop autonomo, ou standalone por invocacao humana.

Operacao:

1. Ler `sdd-docs/<slug>/YYYY-MM-DD-spec.md` (esperado) e
   `sdd-docs/<slug>/YYYY-MM-DD-run-manifest.md` (execucao). Nunca o `build-report.md`.
2. Extrair **todos** os criterios de aceite de **todas** as features.
3. Localizar/subir o app pelo run-manifest, sem alteracoes permanentes.
4. Rodar o Browser Capability Check (subsecao abaixo).
5. Navegar como usuario real e comparar cada criterio contra o observado.
6. Escrever `sdd-docs/<slug>/YYYY-MM-DD-down-qa-report.md` com tabela de cobertura e
   findings `DQ-NN`.

Regras:

- Read-only por padrao; nao corrigir codigo durante o down-qa.
- `PASS` so com cobertura total (todo criterio testado ou `N/A` ancorado).
- Nao marcar PASS para fluxo web sem exercitar browser.
- Se Playwright/browser nao estiver pronto, tentar bootstrap ou fallback antes
  de declarar bloqueio.
- Registrar `Browser Harness: READY | DEGRADED | BLOCKED`.
- `BLOCKED` (`env-blocked`) e aceitavel quando faltam auth, dados, permissao, rede ou browser.

### Browser Capability Check

Antes de testar fluxo web, o down-qa diagnostica o harness:

1. Procurar setup existente do projeto: `package.json`, scripts, Playwright,
   framework de teste ou docs locais.
2. Verificar runtime: `node --version`, `npm --version`, `command -v npx`.
3. Tentar Playwright do projeto ou runtime bundled quando existir.
4. Se browsers do Playwright faltarem, rodar ou solicitar permissao para
   `npx playwright install` quando apropriado.
5. Se download nao for possivel, tentar Chrome/Edge do sistema por canal.
6. Se GUI for bloqueada, tentar headless; se headed for essencial, pedir permissao.
7. Se nada funcionar, emitir `Browser Harness: BLOCKED` com comando e erro.

Nunca marcar teste de browser como concluido se o browser nao foi de fato exercitado.

### Browser Harness

- `READY`: automacao de browser funcionou normalmente.
- `DEGRADED`: teste executado com fallback (ex.: Chrome do sistema em vez de
  Chromium bundled).
- `BLOCKED`: nao foi possivel lancar, navegar ou interagir; incluir o erro.

## Artefatos

- Diretorio de cada POC: `sdd-docs/<slug>/` com `YYYY-MM-DD-proposal.md`, `YYYY-MM-DD-spec.md`, `YYYY-MM-DD-qa-verdict.md`, `YYYY-MM-DD-run-manifest.md`, `YYYY-MM-DD-build-report.md`.
- Down-QA report: `sdd-docs/<slug>/YYYY-MM-DD-down-qa-report.md`.
- Templates: `sdd-templates/proposal.md`, `sdd-templates/spec.md`, `sdd-templates/run-manifest.md`, `sdd-templates/build-report.md`, `sdd-templates/down-qa-report.md`.
- Agentes de menu: `.claude/agents/up-discovery.md`, `.claude/agents/up-spec.md`, `.claude/agents/build-lead.md`.
- Alvos internos de spawn: `.claude/agents/up-architect.md`, `.claude/agents/up-qa.md`, `.claude/agents/build-frontend.md`, `.claude/agents/build-backend.md`.
- QA pos-implementacao: `.claude/agents/down-qa.md` e skill Codex `.codex/skills/down-qa/SKILL.md`.
- Skills Codex equivalentes para cada agente em `.codex/skills/<nome>/SKILL.md`.

## Dry-Run De Validacao

1. Invocar `@up-discovery` com uma ideia pequena e definir o `<slug>`.
2. Confirmar que ele conversa primeiro e so escreve `sdd-docs/<slug>/YYYY-MM-DD-proposal.md` quando o usuario pedir.
3. Invocar `@up-spec`.
4. Confirmar que ele pergunta ao usuario em gaps de escopo/intencao, nao spawna sem necessidade, roda `up-qa` e gera `sdd-docs/<slug>/YYYY-MM-DD-spec.md` com features numeradas.
5. Confirmar que `up-qa` escreveu `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md`, que o veredito esta copiado verbatim no spec e que `FAIL` bloqueia a finalizacao.
6. Confirmar que, se uma feature cruza fronteira FE/BE sem `Contrato de Integracao`, o `up-qa` retorna `FAIL`.
7. Invocar `@build-lead` com o spec aprovado.
8. Confirmar que ele escolhe o modo (DIRETO/PARALELO), deriva o contrato, escreve `run-manifest.md` e spawna `down-qa` so com `{spec.md, run-manifest.md}`.
9. Confirmar que `PASS` exige cobertura total e gera `build-report.md` com status `DELIVERED`; e que `teto=3`/`BLOCKED`/`sem-progresso`/`lacuna-spec` geram `ESCALATED` com o gatilho.
