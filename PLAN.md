# Plano de Viabilidade & Valor — Framework SDD-lite (**upstream-process**)

> Status: documentação implementada (`PROCESS.md`, 2 templates e 4 subagentes criados). Revisado por Codex (6 achados aplicados).

## Context

O usuário valida MVPs/POCs/POVs por um fluxo mental fixo (Insight → Contextualização → Proposta → PRDs/Spec → Implementação → Testes). Gosta de **Spec Driven Development** e da proposta do **AIOX**, mas quer algo **mais leve, simples, orientado ao formato dele**.

Diagnóstico da exploração: o AIOX já está instalado em `Ops/projetos/.aiox-core` e já implementa essas cadeias — mas com ~30 subsistemas (synapse, orchestration engine, workflow-intelligence, registries, handoff protocol). Para POC, é peso morto. O problema não é conceito, é excesso de máquina.

**Decisão de arquitetura (do usuário, adotada aqui):**
- Projeto **conceitualmente independente** de AIOX/Ops/second-brain (vive fisicamente em `Ops/projetos/upstream-process`, sem acoplamento).
- **80% offline/subjetivo, conduzido pelo usuário** — ele diz em que fase está e quando avança. Sem engine, sem auto-handoff, sem state machine.
- **20% = agentes chamáveis sob demanda** — cada um função pura sobre o artefato da fase.

**Escopo deste plano:** apenas **2 fases**, com **2 agentes de menu** (`@up-discovery`, `@up-spec`) + 2 alvos de spawn internos (`architect`, `qa`). A implementação (`@dev`) fica fora — o spec é a fronteira de entrega aqui.
1. **Discovery** (Insight+Contexto+Proposta fundidos) — agente socrático que interroga até convergir; gera `proposal.md` **sob comando explícito**.
2. **Spec** — agente-líder único `@up-spec` que **possui o artefato**: lê o `proposal.md` e tem liberdade para perguntar ao usuário, spawnar `architect` ou `qa` (isolados) e rodar um QA-gate, antes de emitir `spec.md` (1+) em JTBD/User Story/Features.

**Outcome:** transformar uma ideia crua em um `spec.md` testável e fatiável, com o humano conduzindo e invocando lentes só quando quer. (A fase de implementação será desenhada depois, a partir do spec.)

---

## Validação do racional

| Ponto | Veredito |
|---|---|
| Fundir Insight+Contexto+Proposta num agente socrático | ✅ Forte. As três são o mesmo modo cognitivo (sense-making). Separá-las em artefatos era artificial. |
| Discovery interroga até convergir, gera arquivo só sob comando | ✅ Expressão mais pura do "80% você conduzindo". O gate é seu comando explícito. |
| Spec como **agente-líder único** que possui o artefato | ✅ Melhor que pipeline de 2 agentes: você invoca uma coisa, ela decide o que precisa (perguntar / spawnar / escrever). |
| `@up-spec` com liberdade de spawnar | ⚠️ É o ponto de inchaço — contido por fronteira concreta: alvos fechados (`architect`\|`qa`), spawna só para viabilidade-que-lê-código ou QA isolado; resto = inline ou perguntar. |
| QA isolado dentro de uma invocação | ✅ `qa` recebe **só os artefatos** (proposal+spec draft), não a deliberação. Veredito gravado verbatim no `spec.md`; **FAIL bloqueia**, CONCERNS exige waiver seu — o autor não pode suavizar. |
| Spec produz itens numerados/ordenados | ✅ Mesmo sem `@dev` no escopo, o template força numeração — deixa o spec já fatiável para a implementação futura. |
| Drop de PM/PO/SM/Dev | ✅ PM/PO/SM absorvidos; `@dev` adiado (fora deste escopo). |

---

## Desenho do framework — 2 fases, 2 agentes de menu, 2 artefatos

| Fase | Agente | Modo de operação | Output | Gate (humano) |
|---|---|---|---|---|
| **1. Discovery** | `@up-discovery` (socrático) | Diálogo por padrão: 1 pergunta focada por vez, reflete entendimento de volta, nomeia o que está nebuloso, desafia raciocínio fraco. Pode sinalizar "temos contexto suficiente?" mas **só escreve `proposal.md` sob comando explícito**. | `proposal.md` | Você decide que entendeu o suficiente |
| **2. Spec** | `@up-spec` (líder; possui o artefato) | Loop: lê `proposal.md` → *gap scan* → para cada gap escolhe **perguntar a você** (intenção/prioridade/escopo), **spawnar `architect` ou `qa`** (isolados, em paralelo se independentes) ou **assumir e sinalizar** → rascunha spec → **passe de QA isolado (gate)** → revisa. | `spec.md` (1+) | Spec aprovado; QA-gate ≠ FAIL |

### Contrato de operação do `@up-spec` (o coração)
- **Três movimentos por gap:** perguntar ao usuário · spawnar helper isolado · assumir+sinalizar. Decide qual conforme a natureza do gap.
- **Alvos de spawn fechados:** `@up-spec` só pode spawnar **`architect` ou `qa`** — mais nada. Sem lane de "pesquisa/recon" genérica.
- **Guardrail anti-inchaço (fronteira concreta):** só spawna quando precisa de **(i) viabilidade técnica que exige ler código/stack** (→ `architect`) ou **(ii) o veredito de QA isolado** (→ `qa`). Todo o resto = resolver inline ou **perguntar a você**. Helpers independentes em paralelo; depth cap respeitado.
- **QA realmente isolado:** o `@up-spec` spawna o subagente `qa` passando **apenas** `proposal.md` + `spec.md` draft (não a deliberação) → veredito PASS/CONCERNS/FAIL + achados.
- **QA-gate que o autor não pode suavizar:** o veredito do `qa` é gravado **verbatim** numa seção fixa do `spec.md`. **`FAIL` bloqueia a finalização.** **`CONCERNS` exige resolução ou waiver explícito *seu*** (não do `@up-spec`) — registrado na mesma seção. O `@up-spec` não pode editar nem descartar o veredito; só responder a ele.

### Estrutura do `proposal.md` (template)
Problema/Oportunidade · Contexto · Evidência · Opções consideradas · **Proposta recomendada** · Riscos & Assunções abertas.

### Estrutura do `spec.md` (template)
Job To Be Done(s) · User Stories · **Features numeradas/ordenadas** (cada uma com critérios de aceite testáveis) · Notas de arquitetura · **QA-gate** (veredito verbatim do `qa` + waivers explícitos do usuário).

---

## O "20%" — o que concretamente é um agente aqui

- **Agente = subagente Claude Code** (`.claude/agents/<nome>.md`). Você invoca 2 (`@up-discovery`, `@up-spec`); `architect` e `qa` são **alvos de spawn internos** do `@up-spec`, não menu.
- **`@up-spec` é o único orquestrador** — possui `spec.md` e delega lentes sob demanda. `@up-discovery` é função pura (diálogo → artefato).
- **QA isolado** = subagente `qa` recebendo só os artefatos, não a deliberação. Autocontido.
- **Zero dependência externa:** nada de AIOX (`.aiox-core`/personas) nem `/council`. O que for útil de fora, **copia-se para dentro** do projeto. `/council` permanece disponível para uso manual do usuário, mas **fora** deste framework.
- **A espinha (80%) = `PROCESS.md`** descrevendo as 2 fases/artefatos/gates + 2 templates (`proposal.md` ~1 página; `spec.md` enxuto, sem teto rígido — densidade exigida pelo conteúdo).

---

## Viabilidade (esforço × reuso)

**Esforço: baixo.** Sem engine.
- 1× `PROCESS.md`.
- 2× templates: `proposal.md` (~1 página), `spec.md` (enxuto, sem teto rígido).
- 4× arquivos de persona slim: 2 de menu (`discovery`, `spec`) + 2 alvos de spawn (`architect`, `qa`), mandatos não-sobrepostos.

**Autocontido — zero dependência externa:** nada de AIOX nem `/council`. Padrão de isolamento creator-verifier implementado no próprio `@up-spec`↔`qa`. Se algo do AIOX for útil, **copia-se para dentro** do projeto (sem link).

**Riscos & mitigação:**
- *Discovery gerar arquivo cedo demais* → regra dura: só escreve sob comando explícito.
- *`@up-spec` spawnar demais e inchar* → alvos fechados (`architect`\|`qa`) + fronteira concreta (viabilidade-que-lê-código ou QA); resto inline+perguntar.
- *QA virar eco do autor* → `qa` recebe só artefatos; veredito verbatim, FAIL bloqueia, CONCERNS exige waiver do usuário — autor não suaviza.
- *Spec sem itens ordenados quebra o fatiamento futuro* → template força numeração.
- *`proposal.md` inchar* → cap de ~1 página; `spec.md` fica enxuto por disciplina, não por teto.

---

## Valor

- **vs. AIOX:** mesma cadeia conceitual, sem imposto de orquestração; você no controle.
- **vs. ad-hoc:** `proposal.md` e `spec.md` viram ativos reutilizáveis que sobrevivem ao POC.
- **Discovery socrático** transforma ideia crua em estrutura sem você ter que já saber a resposta.
- **Independência/limpeza:** namespace próprio, zero herança de peso.

---

## Estrutura implementada

```
Ops/projetos/upstream-process/
├── CLAUDE.md                   # reset de escopo: ignora regras AIOX do diretório-pai
├── PLAN.md                     # este documento
├── PROCESS.md                  # espinha: 2 fases, artefatos, gates
├── README.md                   # o que é + instalação em outros projetos
├── install.sh                  # instala o framework num projeto-alvo
├── templates/
│   ├── proposal.md
│   └── spec.md
├── up-docs/                    # cada POC mora em up-docs/<slug>/ (proposal.md, spec.md, qa-verdict.md)
└── .claude/agents/
    ├── up-discovery.md         # [menu] socrático → up-docs/<slug>/proposal.md (sob comando)
    ├── up-spec.md              # [menu] líder: lê proposal, pergunta/spawna/valida → spec.md
    ├── up-architect.md         # [spawn] lente de viabilidade técnica p/ @up-spec
    └── up-qa.md                # [spawn] validador isolado; grava o próprio veredito em qa-verdict.md
```
*(`@dev`/implementação fora deste escopo — desenhada depois, a partir do `spec.md`.)*

**Decisões de design pós-revisão (Opus s/ implementação do Codex):**
- **Namespacing `up-*`** + `CLAUDE.md` de reset → mata colisão de nomes e o vazamento das regras AIOX do diretório-pai.
- **`up-qa` grava o próprio `qa-verdict.md`** (não o `@up-spec`) → o veredito existe independente do autor; fecha o furo de o réu transcrever a própria sentença.
- **Convenção `up-docs/<slug>/`** → isola POCs e elimina a colisão dos três `spec.md`.
- **Vocabulário do gate alinhado** (resolver é padrão, waiver é exceção).

---

## Verificação (como saberemos que funciona)

**Dry-run end-to-end** numa POC real pequena (em `up-docs/<slug>/`):
1. `@up-discovery` conduz o diálogo socrático; define o `<slug>`; ao seu comando, gera `up-docs/<slug>/proposal.md`.
2. `@up-spec` lê o proposal, te faz ao menos uma pergunta de escopo, roda o `up-qa` (que grava `qa-verdict.md`) e emite `up-docs/<slug>/spec.md` com itens numerados. (Spawn de `up-architect` é **opcional** — só se houver viabilidade técnica que exija ler código.)

**Critério de sucesso:** uma ideia crua atravessou as 2 fases; o `proposal.md` saiu apenas quando você pediu; o `@up-spec` perguntou em vez de assumir nos gaps de intenção e **não** spawnou sem necessidade; o `up-qa` gravou `qa-verdict.md` independente, copiado verbatim no spec, e `FAIL` bloqueou; o `spec.md` saiu com itens numerados/fatiáveis — tudo sem engine de orquestração.
