---
name: "up-spec"
description: "Spec phase: owns spec.md, reads proposal.md, asks scope questions, runs up-architect and up-qa as companion skills, and enforces the QA-gate."
---

# Up-Spec

Voce conduz a fase Spec do upstream-process e possui o artefato `spec.md`. Sua
funcao e transformar `proposal.md` em um spec implementavel, testavel e
fatiavel.

## Diretorio De Trabalho

A POC mora em `up-docs/<slug>/`. Voce le `up-docs/<slug>/YYYY-MM-DD-proposal.md`
e escreve `up-docs/<slug>/YYYY-MM-DD-spec.md` (usando a data atual). Se o
`<slug>` nao estiver claro, pergunte ao usuario.

## Entradas

- Obrigatoria: `up-docs/<slug>/YYYY-MM-DD-proposal.md`.
- Opcional: contexto de repositorio quando a proposta exigir viabilidade tecnica
  concreta.

Se o proposal nao existir ou estiver incompleto demais para gerar criterios de
aceite, pare e diga exatamente o que falta.

## Loop De Trabalho

1. Leia `up-docs/<slug>/proposal.md`.
2. Rode um gap scan: intencao, prioridade, escopo, viabilidade tecnica, riscos,
   testabilidade e sequenciamento.
3. Para cada gap, escolha um movimento:
   - perguntar ao usuario quando o gap for de intencao, prioridade ou escopo;
   - invocar a skill `up-architect` quando a viabilidade tecnica exigir ler
     codigo, stack ou restricoes concretas;
   - assumir e sinalizar quando a assuncao for pequena, reversivel e nao
     bloquear o spec.
4. Rascunhe `up-docs/<slug>/YYYY-MM-DD-spec.md` usando `templates/spec.md`.
5. Invoque a skill `up-qa`, passando o `<slug>` e somente os artefatos
   (`YYYY-MM-DD-proposal.md` + draft de `YYYY-MM-DD-spec.md`). O `up-qa`
   escreve o veredito em `up-docs/<slug>/YYYY-MM-DD-qa-verdict.md`.
6. Leia `up-docs/<slug>/YYYY-MM-DD-qa-verdict.md` e cole o veredito verbatim na
   secao `QA-Gate` do spec.
7. Finalize somente se o gate permitir.

## QA-Gate

A fonte de verdade e `up-docs/<slug>/qa-verdict.md`, escrito pelo `up-qa` — voce
nao o produz nem o reescreve. Copie-o sem edicao para a secao `QA-Gate` do
`spec.md`.

- `PASS`: pode finalizar.
- `CONCERNS`: resolva os achados ou obtenha waiver explicito do usuario.
- `FAIL`: bloqueia. Revise o draft e rode novo QA-gate.

## Formato Do Spec

- Job To Be Done.
- User stories.
- Features numeradas e ordenadas.
- Criterios de aceite testaveis por feature.
- Notas de arquitetura quando houver.
- Assuncoes e perguntas abertas.
- QA-gate com veredito verbatim e resolucoes/waivers.

## Fora De Escopo

- Nao implementar features.
- Nao chamar skills alem de `up-architect` e `up-qa`.
- Nao editar `proposal.md` nem `qa-verdict.md`.
