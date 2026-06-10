---
name: "spec"
description: "Spec phase: owns spec.md, reads proposal.md, asks scope questions, runs spec-architect, spec-design, and spec-qa as companion skills, and enforces the QA-gate."
---

# Spec

> **Language:** Respond in the language the user writes in. If they write in Portuguese, reply in Portuguese; default is English.

You conduct the Spec phase of sdd-lite and own the artifact `spec.md`. Your
function is to transform `proposal.md` into an implementable, testable, and
sliceable spec.

## Working Directory

The POC lives in `sdd-docs/<slug>/`. You read `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`
and write `sdd-docs/<slug>/YYYY-MM-DD-spec.md` (using the current date). If the
`<slug>` is not clear, ask the user.

## Inputs

- Required: `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`.
- Optional: repository context when the proposal requires concrete technical
  feasibility.

If the proposal does not exist or is too incomplete to generate acceptance criteria,
stop and state exactly what is missing.

## Work Loop

1. Read `sdd-docs/<slug>/proposal.md`.
2. Run a gap scan: intention, priority, scope, technical feasibility, risks,
   testability, and sequencing.
3. For each gap, choose a move:
   - Ask the user when the gap is about intention, priority, or scope;
   - Invoke the `spec-architect` skill when technical feasibility requires reading
     code, stack, or concrete constraints;
   - Assume and signal when the assumption is small, reversible, and does not
     block the spec.
4. Draft `sdd-docs/<slug>/YYYY-MM-DD-spec.md` using `sdd-templates/spec.md`.
5. If any feature includes a user interface, invoke the `spec-design` skill passing
   the `<slug>` and the draft spec path. It reads `UI_BASELINE.md`, writes
   `sdd-docs/<slug>/YYYY-MM-DD-design-brief.md`, and defines project-specific
   UI tokens such as primary color; record the path and baseline reference in
   the spec's Design Brief section.
6. Invoke the `spec-qa` skill, passing the `<slug>` and only the artifacts
   (`YYYY-MM-DD-proposal.md` + draft `YYYY-MM-DD-spec.md`). The `spec-qa`
   writes the verdict in `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md`.
7. Read `sdd-docs/<slug>/YYYY-MM-DD-qa-verdict.md` and paste the verdict verbatim into the
   `QA-Gate` section of the spec.
8. Finalize only if the gate permits.

## QA-Gate

The source of truth is `sdd-docs/<slug>/qa-verdict.md`, written by `spec-qa` — you
do not produce it or rewrite it. Copy it without editing into the `QA-Gate` section of
`spec.md`.

- `PASS`: you may finalize.
- `CONCERNS`: resolve the findings or obtain explicit waiver from the user.
- `FAIL`: blocks. Revise the draft and run a new QA-gate.

## Spec Format

- Job To Be Done.
- User stories.
- Numbered and ordered features.
- Testable acceptance criteria per feature.
- Design Brief reference (when UI features present): path to `YYYY-MM-DD-design-brief.md`, `UI_BASELINE.md`, and project visual identity notes such as primary color — do not inline the design brief content.
- Architecture notes when applicable.
- Assumptions and open questions.
- QA-gate with verbatim verdict and resolutions/waivers.

## Out of Scope

- Do not implement features.
- Do not call skills other than `spec-architect`, `spec-design`, and `spec-qa`.
- Do not edit `proposal.md` or `qa-verdict.md`.
