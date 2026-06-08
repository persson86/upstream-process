# Down-QA Report: <titulo curto>

## Origem

- Spec: `sdd-docs/<slug>/YYYY-MM-DD-spec.md`
- Data:
- Executor:
- Escopo testado:

## Verdict

Verdict: PASS | PARTIAL | FAIL | BLOCKED

Browser Harness: READY | DEGRADED | BLOCKED

> `PASS` so e valido quando **todo** criterio de aceite de **toda** feature
> numerada foi testado com evidencia, ou marcado `N/A` com ancora no spec.
> Cobertura parcial, dado ausente ou criterio nao testado => `PARTIAL` ou
> `BLOCKED`, nunca `PASS`.

## Test Setup

> Origem dos dados: `run-manifest.md` (unico input de build permitido). O
> *esperado* vem do `spec.md`.

- App command:
- Initial URL:
- Browser/runtime:
- Test data:
- Credentials:

## Spec Coverage

> Uma linha por criterio de aceite de cada feature. Sem linhas faltando.

| Feature | Criterio | Status | Evidencia |
| --- | --- | --- | --- |
| F1 | <criterio de aceite> | PASS \| FAIL \| BLOCKED \| N/A | <URL, acao, screenshot, snapshot ou log; para N/A, ancora no spec> |

## Browser Run

1. <acao executada>
2. <acao executada>
3. <observacao relevante>

## Findings

> Cada finding tem **ID estavel** (`DQ-NN`), a feature/criterio afetado e uma
> **categoria**. O `build-lead` usa o ID para detectar "sem-progresso" (mesmo ID
> persiste apos um fix) e a categoria para acionar o disjuntor.
> Categorias: `bug` | `missing-coverage` | `missing-spec-field` | `env-blocked`.

| ID | Feature/Criterio | Categoria | Severidade | Achado (ancorado na spec + evidencia) |
| --- | --- | --- | --- | --- |
| DQ-01 | F1 / <criterio> | bug \| missing-coverage \| missing-spec-field \| env-blocked | high \| medium \| low | <achado objetivo> |

## Required Changes

- <mudanca necessaria antes de considerar a feature conforme, ou "None">

## Blockers

- <credencial, dado, ambiente, permissao ou browser ausente, ou "None">

## Artifacts

- Screenshots:
- Snapshots:
- Logs:
