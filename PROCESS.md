# SDD-lite

SDD-lite framework for transforming a raw idea into a testable and sliceable `spec.md`, with the user driving decisions and agents acting only on demand.

## Principles

The workflow has **two regimes**, with the dividing line at `spec.md`:

- **Upstream (Discovery, Spec): human-led**, step by step. No auto-handoff;
  each phase advances by user decision.
- **Downstream (Build, Build-QA): autonomous** from the approved spec. The human
  triggers once; `build` constructs, validates via `build-qa` and delivers without
  human gate, escalating only via the circuit breaker. Auto-handoff build↔build-qa exists **only
  here**, and even then without engine/state machine (the loop runs on the leader's invocation).

Additional principles:

- Self-contained project: no inheritance from other frameworks; anything useful from outside is copied in.
- Each POC lives in `sdd-docs/<slug>/` and contains `YYYY-MM-DD-proposal.md`, `YYYY-MM-DD-spec.md`, `YYYY-MM-DD-qa-verdict.md`, `YYYY-MM-DD-run-manifest.md`, `YYYY-MM-DD-build-report.md`, and `YYYY-MM-DD-build-qa-report.md`.
- `discovery` writes the proposal only when the user explicitly asks.
- `spec` owns the `spec.md` artifact and decides, by gap, between asking the user, calling an isolated lens, or assuming and recording the assumption.
- Spawns are closed: `@spec` only calls `spec-architect`/`spec-qa`; `@build` only calls `build-frontend`, `build-backend`, or `build-qa`.
- **The `spec-qa` gate is load-bearing.** Because the downstream delivers without human review, the spec is the only guarantee: `spec-qa` returns `FAIL` if a feature crosses the FE/BE boundary and the `Integration Contract` is absent/ambiguous. QA is a gate, not optional advice; `spec-qa` writes `qa-verdict.md` (source of truth) and `@spec` copies it verbatim, without editing.
- **Creator/verifier isolation in downstream:** `build` constructs and fixes; `build-qa` only reads `spec.md` + `run-manifest.md` (never `build-report.md`) and judges. PASS requires full coverage of criteria.

## Phases

| Phase | Regime | Agent | Input | Output | Human Gate |
| --- | --- | --- | --- | --- | --- |
| 1. Discovery | upstream | `@discovery` | Idea, context, and user answers | `sdd-docs/<slug>/YYYY-MM-DD-proposal.md` | User explicitly asks to generate |
| 2. Spec | upstream | `@spec` | `sdd-docs/<slug>/YYYY-MM-DD-proposal.md` | `sdd-docs/<slug>/YYYY-MM-DD-spec.md` | User approves spec and QA gate is not in `FAIL` |
| 3. Build | downstream | `@build` | `sdd-docs/<slug>/YYYY-MM-DD-spec.md` approved | `run-manifest.md` + `build-report.md` (`DELIVERED`/`ESCALATED`) | Trigger only; no gate until `DELIVERED` or circuit breaker escalates |
| 4. Build-QA | downstream | `@build-qa` (spawn from `build` or standalone) | `spec.md` + `run-manifest.md` | `sdd-docs/<slug>/YYYY-MM-DD-build-qa-report.md` | None in autonomous loop; standalone, user decides |

## Phase 1: Discovery

Objective: merge insight, context, and proposal in a short Socratic conversation strong enough to converge, yet rigorous enough to expose weak reasoning.

Operation:

1. Ask one focused question at a time.
2. Reflect understanding back when new relevant information emerges.
3. Explicitly name what remains unclear.
4. Challenge proposals lacking evidence, scope too broad, or success impossible to verify.
5. Signal when context is sufficient, but do not write the file without clear user command.

The `sdd-docs/<slug>/YYYY-MM-DD-proposal.md` should fit approximately on one page. It records problem/opportunity, context, evidence, options considered, recommended proposal, risks, and open assumptions.

## Phase 2: Spec

Objective: transform `sdd-docs/<slug>/proposal.md` into an implementable `sdd-docs/<slug>/spec.md`, with JTBD, user stories, numbered features, and testable acceptance criteria.

Operation of `@spec`:

1. Read `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`.
2. Perform a gap scan on intent, priority, scope, technical feasibility, risks, and testability.
3. For each gap, choose one action:
   - ask the user when the gap is intent, priority, or scope;
   - call `spec-architect` when technical feasibility requires reading code, stack, or implementation constraints;
   - assume and signal when the assumption is small, reversible, and does not block the spec.
4. Draft `sdd-docs/<slug>/YYYY-MM-DD-spec.md`.
5. Call `spec-qa` passing only `YYYY-MM-DD-proposal.md` and the `YYYY-MM-DD-spec.md` draft. `spec-qa` writes the verdict in `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md`.
6. Read `YYYY-MM-DD-qa-verdict.md` and copy the verdict verbatim into the fixed QA-gate section of the spec.
7. Finalize only if the gate permits.

## Spawn Rules

- `@spec` can spawn only `spec-architect` and `spec-qa`.
- `@build` can spawn only `build-frontend`, `build-backend`, and `build-qa`.
- `spec-architect` is optional and used only for technical feasibility depending on reading code, stack, or concrete constraints.
- `spec-qa` is mandatory before finalizing any `spec.md`.
- `build-qa` is mandatory in each downstream iteration; runs fresh with the allowlist `{spec.md, run-manifest.md}`.
- Independent helpers can run in parallel when the tool supports it (e.g., `build-frontend ‖ build-backend`).
- Helpers do not own the final artifact. They return findings/code; `@spec`/`@build` incorporates or responds to findings.

## QA-Gate

`spec-qa` receives only:

- `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`;
- current draft of `sdd-docs/<slug>/YYYY-MM-DD-spec.md`.

It does not receive `@spec`'s deliberation, internal history, or additional justifications. **`spec-qa` itself writes the verdict in `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md`** — this file exists independently of `@spec`, which cannot edit it.

Verdicts:

- `PASS`: the `spec.md` can be finalized.
- `CONCERNS`: default path is to resolve findings (re-run `spec-qa` until `PASS`); waiver is an exception and requires explicit user request, recorded in the `spec.md`.
- `FAIL`: blocks finalization. `@spec` must review the draft and run a new QA gate (`spec-qa` rewrites `qa-verdict.md`).

`@spec` cannot edit, summarize, or discard the verdict. It must copy it verbatim from `qa-verdict.md` into the `QA-Gate` section of `spec.md`. Beyond the verdicts above, `spec-qa` returns `FAIL` when a feature crosses the FE/BE boundary or external integration and the `Integration Contract` in the spec is absent, incomplete, or ambiguous (contract-completeness gate) — the gap is resolved in the Spec, not downstream.

## Phase 3: Build

Objective: transform the approved `spec.md` into delivered implementation,
**autonomously**. The human triggers `@build` once; no human gate until
`DELIVERED` or until the circuit breaker escalates.

Operation of `@build`:

1. Read the spec; build the feature graph and choose the mode: **DIRECT** (small/
   coupled, leader implements) or **PARALLEL** (UI and server independent).
2. Derive the contract from the `Integration Contract` section of the spec (do not invent). If
   missing for a feature crossing boundaries → escalate `spec-gap`.
3. Implement directly, or spawn `build-frontend ‖ build-backend` against the
   contract verbatim, and integrate.
4. Run `build`/`lint`/`test` and write `run-manifest.md` (neutral: how to run).
5. Spawn `build-qa` (allowlist `{spec.md, run-manifest.md}`) and handle the verdict:
   - `PASS` (full coverage) → `DELIVERED` in `build-report.md`. Done.
   - `PARTIAL`/`FAIL` → fix the root cause per findings `DQ-NN` and re-run.
6. Record each iteration in `build-report.md`.

Circuit breaker (on first condition → `ESCALATED` with trigger):

- `iteration-ceiling`: 3 build↔build-qa cycles without `PASS`.
- `BLOCKED`: build-qa returned `BLOCKED` (`env-blocked`).
- `no-progress`: the same `DQ-NN` persists after one fix attempt.
- `spec-gap`: finding `missing-spec-field` or contract requires undefined field.

`build` is the only entity that fixes code and writes `build-report.md` (audit,
not seen by build-qa). Creator/verifier isolation preserved.

## Phase 4: Build-QA

Objective: validate the implementation against `spec.md` using real flow and
observable evidence. For web, the preferred path is real browser with
Playwright, browser CLI, or equivalent tool. Runs as spawn of `build`
in the autonomous loop, or standalone by human invocation.

Operation:

1. Read `sdd-docs/<slug>/YYYY-MM-DD-spec.md` (expected) and
   `sdd-docs/<slug>/YYYY-MM-DD-run-manifest.md` (execution). Never `build-report.md`.
2. Extract **all** acceptance criteria from **all** features.
3. Locate/start the app per run-manifest, without permanent changes.
4. Run the Browser Capability Check (subsection below).
5. Navigate as a real user and compare each criterion against observed behavior.
6. Write `sdd-docs/<slug>/YYYY-MM-DD-build-qa-report.md` with coverage table and
   findings `DQ-NN`.

Rules:

- Read-only by default; do not fix code during build-qa.
- `PASS` only with full coverage (all criteria tested or `N/A` anchored).
- Do not mark PASS for web flow without exercising the browser.
- If Playwright/browser is not ready, try bootstrap or fallback before
  declaring blocked.
- Record `Browser Harness: READY | DEGRADED | BLOCKED`.
- `BLOCKED` (`env-blocked`) is acceptable when auth, data, permission, network, or browser is missing.

### Browser Capability Check

Before testing web flow, build-qa diagnoses the harness:

1. Look for existing project setup: `package.json`, scripts, Playwright,
   test framework, or local docs.
2. Check runtime: `node --version`, `npm --version`, `command -v npx`.
3. Try Playwright from the project or bundled runtime when available.
4. If Playwright browsers are missing, run or request permission for
   `npx playwright install` when appropriate.
5. If download is not possible, try Chrome/Edge from system via channel.
6. If GUI is blocked, try headless; if headed is essential, request permission.
7. If nothing works, emit `Browser Harness: BLOCKED` with command and error.

Never mark browser test as complete if the browser was not actually exercised.

### Browser Harness

- `READY`: browser automation worked normally.
- `DEGRADED`: test ran with fallback (e.g., system Chrome instead of
  bundled Chromium).
- `BLOCKED`: could not launch, navigate, or interact; include the error.

## Artifacts

- Directory for each POC: `sdd-docs/<slug>/` with `YYYY-MM-DD-proposal.md`, `YYYY-MM-DD-spec.md`, `YYYY-MM-DD-qa-verdict.md`, `YYYY-MM-DD-run-manifest.md`, `YYYY-MM-DD-build-report.md`.
- Build-QA report: `sdd-docs/<slug>/YYYY-MM-DD-build-qa-report.md`.
- Templates: `sdd-templates/proposal.md`, `sdd-templates/spec.md`, `sdd-templates/run-manifest.md`, `sdd-templates/build-report.md`, `sdd-templates/build-qa-report.md`.
- Menu agents: `.claude/agents/discovery.md`, `.claude/agents/spec.md`, `.claude/agents/build.md`.
- Internal spawn targets: `.claude/agents/spec-architect.md`, `.claude/agents/spec-qa.md`, `.claude/agents/build-frontend.md`, `.claude/agents/build-backend.md`.
- Post-implementation QA: `.claude/agents/build-qa.md` and Codex skill `.codex/skills/build-qa/SKILL.md`.
- Codex skills equivalent for each agent in `.codex/skills/<name>/SKILL.md`.

## Validation Dry-Run

1. Invoke `@discovery` with a small idea and define the `<slug>`.
2. Confirm it converses first and only writes `sdd-docs/<slug>/YYYY-MM-DD-proposal.md` when the user asks.
3. Invoke `@spec`.
4. Confirm it asks the user on scope/intent gaps, does not spawn unnecessarily, runs `spec-qa`, and generates `sdd-docs/<slug>/YYYY-MM-DD-spec.md` with numbered features.
5. Confirm `spec-qa` wrote `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md`, the verdict is copied verbatim into the spec, and `FAIL` blocks finalization.
6. Confirm that if a feature crosses the FE/BE boundary without `Integration Contract`, `spec-qa` returns `FAIL`.
7. Invoke `@build` with the approved spec.
8. Confirm it chooses the mode (DIRECT/PARALLEL), derives the contract, writes `run-manifest.md`, and spawns `build-qa` only with `{spec.md, run-manifest.md}`.
9. Confirm `PASS` requires full coverage and generates `build-report.md` with status `DELIVERED`; and that `ceiling=3`/`BLOCKED`/`no-progress`/`spec-gap` generate `ESCALATED` with the trigger.
