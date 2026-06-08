---
name: "build-qa"
description: "Use after an implementation exists to validate user flows against sdd-lite spec.md with browser evidence. Extract acceptance criteria, bootstrap Playwright/browser if needed, run flows read-only, and write a build-qa-report."
---

# Build-QA

Use this skill to validate an implementation against
`sdd-docs/<slug>/YYYY-MM-DD-spec.md`. The goal is to test real flow, not review
code.

## Required Context (fixed allowlist)

Read **only** two artifacts:

- `sdd-docs/<slug>/YYYY-MM-DD-spec.md` — source of the **expected** behavior.
- `sdd-docs/<slug>/YYYY-MM-DD-run-manifest.md` — source of **execution** (how to
  run, URL, test data, credentials).

**Creator/verifier isolation:** never read, request, or accept `build-report.md`,
the builder's rationale, claimed contract, assumptions, or iteration history. Derive
the expected behavior from `spec.md` only; use `run-manifest.md` solely to locate and
run the app. When invoked standalone without a run-manifest, ask the user only for
the minimal execution detail (URL/command/data) — never the builder's rationale.

## Shared Contract

Read the `Phase 4: Build-QA` section of `PROCESS.md` (it includes the Browser
Capability Check) and use `sdd-templates/build-qa-report.md` as the report template.

## Workflow

1. Read the spec and build a checklist by numbered feature.
2. Identify the browser flows and data needed for each acceptance criterion.
3. Check the browser harness:
   - inspect project scripts and dependencies;
   - verify `node`, `npm`, and `npx`;
   - use project Playwright when present;
   - use bundled/runtime Playwright when available;
   - if Playwright browsers are missing, run or request permission for
     `npx playwright install`;
   - if downloads are unavailable, try system Chrome/Edge channel;
   - fall back to headless when GUI is blocked;
   - report `Browser Harness: BLOCKED` with exact error if no browser works.
4. Start the app only when necessary, using existing project commands.
5. Exercise the flow as a user with Playwright/browser automation.
6. Compare observed behavior to the spec.
7. Write `sdd-docs/<slug>/YYYY-MM-DD-build-qa-report.md`.

## Rules

- Read-only by default: do not edit implementation, spec, fixtures, or real data.
- Do not mark browser criteria as PASS unless a browser was actually exercised.
- Prefer `BLOCKED` over inferred success.
- Capture concrete evidence: URL, actions, DOM text, screenshot, snapshot, log, or
  exact error.
- If the user asks to fix findings, treat that as a separate implementation task.

## Coverage And Verdict

- `PASS` only when **every** acceptance criterion of **every** numbered feature was
  tested with evidence, or marked `N/A` anchored to the spec. Partial coverage,
  missing data, or an untested criterion => `PARTIAL` or `BLOCKED`, never `PASS`.
- Each finding gets a **stable ID** `DQ-NN`, the affected feature/criterion, and a
  **category**: `bug` | `missing-coverage` | `missing-spec-field` | `env-blocked`.
  Keep IDs stable across runs for the same problem so `build` can detect
  no-progress.

## Output

Report:

```md
Verdict: PASS | PARTIAL | FAIL | BLOCKED
Browser Harness: READY | DEGRADED | BLOCKED
Spec Coverage (one row per criterion):
- F1 / <criterion>: PASS | FAIL | BLOCKED | N/A - <evidence>
Findings:
- DQ-01 | F1 / <criterion> | bug|missing-coverage|missing-spec-field|env-blocked | high|medium|low - <finding>
```

Final chat response should summarize the verdict, highest-impact findings, and
the report path.
