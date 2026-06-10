# SDD-lite

SDD-lite framework for transforming a raw idea into a testable and sliceable `spec.md`, with the user driving decisions and agents acting only on demand.

## Principles

The workflow has **two regimes**, with the dividing line at `spec.md`:

- **Upstream (Discovery, Spec): human-led**, step by step. No auto-handoff;
  each phase advances by user decision.
- **Downstream (Build, Build-QA): autonomous** from the approved spec. The human
  triggers `build` once; it implements all features directly and delivers without
  human gate, escalating only on `missing-spec`. After delivery, the human triggers
  `build-qa` in a new session to verify — no engine/state machine anywhere.

Additional principles:

- Self-contained project: no inheritance from other frameworks; anything useful from outside is copied in.
- UI work uses `UI_BASELINE.md`: a quality baseline plus default UI tokens
  (colors, typography, spacing, motion) that apply when the user states no visual
  preference. During discovery/spec every project may override its visual
  identity, including primary color, while keeping accessibility, state coverage,
  responsive behavior, usable writing, and restrained motion as minimum
  requirements.
- Each POC lives in `sdd-docs/<slug>/` and contains `YYYY-MM-DD-proposal.md`, `YYYY-MM-DD-spec.md`, `YYYY-MM-DD-qa-verdict.md`, `YYYY-MM-DD-design-brief.md` (when UI features are present), `YYYY-MM-DD-run-manifest.md`, `YYYY-MM-DD-build-report.md`, and `YYYY-MM-DD-build-qa-report.md`.
- `discovery` writes the proposal only when the user explicitly asks.
- `spec` owns the `spec.md` artifact and decides, by gap, between asking the user, calling an isolated lens, or assuming and recording the assumption.
- Spawns are closed: `spec` only calls `spec-architect`, `spec-design`, or `spec-qa`; `build` spawns no agents — it implements directly.
- **The `spec-qa` gate is load-bearing.** Because the downstream delivers without human review, the spec is the only guarantee: `spec-qa` returns `FAIL` if a feature crosses the FE/BE boundary and the `Integration Contract` is absent/ambiguous. QA is a gate, not optional advice; `spec-qa` writes `qa-verdict.md` (source of truth) and `spec` copies it verbatim, without editing.
- **Creator/verifier isolation in downstream:** `build` constructs and fixes; `build-qa` only reads `spec.md` + `run-manifest.md` (never `build-report.md`) and judges. PASS requires full coverage of criteria.

## Phases

| Phase | Regime | Agent | Input | Output | Human Gate |
| --- | --- | --- | --- | --- | --- |
| 1. Discovery | upstream | `$discovery` | Idea, context, and user answers | `sdd-docs/<slug>/YYYY-MM-DD-proposal.md` | User explicitly asks to generate |
| 2. Spec | upstream | `$spec` | `sdd-docs/<slug>/YYYY-MM-DD-proposal.md` | `sdd-docs/<slug>/YYYY-MM-DD-spec.md` | User approves spec and QA gate is not in `FAIL` |
| 3. Build | downstream | `$build` | `sdd-docs/<slug>/YYYY-MM-DD-spec.md` approved | `run-manifest.md` + `build-report.md` (`DELIVERED`/`ESCALATED`) | Trigger only; no gate until `DELIVERED` or `missing-spec` escalation |
| 4. Build-QA | downstream | `$build-qa` (user-triggered after `build` delivers) | `spec.md` + `run-manifest.md` | `sdd-docs/<slug>/YYYY-MM-DD-build-qa-report.md` | User triggers in a new session and triages findings |

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

Operation of `spec`:

1. Read `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`.
2. Perform a gap scan on intent, priority, scope, technical feasibility, risks, and testability.
3. For each gap, choose one action:
   - ask the user when the gap is intent, priority, or scope;
   - call `spec-architect` when technical feasibility requires reading code, stack, or implementation constraints;
   - assume and signal when the assumption is small, reversible, and does not block the spec.
4. Draft `sdd-docs/<slug>/YYYY-MM-DD-spec.md`.
5. If any feature includes a user interface, call `spec-design` passing the `<slug>` and the draft spec path. It reads `UI_BASELINE.md`, writes `sdd-docs/<slug>/YYYY-MM-DD-design-brief.md` without asking the user questions, and defines project UI tokens — confirming the baseline's Default UI Tokens or overriding them per the proposal's Visual Reference; the spec references both the design brief and baseline in its Design Brief section.
6. Call `spec-qa` passing only `YYYY-MM-DD-proposal.md` and the `YYYY-MM-DD-spec.md` draft. `spec-qa` writes the verdict in `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md`.
7. Read `YYYY-MM-DD-qa-verdict.md` and copy the verdict verbatim into the fixed QA-gate section of the spec.
8. Finalize only if the gate permits.

## Spawn Rules

- `spec` can spawn only `spec-architect`, `spec-design`, and `spec-qa`.
- `build` spawns no agents; it implements all features directly.
- `spec-architect` is optional and used only for technical feasibility depending on reading code, stack, or concrete constraints.
- `spec-design` is used when any feature includes a user interface; it reads `UI_BASELINE.md` and writes `design-brief.md` without asking the user questions.
- `spec-qa` is mandatory before finalizing any `spec.md`.
- `build-qa` is triggered by the user in a new session after `build` delivers; it runs fresh with the allowlist `{spec.md, run-manifest.md}`.
- Helpers do not own `spec.md`. `spec-architect` returns findings for `spec` to incorporate; `spec-design` and `spec-qa` write their own artifacts (`design-brief.md`, `qa-verdict.md`).

## QA-Gate

`spec-qa` receives only:

- `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`;
- current draft of `sdd-docs/<slug>/YYYY-MM-DD-spec.md`.

It does not receive `spec`'s deliberation, internal history, or additional justifications. **`spec-qa` itself writes the verdict in `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md`** — this file exists independently of `spec`, which cannot edit it.

Verdicts:

- `PASS`: the `spec.md` can be finalized.
- `CONCERNS`: default path is to resolve findings (re-run `spec-qa` until `PASS`); waiver is an exception and requires explicit user request, recorded in the `spec.md`.
- `FAIL`: blocks finalization. `spec` must review the draft and run a new QA gate (`spec-qa` rewrites `qa-verdict.md`).

`spec` cannot edit, summarize, or discard the verdict. It must copy it verbatim from `qa-verdict.md` into the `QA-Gate` section of `spec.md`. Beyond the verdicts above, `spec-qa` returns `FAIL` when a feature crosses the FE/BE boundary or external integration and the `Integration Contract` in the spec is absent, incomplete, or ambiguous (contract-completeness gate) — the gap is resolved in the Spec, not downstream.

## Phase 3: Build

Objective: transform the approved `spec.md` into delivered implementation,
**autonomously**. The human triggers `build` once; no human gate until
`DELIVERED` or a `missing-spec` escalation.

Operation of `build`:

1. Read the spec. Extract numbered features, acceptance criteria, and the
   `Integration Contract` section. If the spec references a design brief, read
   that brief and `UI_BASELINE.md`; together they guide UI work.
2. Validate input: if any feature lacks testable criteria, or a feature crossing
   the FE/BE boundary or an external integration lacks a contract, escalate
   `missing-spec` and stop — do not invent definition (that is Spec's job).
3. Derive the contract from the `Integration Contract` section of the spec (do not
   invent) and record it in `build-report.md`. Implement all features directly.
4. Integrate, run `build`/`lint`/`test`, and write `run-manifest.md` (neutral: how to run).
5. Mark `DELIVERED` in `build-report.md` and suggest the user invokes `build-qa`
   in a new session to verify.

During the run, `build` appends timestamped lines to
`sdd-docs/<slug>/build-progress.log` so the user can monitor the autonomous
phase in real time (e.g. `tail -f build-progress.log`).

For UI features, `build` follows project-specific choices from the design brief
(such as primary color, typography, density, layout, and component direction)
while treating `UI_BASELINE.md` as the minimum bar for accessibility, state
coverage, responsive behavior, writing quality, and motion. If they conflict,
the baseline wins for accessibility and usability; the design brief wins for
visual identity.

`build` is the only entity that writes code and `build-report.md` (audit,
not seen by build-qa). Creator/verifier isolation preserved.

## Phase 4: Build-QA

Objective: validate the implementation against `spec.md` using real flow and
observable evidence. For web, the preferred path is real browser with
Playwright, browser CLI, or equivalent tool. Triggered by the user in a
new session after `build` delivers (creator/verifier isolation).

Operation:

1. Read `sdd-docs/<slug>/YYYY-MM-DD-spec.md` (expected) and
   `sdd-docs/<slug>/YYYY-MM-DD-run-manifest.md` (execution). If the spec
   references UI, also read the referenced `design-brief.md` and `UI_BASELINE.md`
   as expected UI behavior. Never read `build-report.md`.
2. Extract **all** acceptance criteria from **all** features.
3. For UI features, add observable checks from the design brief and baseline:
   labels, focus, keyboard behavior, readable colors, responsive layout,
   loading/error/empty/disabled states, text fit, and token consistency.
4. Locate/start the app per run-manifest, without permanent changes.
5. Run the Browser Capability Check (subsection below).
6. Navigate as a real user and compare each criterion against observed behavior.
7. Write `sdd-docs/<slug>/YYYY-MM-DD-build-qa-report.md` with coverage table and
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

- UI baseline: framework file installed at `sdd-lite/UI_BASELINE.md` in target projects.
- Directory for each POC: `sdd-docs/<slug>/` with `YYYY-MM-DD-proposal.md`, `YYYY-MM-DD-spec.md`, `YYYY-MM-DD-qa-verdict.md`, `YYYY-MM-DD-design-brief.md` (when UI features are present), `YYYY-MM-DD-run-manifest.md`, `YYYY-MM-DD-build-report.md`, and `build-progress.log`.
- Build-QA report: `sdd-docs/<slug>/YYYY-MM-DD-build-qa-report.md`.
- Templates: `sdd-templates/proposal.md`, `sdd-templates/spec.md`, `sdd-templates/design-brief.md`, `sdd-templates/run-manifest.md`, `sdd-templates/build-report.md`, `sdd-templates/build-qa-report.md`.
- Menu agents: `.claude/agents/discovery.md`, `.claude/agents/spec.md`, `.claude/agents/build.md`.
- Internal spawn targets of `spec`: `.claude/agents/spec-architect.md`, `.claude/agents/spec-design.md`, `.claude/agents/spec-qa.md`.
- Post-implementation QA: `.claude/agents/build-qa.md` and Codex skill `~/.codex/skills/build-qa/SKILL.md`.
- Codex skills equivalent for each agent in `~/.codex/skills/<name>/SKILL.md`.

## Validation Dry-Run

1. Invoke `$discovery` with a small idea and define the `<slug>`.
2. Confirm it converses first and only writes `sdd-docs/<slug>/YYYY-MM-DD-proposal.md` when the user asks.
3. Invoke `$spec`.
4. Confirm it asks the user on scope/intent gaps, does not spawn unnecessarily, runs `spec-qa`, and generates `sdd-docs/<slug>/YYYY-MM-DD-spec.md` with numbered features. If any feature includes a UI, confirm `spec-design` read `UI_BASELINE.md`, wrote `YYYY-MM-DD-design-brief.md`, defined project UI tokens (confirming the defaults or recording overrides), and the spec references both files.
5. Confirm `spec-qa` wrote `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md`, the verdict is copied verbatim into the spec, and `FAIL` blocks finalization.
6. Confirm that if a feature crosses the FE/BE boundary without `Integration Contract`, `spec-qa` returns `FAIL`.
7. Invoke `$build` with the approved spec.
8. Confirm it implements all features directly without spawning agents, derives the contract from the spec, follows `design-brief.md` + `UI_BASELINE.md` for UI features, writes `run-manifest.md`, and marks `DELIVERED` in `build-report.md`.
9. Confirm that a spec lacking testable criteria or an `Integration Contract` for a cross-boundary feature makes `build` mark `ESCALATED` with trigger `missing-spec`.
10. Invoke `$build-qa` in a new session; confirm it reads only `{spec.md, run-manifest.md}` plus `{design-brief.md, sdd-lite/UI_BASELINE.md}` when UI is referenced, and that `PASS` requires full coverage of all acceptance criteria and observable UI baseline checks.
