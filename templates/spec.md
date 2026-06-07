# Spec: <titulo curto>

## Origem

- Proposal: `proposal.md`
- Data:
- Autor do spec:

## Job To Be Done

Quando <situacao>, quero <motivacao/necessidade>, para <resultado mensuravel ou observavel>.

## User Stories

1. Como <persona>, quero <capacidade>, para <resultado>.
2. Como <persona>, quero <capacidade>, para <resultado>.

## Features Numeradas

### F1. <nome da feature>

**Objetivo:** <resultado que esta feature entrega>

**Escopo:**

- Inclui:
- Nao inclui:

**Criterios de aceite:**

- Dado <contexto>, quando <acao>, entao <resultado observavel>.
- Dado <contexto>, quando <acao>, entao <resultado observavel>.

**Dependencias/ordem:** <por que esta feature vem nesta posicao>

### F2. <nome da feature>

**Objetivo:** <resultado que esta feature entrega>

**Escopo:**

- Inclui:
- Nao inclui:

**Criterios de aceite:**

- Dado <contexto>, quando <acao>, entao <resultado observavel>.

**Dependencias/ordem:** <por que esta feature vem nesta posicao>

## Notas De Arquitetura

Registre restricoes tecnicas, decisoes relevantes, integracoes, dados, riscos de implementacao e achados do `architect` quando ele for chamado.

## Assuncoes E Perguntas Abertas

- **Assuncao:** <assuncao> - impacto se estiver errada.
- **Pergunta:** <pergunta> - dono ou momento de resposta.

## QA-Gate

Fonte de verdade: `up-docs/<slug>/qa-verdict.md`, escrito pelo `up-qa`. O bloco abaixo e copia verbatim; em caso de divergencia, o arquivo prevalece.

### Veredito Verbatim Do `up-qa`

```text
<colar aqui o conteudo de qa-verdict.md, sem editar>
```

### Resolucao

Caminho padrao = **resolver** os achados (re-rodar o `up-qa` ate `PASS`). Waiver e excecao e exige pedido explicito do usuario.

- Achados resolvidos (com referencia a feature):
- Waivers explicitos do usuario (so com pedido do usuario):
- Status final do gate: PASS | CONCERNS (RESOLVIDO) | CONCERNS (COM WAIVER) | FAIL (BLOQUEADO)
