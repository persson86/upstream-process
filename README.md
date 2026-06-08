# sdd-lite

**Spec-Driven Development (SDD)** is a methodology where the spec is the only contract between intention and code — everything that needs definition is resolved before implementation starts, and downstream execution follows that contract without human review in between.

**sdd-lite** is a minimalist implementation: no engine, no state machine. The process runs in two regimes divided by the approved `spec.md`.

## How it works

You activate **3 agents** — the rest of the flow is automatic:

| Agent | Regime | What it does |
|--------|--------|-----------|
| `@discovery` | upstream (you drive) | Socratic dialogue; generates `proposal.md` at your command |
| `@spec` | upstream (you drive) | Reads the proposal, closes gaps, runs QA-gate and emits `spec.md`. You approve. |
| `@build` | downstream (autonomous) | Reads the spec, builds, validates via `build-qa` in loop and delivers `DELIVERED` without human gate |

The `@build` spawns helpers internally (`build-frontend`, `build-backend`, `build-qa`) as needed — you don't need to invoke them.

Process details: [`PROCESS.md`](PROCESS.md).

## Installation

From inside the target project folder:

```bash
curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/main/install.sh | bash
```

## Update

```bash
curl -fsSL https://raw.githubusercontent.com/persson86/sdd-lite/main/install.sh | bash -s -- . --update
```
