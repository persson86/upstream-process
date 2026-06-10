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
> *expected* comes from `spec.md`, and for UI features from the referenced
> `design-brief.md` plus `sdd-lite/UI_BASELINE.md`.

- App command:
- Initial URL:
- Browser/runtime:
- Test data:
- Credentials:
- UI baseline used: yes | no | N/A
- Design brief: `sdd-docs/<slug>/YYYY-MM-DD-design-brief.md` | N/A

## Spec Coverage

> One line per acceptance criterion of each feature. No missing lines.

| Feature | Criterion | Status | Evidence |
| --- | --- | --- | --- |
| F1 | <acceptance criterion> | PASS \| FAIL \| BLOCKED \| N/A | <URL, action, screenshot, snapshot or log; for N/A, anchor in spec> |

## Browser Run

1. <action performed>
2. <action performed>
3. <relevant observation>

## UI Baseline Coverage

_Present when UI features exist. Omit for API-only specs._

| Area | Status | Evidence |
| --- | --- | --- |
| Project tokens / primary color | PASS \| FAIL \| BLOCKED \| N/A | <evidence> |
| Labels and accessible names | PASS \| FAIL \| BLOCKED \| N/A | <evidence> |
| Keyboard and focus behavior | PASS \| FAIL \| BLOCKED \| N/A | <evidence> |
| Error/loading/empty/disabled states | PASS \| FAIL \| BLOCKED \| N/A | <evidence> |
| Responsive layout and text fit | PASS \| FAIL \| BLOCKED \| N/A | <evidence> |
| Motion / reduced motion | PASS \| FAIL \| BLOCKED \| N/A | <evidence> |

## Findings

> Each finding has a **stable ID** (`DQ-NN`), the affected feature/criterion, and a
> **category**. Keep IDs stable across runs for the same issue — they serve as
> references for the human when triaging or requesting fixes.
> Categories: `bug` | `ui-baseline` | `missing-coverage` | `missing-spec-field` | `env-blocked`.

| ID | Feature/Criterion | Category | Severity | Finding (anchored in spec + evidence) |
| --- | --- | --- | --- | --- |
| DQ-01 | F1 / <criterion> | bug \| ui-baseline \| missing-coverage \| missing-spec-field \| env-blocked | high \| medium \| low | <objective finding> |

## Required Changes

- <change necessary before considering the feature compliant, or "None">

## Blockers

- <credential, data, environment, permission, or browser missing, or "None">

## Artifacts

- Screenshots:
- Snapshots:
- Logs:
