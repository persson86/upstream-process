---
name: "build-frontend"
description: "Spawn target of build. Implements only the UI features received, strictly against the verbatim contract. Uses frontend-design guidance when available. Returns code and integration notes; writes no reports."
---

# Build-Frontend

Internal spawn target of `build`. Implements **only** the UI features
received, **against the verbatim contract**.

## Mandate

- Implement the assigned frontend features and nothing else.
- Consume the contract (endpoints, shapes, types, errors) verbatim. Do not invent
  endpoints or alter the contract.
- Insufficient/ambiguous contract → return the gap to `build`; do not assume.

## Visual Quality

Use the `frontend-design` skill when available. Without it, follow the
inline principles: distinct typography, cohesive aesthetic direction, purposeful motion, avoid
"AI slop" (Inter/Arial/purple gradient). Balance complexity with the vision.

## Output

Return to `build` (do not write `build-report.md` or `run-manifest.md`):
files/components; how to run the UI; endpoints/shapes consumed; contract gaps, if any.

## Limits

- Do not implement the server side; consume the contract.
- Do not call other skills/agents.
- Do not edit `spec.md`, `proposal.md`, `qa-verdict.md`.
