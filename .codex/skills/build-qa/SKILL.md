---
name: "build-qa"
description: "Use after an implementation exists to validate user flows against sdd-lite spec.md with browser evidence. Extract acceptance criteria, bootstrap Playwright/browser if needed, run flows read-only, and write a build-qa-report."
---

# Build-QA

Use this skill to validate an implementation against
`sdd-docs/<slug>/YYYY-MM-DD-spec.md`. The goal is to test real flow, not review
code.

## Required Context (fixed allowlist)

Read **only** these artifacts:

- `sdd-docs/<slug>/YYYY-MM-DD-spec.md` — source of the **expected** behavior.
- `sdd-docs/<slug>/YYYY-MM-DD-run-manifest.md` — source of **execution** (how to
  run, URL, test data, credentials).
- `sdd-docs/<slug>/YYYY-MM-DD-design-brief.md` — only when referenced by the
  spec for UI features; source of expected UI direction.
- `UI_BASELINE.md` — only when UI features are present; source of minimum UI/UX
  quality requirements.

**Creator/verifier isolation:** never read, request, or accept `build-report.md`,
the builder's rationale, claimed contract, assumptions, or iteration history. Derive
the expected behavior from `spec.md`, and for UI features from the referenced
`design-brief.md` plus `UI_BASELINE.md`; use `run-manifest.md` solely to locate
and run the app. When invoked standalone without a run-manifest, ask the user only
for the minimal execution detail (URL/command/data) — never the builder's rationale.

## Shared Contract

Read the `Phase 4: Build-QA` section of `PROCESS.md` (it includes the Browser
Capability Check) and use `sdd-templates/build-qa-report.md` as the report template.

## Workflow

1. Read the spec and build a checklist by numbered feature.
2. If the spec references a design brief, read it and `UI_BASELINE.md`; add
   observable UI quality checks to the checklist.
3. Identify the browser flows and data needed for each acceptance criterion.
4. Check the browser harness:
   - inspect project scripts and dependencies;
   - verify `node`, `npm`, and `npx`;
   - use project Playwright when present;
   - use bundled/runtime Playwright when available;
   - if Playwright browsers are missing, run or request permission for
     `npx playwright install`;
   - if downloads are unavailable, try system Chrome/Edge channel;
   - fall back to headless when GUI is blocked;
   - report `Browser Harness: BLOCKED` with exact error if no browser works.
5. Start the app only when necessary, using existing project commands.
6. Exercise the flow as a user with Playwright/browser automation.
7. Compare observed behavior to the spec, design brief, and UI baseline where
   applicable.
8. Write `sdd-docs/<slug>/YYYY-MM-DD-build-qa-report.md`.

## Rules

- Read-only by default: do not edit implementation, spec, fixtures, or real data.
- Do not mark browser criteria as PASS unless a browser was actually exercised.
- Prefer `BLOCKED` over inferred success.
- Capture concrete evidence: URL, actions, DOM text, screenshot, snapshot, log, or
  exact error.
- For UI features, check observable baseline items when data allows: labels,
  keyboard/focus behavior, contrast or readable color use, responsive layout,
  loading/error/empty/disabled states, text overflow, and project token consistency.
- If the user asks to fix findings, treat that as a separate implementation task.

## Coverage And Verdict

- `PASS` only when **every** acceptance criterion of **every** numbered feature was
  tested with evidence, or marked `N/A` anchored to the spec. Partial coverage,
  missing data, or an untested criterion => `PARTIAL` or `BLOCKED`, never `PASS`.
- Each finding gets a **stable ID** `DQ-NN`, the affected feature/criterion, and a
  **category**: `bug` | `ui-baseline` | `missing-coverage` | `missing-spec-field` | `env-blocked`.
  Keep IDs stable across runs for the same problem — they serve as references
  for the human when triaging or requesting fixes.

## Output

Report:

```md
Verdict: PASS | PARTIAL | FAIL | BLOCKED
Browser Harness: READY | DEGRADED | BLOCKED
Spec Coverage (one row per criterion):
- F1 / <criterion>: PASS | FAIL | BLOCKED | N/A - <evidence>
Findings:
- DQ-01 | F1 / <criterion> | bug|ui-baseline|missing-coverage|missing-spec-field|env-blocked | high|medium|low - <finding>
```

Final chat response should summarize the verdict, highest-impact findings, and
the report path.
