# sdd-lite

**Spec-Driven Development (SDD)** e uma metodologia onde o spec e o unico contrato entre intenção e codigo — tudo que precisa de definicao e resolvido antes da implementacao comecar, e o downstream executa contra esse contrato sem revisao humana no meio.

**sdd-lite** e uma implementacao minimalista: sem engine, sem state machine. O processo roda em dois regimes divididos pelo `spec.md` aprovado.

## Como funciona

Voce aciona **3 agentes** — o restante do fluxo e automatico:

| Agente | Regime | O que faz |
|--------|--------|-----------|
| `@discovery` | upstream (voce conduz) | Dialogo socratico; gera `proposal.md` ao seu comando |
| `@spec` | upstream (voce conduz) | Le o proposal, fecha gaps, roda QA-gate e emite `spec.md`. Voce aprova. |
| `@build` | downstream (autonomo) | Le o spec, constroi, valida via `build-qa` em loop e entrega `DELIVERED` sem gate humano |

O `@build` spawna helpers internamente (`build-frontend`, `build-backend`, `build-qa`) conforme necessario — voce nao precisa acioná-los.

Detalhes do processo: [`PROCESS.md`](PROCESS.md).

## Instalacao

De dentro da pasta do projeto-alvo:

```bash
curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/main/install.sh | bash
```

## Atualizacao

```bash
curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/main/install.sh | bash -s -- . --update
```
