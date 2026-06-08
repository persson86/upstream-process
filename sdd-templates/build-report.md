# Build Report: <short title>

> Audit artifact of the `build` in autonomous downstream. Records what
> was built, the build<->build-qa loop, and final status. **NOT** an input to
> `build-qa` (which sees only `spec.md` + `run-manifest.md`) — creator/verifier
> isolation.

## Origin

- Spec: `sdd-docs/<slug>/YYYY-MM-DD-spec.md`
- Run manifest: `sdd-docs/<slug>/YYYY-MM-DD-run-manifest.md`
- Date:
- Build mode: DIRECT | PARALLEL

## Derived Contract From Spec

> Copied/derived from the `Integration Contract` section of the spec. `N/A` when there is
> no FE/BE boundary nor external integration.

- Endpoints/routes:
- Request/response shapes:
- Shared types/models:
- Error states:

## What Was Built

| Feature | Files/modules touched | Note |
| --- | --- | --- |
| F1 | <files> | <note> |

## Iteration History

| Iteration | Change applied | build-qa verdict | Findings resolved (IDs) |
| --- | --- | --- | --- |
| 1 | <initial build> | PASS \| PARTIAL \| FAIL \| BLOCKED | <DQ-NN, ...> |

## Final Status

- Status: DELIVERED | ESCALATED
- If ESCALATED, trigger: iteration-ceiling | BLOCKED | no-progress | spec-gap
- Reason / what is needed to unblock:

## Pending Items and Assumptions

- **Assumption:** <assumption> - impact if wrong.
- **Pending:** <what was deferred>.
