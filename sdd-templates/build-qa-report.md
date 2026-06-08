# Build-QA Report: <short title>

## Origin

- Spec: `sdd-docs/<slug>/YYYY-MM-DD-spec.md`
- Date:
- Executor:
- Tested scope:

## Verdict

Verdict: PASS | PARTIAL | FAIL | BLOCKED

Browser Harness: READY | DEGRADED | BLOCKED

> `PASS` is only valid when **every** acceptance criterion of **every**
> numbered feature was tested with evidence, or marked `N/A` with an anchor in
> the spec. Partial coverage, missing data, or untested criteria => `PARTIAL`
> or `BLOCKED`, never `PASS`.

## Test Setup

> Data origin: `run-manifest.md` (only permitted build input). The
> *expected* comes from `spec.md`.

- App command:
- Initial URL:
- Browser/runtime:
- Test data:
- Credentials:

## Spec Coverage

> One line per acceptance criterion of each feature. No missing lines.

| Feature | Criterion | Status | Evidence |
| --- | --- | --- | --- |
| F1 | <acceptance criterion> | PASS \| FAIL \| BLOCKED \| N/A | <URL, action, screenshot, snapshot or log; for N/A, anchor in spec> |

## Browser Run

1. <action performed>
2. <action performed>
3. <relevant observation>

## Findings

> Each finding has a **stable ID** (`DQ-NN`), the affected feature/criterion, and a
> **category**. The `build` agent uses the ID to detect "no-progress" (same ID
> persists after a fix) and the category to trigger the circuit breaker.
> Categories: `bug` | `missing-coverage` | `missing-spec-field` | `env-blocked`.

| ID | Feature/Criterion | Category | Severity | Finding (anchored in spec + evidence) |
| --- | --- | --- | --- | --- |
| DQ-01 | F1 / <criterion> | bug \| missing-coverage \| missing-spec-field \| env-blocked | high \| medium \| low | <objective finding> |

## Required Changes

- <change necessary before considering the feature compliant, or "None">

## Blockers

- <credential, data, environment, permission, or browser missing, or "None">

## Artifacts

- Screenshots:
- Snapshots:
- Logs:
