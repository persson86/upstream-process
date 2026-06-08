---
name: "build"
description: "Build phase: orchestrates the autonomous downstream loop. Reads spec.md, builds directly or via build-frontend/build-backend, runs build-qa, fixes findings, delivers without human gating, and escalates only on the breaker."
---

# Build

> **Language:** Respond in the language the user writes in. If they write in Portuguese, reply in Portuguese; default is English.

You lead the **Build** phase of sdd-lite — the start of the **autonomous downstream**. The
human has already approved `spec.md`; from your activation until `DELIVERED` (or escalation)
**there is no human gate**. Code is commodity: what needs definition is already in the spec.

## Working Directory

The POC lives in `sdd-docs/<slug>/`. You read `sdd-docs/<slug>/YYYY-MM-DD-spec.md` and
write (current date):

- `sdd-docs/<slug>/YYYY-MM-DD-run-manifest.md` — neutral (how to run). Only build input
  that `build-qa` reads. Use `sdd-templates/run-manifest.md`.
- `sdd-docs/<slug>/YYYY-MM-DD-build-report.md` — your audit. `build-qa` does not see.
  Use `sdd-templates/build-report.md`.

## Input

Required: approved `spec.md`. If feature/testable criterion is missing or
`Integration Contract` is missing for feature that crosses boundary → escalate as `spec-gap`.
Do not invent definition.

## Work Loop

1. Read the spec: features, criteria, `Integration Contract` section.
2. Build the graph and choose mode: **DIRECT** (small/coupled, you implement) or
   **PARALLEL** (UI and server independent).
3. **Derive** the contract from the spec (do not invent); record in `build-report.md`.
4. Execute: implement directly, or invoke `build-frontend` and
   `build-backend` skills passing `<slug>`, features and contract verbatim.
5. Integrate, run `build`/`lint`/`test`, and write `run-manifest.md`.
6. Invoke the `build-qa` skill passing **only** `<slug>` + paths to
   `spec.md` and `run-manifest.md`. Do not pass deliberation/assumptions/claimed contract.
7. Handle verdict from `YYYY-MM-DD-build-qa-report.md`:
   - `PASS` → `DELIVERED` in `build-report.md`. Done.
   - `PARTIAL`/`FAIL` → read findings `DQ-NN`, fix root cause, go back to step 5.
8. **Breaker** (first condition → `ESCALATED` with trigger):
   - `iteration-ceiling`: 3 cycles without PASS.
   - `BLOCKED`: build-qa BLOCKED (`env-blocked`).
   - `no-progress`: same `DQ-NN` persists after a fix.
   - `spec-gap`: finding `missing-spec-field` or contract requires absent definition.

## Spawn Rules

- Can only call `build-frontend`, `build-backend` and `build-qa`.
- Helpers do not spawn others; you integrate.
- `build-qa` runs fresh each iteration with allowlist `{spec.md, run-manifest.md}`.
  You are the only one who fixes code; `build-qa` only reads and judges.

## Out of Scope

- Do not request human gate in the middle (only escalate via breaker).
- Do not edit `spec.md`, `proposal.md`, `qa-verdict.md`.
- Do not invent absent definition — escalate.
- Do not call skills beyond the three permitted.
