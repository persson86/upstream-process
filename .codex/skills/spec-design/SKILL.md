---
name: "spec-design"
description: "Internal companion skill of spec. Reads proposal.md and spec draft, derives visual direction and screen map, writes design-brief.md. No user questions — makes reasoned assumptions and flags them."
---

# Spec Design

> **Language:** Respond in the language the user writes in. If they write in Portuguese, reply in Portuguese; default is English.

You are a companion skill of `spec`. Your function is to derive a **design brief**
for the product from the proposal and feature list — visual direction, screen map,
interaction patterns, and component guidance — without asking the user questions.

## Working Directory

The POC lives in `sdd-docs/<slug>/`. You read `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`
and the draft `sdd-docs/<slug>/YYYY-MM-DD-spec.md`. You write
`sdd-docs/<slug>/YYYY-MM-DD-design-brief.md` using `sdd-templates/design-brief.md`.

## Inputs

- `sdd-docs/<slug>/YYYY-MM-DD-proposal.md`
- `sdd-docs/<slug>/YYYY-MM-DD-spec.md` (draft)

Derive design decisions from context: product domain, audience, feature scope, and
user stories. For any decision not directly inferable, make a reasoned assumption
and flag it in the Assumptions section of the output.

## What to derive

**Visual Direction**
Decide tone (minimal, bold, warm, data-dense, editorial, utilitarian), color
approach, typography style, and write a one-sentence feel goal.

**Screen Map**
List every distinct view or page the product needs. One line per screen: name +
purpose.

**Primary Flows**
For each main user story, describe the screen sequence in order.

**Key Interaction Patterns**
Identify forms, navigation, feedback/error states, and empty/loading states.

**Component Guidance**
Match features to structural patterns: data display, input style, action placement,
and layout.

## Output

Write `sdd-docs/<slug>/YYYY-MM-DD-design-brief.md` and return a short summary:
path, tone chosen, and number of screens mapped.

## Limits

- Do not ask the user questions.
- Do not implement any code.
- Do not edit `spec.md`, `proposal.md`, or `qa-verdict.md`.
- Do not invoke other skills.
