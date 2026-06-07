---
name: "down-qa"
description: "Use after an implementation exists to validate user flows against sdd-lite spec.md with browser evidence. Extract acceptance criteria, bootstrap Playwright/browser if needed, run flows read-only, and write a down-qa-report."
---

# Down-QA

Use esta skill para validar uma implementacao contra
`up-docs/<slug>/YYYY-MM-DD-spec.md`. O objetivo e testar fluxo real, nao revisar
codigo.

## Required Context

- Spec: `up-docs/<slug>/YYYY-MM-DD-spec.md`.
- For web flows: initial URL or dev-server command.
- Optional: feature scope, test data, credentials supplied by the user.

If essential input is missing, ask for the smallest missing piece.

## Shared Contract

Read `down-qa/PROCESS.md` and use `templates/down-qa-report.md` as the
report template.

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
7. Write `up-docs/<slug>/YYYY-MM-DD-down-qa-report.md`.

## Rules

- Read-only by default: do not edit implementation, spec, fixtures, or real data.
- Do not mark browser criteria as PASS unless a browser was actually exercised.
- Prefer `BLOCKED` over inferred success.
- Capture concrete evidence: URL, actions, DOM text, screenshot, snapshot, log, or
  exact error.
- If the user asks to fix findings, treat that as a separate implementation task.

## Output

Report:

```md
Verdict: PASS | PARTIAL | FAIL | BLOCKED
Browser Harness: READY | DEGRADED | BLOCKED
Spec Coverage:
- F1: PASS | FAIL | BLOCKED - <evidence>
Findings:
- [severity: high|medium|low] <finding>
```

Final chat response should summarize the verdict, highest-impact findings, and
the report path.
