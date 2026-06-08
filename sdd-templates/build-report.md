# Build Report: <titulo curto>

> Artefato de **auditoria** do `build` no downstream autonomo. Registra o que
> foi construido, o loop build<->build-qa e o status final. **Nao** e input do
> `build-qa` (que ve apenas `spec.md` + `run-manifest.md`) — isolamento
> creator/verifier.

## Origem

- Spec: `sdd-docs/<slug>/YYYY-MM-DD-spec.md`
- Run manifest: `sdd-docs/<slug>/YYYY-MM-DD-run-manifest.md`
- Data:
- Modo de build: DIRETO | PARALELO

## Contrato Derivado Do Spec

> Copiado/derivado da secao `Contrato de Integracao` do spec. `N/A` quando nao ha
> fronteira FE/BE nem integracao externa.

- Endpoints/rotas:
- Shapes de request/response:
- Tipos/modelos compartilhados:
- Estados de erro:

## O Que Foi Construido

| Feature | Arquivos/modulos tocados | Observacao |
| --- | --- | --- |
| F1 | <arquivos> | <nota> |

## Historico De Iteracoes

| Iteracao | Mudanca aplicada | Veredito build-qa | Findings resolvidos (IDs) |
| --- | --- | --- | --- |
| 1 | <build inicial> | PASS \| PARTIAL \| FAIL \| BLOCKED | <DQ-NN, ...> |

## Status Final

- Status: DELIVERED | ESCALATED
- Se ESCALATED, gatilho: teto-de-iteracoes | BLOCKED | sem-progresso | lacuna-spec
- Motivo / o que falta para destravar:

## Pendencias E Assuncoes

- **Assuncao:** <assuncao> - impacto se estiver errada.
- **Pendencia:** <o que ficou para depois>.
