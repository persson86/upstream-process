---
name: "spec"
description: "Spec phase: owns spec.md, reads proposal.md, asks scope questions, runs spec-architect and spec-qa as companion skills, and enforces the QA-gate."
---

# Spec

Voce conduz a fase Spec do sdd-lite e possui o artefato `spec.md`. Sua
funcao e transformar `proposal.md` em um spec implementavel, testavel e
fatiavel.

## Diretorio De Trabalho

A POC mora em `sdd-docs/<slug>/`. Voce le `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`
e escreve `sdd-docs/<slug>/YYYY-MM-DD-spec.md` (usando a data atual). Se o
`<slug>` nao estiver claro, pergunte ao usuario.

## Entradas

- Obrigatoria: `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`.
- Opcional: contexto de repositorio quando a proposta exigir viabilidade tecnica
  concreta.

Se o proposal nao existir ou estiver incompleto demais para gerar criterios de
aceite, pare e diga exatamente o que falta.

## Loop De Trabalho

1. Leia `sdd-docs/<slug>/proposal.md`.
2. Rode um gap scan: intencao, prioridade, escopo, viabilidade tecnica, riscos,
   testabilidade e sequenciamento.
3. Para cada gap, escolha um movimento:
   - perguntar ao usuario quando o gap for de intencao, prioridade ou escopo;
   - invocar a skill `spec-architect` quando a viabilidade tecnica exigir ler
     codigo, stack ou restricoes concretas;
   - assumir e sinalizar quando a assuncao for pequena, reversivel e nao
     bloquear o spec.
4. Rascunhe `sdd-docs/<slug>/YYYY-MM-DD-spec.md` usando `sdd-templates/spec.md`.
5. Invoque a skill `spec-qa`, passando o `<slug>` e somente os artefatos
   (`YYYY-MM-DD-proposal.md` + draft de `YYYY-MM-DD-spec.md`). O `spec-qa`
   escreve o veredito em `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md`.
6. Leia `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md` e cole o veredito verbatim na
   secao `QA-Gate` do spec.
7. Finalize somente se o gate permitir.

## QA-Gate

A fonte de verdade e `sdd-docs/<slug>/qa-verdict.md`, escrito pelo `spec-qa` — voce
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
- Nao chamar skills alem de `spec-architect` e `spec-qa`.
- Nao editar `proposal.md` nem `qa-verdict.md`.
