# Spec: bookmarks-cli

## Origem

- Proposal: `proposal.md`
- Data: 2026-06-07
- Autor do spec: up-spec (dry-run)

## Job To Be Done

Quando salvo um link util no terminal, quero guarda-lo com tags e reencontra-lo por tag ou texto, para parar de perder referencias.

## User Stories

1. Como usuario de terminal, quero salvar um link com tags, para recupera-lo depois sem depender do browser.
2. Como usuario de terminal, quero buscar links por tag ou substring, para reencontrar em segundos.

## Features Numeradas

### F1. Adicionar link (`bm add <url> [--tag t1 --tag t2]`)

**Objetivo:** persistir um link com tags opcionais no store local.

**Escopo:**

- Inclui: validar que `<url>` nao e vazio; gravar url + tags + timestamp.
- Nao inclui: validar se a URL responde na rede.

**Criterios de aceite:**

- Dado um store vazio, quando rodo `bm add https://x.com --tag dev`, entao o store passa a conter 1 entrada com url `https://x.com` e tag `dev`.
- Dado `bm add` sem url, quando executo, entao retorna erro nao-zero e nada e gravado.

**Dependencias/ordem:** primeira; cria o store que as demais leem.

### F2. Listar links (`bm list`)

**Objetivo:** mostrar todas as entradas salvas.

**Escopo:**

- Inclui: imprimir url + tags de cada entrada.
- Nao inclui: paginacao.

**Criterios de aceite:**

- Dado um store com 2 entradas, quando rodo `bm list`, entao a saida contem as 2 urls.
- Dado um store vazio, quando rodo `bm list`, entao a saida e vazia e o codigo de saida e zero.

**Dependencias/ordem:** depois de F1.

### F3. Buscar links (`bm find <termo>`)

**Objetivo:** filtrar entradas por tag exata ou substring no titulo/URL.

**Escopo:**

- Inclui: busca por tag exata e por substring (case-insensitive) em titulo/URL.
- Nao inclui: regex.

**Criterios de aceite:**

- Dado um store com a entrada `https://x.com` tag `dev`, quando rodo `bm find dev`, entao a saida contem `https://x.com` (match por tag exata).
- Dado um store com `https://example.com/post`, quando rodo `bm find exampl`, entao a saida contem essa url (match por substring na URL).
- Dado um store com `https://x.com` tag `dev`, quando rodo `bm find xyz`, entao a saida e vazia e o codigo de saida e zero.

**Dependencias/ordem:** depois de F1.

## Notas De Arquitetura

Store local em arquivo JSON unico (`~/.bm.json`). Sem rede, sem backend. Volume pessoal (assuncao do proposal: ok ate ~10k entradas).

## Assuncoes E Perguntas Abertas

- **Assuncao:** JSON unico aguenta o volume pessoal. - impacto se errada: migrar pra SQLite.

## QA-Gate

Fonte de verdade: `runs/<slug>/qa-verdict.md`, escrito pelo up-qa.

### Veredito Verbatim Do `up-qa`

```text
Verdict: PASS

Findings:
- [severity: low] Notas de arquitetura assumem JSON unico ate ~10k entradas; coerente com a assuncao do proposal e ja registrado como assuncao aberta. Sem bloqueio.

Required Changes:
- None

Waiver Eligible:
- None
```

### Resolucao

- Achados resolvidos: F3 reescrita com 3 criterios observaveis cobrindo tag exata, substring e no-match; F2 ganhou criterio de store vazio.
- Waivers explicitos do usuario: nenhum (caminho de resolucao, sem waiver).
- Status final do gate: PASS
