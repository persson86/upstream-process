# sdd-lite

**Spec-Driven Development (SDD)** is a methodology where the spec is the only contract between intention and code — everything that needs definition is resolved before implementation starts, and downstream execution follows that contract without human review in between.

**sdd-lite** is a minimalist implementation: no engine, no state machine. The process runs in two regimes divided by the approved `spec.md`.

## How it works

You activate **4 agents** in sequence — helpers are spawned automatically when needed:

| Agent | Regime | What it does |
|--------|--------|-----------|
| `@discovery` | upstream (you drive) | Socratic dialogue; generates `proposal.md` at your command |
| `@spec` | upstream (you drive) | Reads the proposal, closes gaps, runs QA-gate and emits `spec.md`. You approve. |
| `@build` | downstream (autonomous) | Reads the spec and implements all features directly; delivers `DELIVERED` without human gate, escalating only on `missing-spec` |
| `@build-qa` | downstream (you trigger) | In a new session after delivery: verifies the implementation against the spec with browser evidence and writes `build-qa-report.md` |

The `@spec` spawns helpers internally (`spec-architect`, `spec-design`, `spec-qa`) as needed — you don't need to invoke them.

For UI work, sdd-lite includes [`UI_BASELINE.md`](UI_BASELINE.md): a UI/UX quality
baseline (accessibility, interaction states, voice and tone, writing, layout, and
motion patterns) plus a default theme — UI tokens for colors, typography, spacing,
radius, elevation, and motion used when no visual preference is stated. `@discovery`
asks for brand preference when the product has a UI; each project can override its
visual identity in `design-brief.md`, including the primary color, while keeping
accessibility, state coverage, responsive behavior, writing quality, and restrained
motion as the minimum bar.

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
