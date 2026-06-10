# Spec: <short title>

## Origin

- Proposal: `proposal.md`
- Date:
- Spec author:

## Job To Be Done

When <situation>, I want <motivation/need>, so that <measurable or observable outcome>.

## User Stories

1. As a <persona>, I want <capability>, so that <outcome>.
2. As a <persona>, I want <capability>, so that <outcome>.

## Numbered Features

### F1. <feature name>

**Objective:** <outcome this feature delivers>

**Scope:**

- Includes:
- Does not include:

**Acceptance criteria:**

- Given <context>, when <action>, then <observable result>.
- Given <context>, when <action>, then <observable result>.

**Dependencies/order:** <why this feature comes in this position>

### F2. <feature name>

**Objective:** <outcome this feature delivers>

**Scope:**

- Includes:
- Does not include:

**Acceptance criteria:**

- Given <context>, when <action>, then <observable result>.

**Dependencies/order:** <why this feature comes in this position>

## Integration Contract

Fill in **when any feature crosses FE/BE boundary or integrates with external service**. This contract is what the downstream autonomous (`build`) derives and helpers implement verbatim — if missing here, `spec-qa` blocks the spec (don't leave the gap for downstream to get stuck).

If no feature crosses boundary, write: `N/A — no FE/BE boundary or external integration.`

- **Endpoints/routes:** method, path, purpose.
- **Request/Response:** payload shape per endpoint (fields and types).
- **Shared types/models:** entities and fields used by FE and BE.
- **Error states:** codes/conditions and how the client reacts.
- **Setup data/auth:** what needs to exist to exercise the flow.
- **Expected behavior per criterion:** for each acceptance criterion that crosses boundary, the observable result without ambiguity.

## Design Brief

_Present only when any feature includes a user interface. Omit for API-only specs._

- **File:** `sdd-docs/<slug>/YYYY-MM-DD-design-brief.md`
- **Tone:** <filled in after spec-design runs>
- **Screens:** <N screens mapped>

> Do not inline the design brief content here — reference the file. `build` reads it directly.

## Architecture Notes

Record technical constraints, relevant decisions, integrations, data, implementation risks, and findings from `architect` when called.

## Assumptions And Open Questions

- **Assumption:** <assumption> - impact if wrong.
- **Question:** <question> - owner or timing of answer.

## QA-Gate

Source of truth: `sdd-docs/<slug>/qa-verdict.md`, written by `spec-qa`. The block below is copied verbatim; in case of divergence, the file takes precedence.

### Verdict Verbatim From `spec-qa`

```text
<paste here the content of qa-verdict.md, without editing>
```

### Resolution

Default path = **resolve** the findings (re-run `spec-qa` until `PASS`). Waiver is exception and requires explicit user request.

- Findings resolved (with feature reference):
- Explicit user waivers (only with user request):
- Final gate status: PASS | CONCERNS (RESOLVED) | CONCERNS (WITH WAIVER) | FAIL (BLOCKED)
