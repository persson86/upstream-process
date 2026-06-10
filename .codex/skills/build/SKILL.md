---
name: "build"
description: "Build phase: reads spec.md and implements all features directly. Delivers without human gating. Escalates only on missing-spec."
---

# Build

> **Language:** Respond in the language the user writes in. If they write in Portuguese, reply in Portuguese; default is English.

You drive the **Build** phase of sdd-lite — the start of the **autonomous downstream**. The human has already approved `spec.md`; from your activation onwards **there is no human gate** until `DELIVERED` or a `missing-spec` escalation. Code is a commodity: everything that needs definition should already be in the spec.

## Working Directory

The POC lives in `sdd-docs/<slug>/`. You read `sdd-docs/<slug>/YYYY-MM-DD-spec.md` and write two artifacts (with today's date):

- `sdd-docs/<slug>/YYYY-MM-DD-run-manifest.md` — **neutral**, how to run the app. Use `sdd-templates/run-manifest.md`.
- `sdd-docs/<slug>/YYYY-MM-DD-build-report.md` — your audit (contract, status). Use `sdd-templates/build-report.md`.

If `<slug>` is unclear, ask the user.

## Input

- Required: `sdd-docs/<slug>/YYYY-MM-DD-spec.md` approved.

If the spec does not exist, or lacks a feature/testable criterion, or lacks `Integration Contract` for a feature that crosses FE/BE boundary or external integration, **escalate as `missing-spec`** — do not invent definition (that is Spec's job).

## Progress Log

At every major step, append a timestamped line to `sdd-docs/<slug>/build-progress.log` so the user can monitor progress in real time (e.g. `tail -f build-progress.log`). Format:

```
[HH:MM:SS] <message>
```

Mandatory log points:
- Start: `[HH:MM:SS] Build started`
- After planning: `[HH:MM:SS] Implementing features: F1, F2, ...`
- After implementation: `[HH:MM:SS] Implementation complete — integrating and testing`
- Final: `[HH:MM:SS] DELIVERED` or `[HH:MM:SS] ESCALATED — trigger: missing-spec — <reason>`

Use `date +%H:%M:%S` to get the timestamp. Append with `>>`, never overwrite.

## Work Loop

1. Read the spec. Extract numbered features, acceptance criteria, and the `Integration Contract` section. If the spec's Design Brief section references a `design-brief.md`, read it — it guides all UI work.
2. Validate input: if any feature lacks testable criteria, or a cross-boundary feature lacks a contract, **escalate `missing-spec`** and stop.
3. Derive the contract from the spec's `Integration Contract` section (do not invent). Record it in `build-report.md`. Implement all features directly. Expose **exactly** the contract's routes, shapes, types, and error states — no unagreed surface.
4. Integrate, resolve seams, and run what works (`build`/`lint`/`test`). Write `run-manifest.md` with how to run and test data.
5. Mark `DELIVERED` in `build-report.md`. Suggest the user invokes `build-qa` in a new chat session to verify.

## Visual Quality

When any feature includes a user interface, follow the direction in the `design-brief.md` referenced by the spec (tone, screen map, interaction patterns, component guidance). When the `frontend-design` skill is available in the environment, use it to guide the UI construction. When unavailable, follow its principles inline: distinctive typography, coherent aesthetic direction, purposeful motion, avoiding "AI slop" (Inter/Arial/generic purple gradient). Combine implementation complexity with aesthetic vision.

## Out Of Scope

- Do not request human gate/approval in the middle of downstream (escalate only via `missing-spec`).
- Do not edit `spec.md`, `proposal.md`, or `qa-verdict.md`.
- Do not invent definition absent from the spec — escalate.
- Do not call other agents or skills.
