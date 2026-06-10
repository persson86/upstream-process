# UI Baseline

This is the default UI/UX quality baseline for sdd-lite projects. It defines minimum
interaction, accessibility, writing, and visual quality rules, plus a set of default
UI tokens that give every project an accessible, coherent starting identity.

The default tokens are a starting point, not a brand mandate. During Discovery the
user's visual preference is recorded in the proposal's Visual Reference section, and
the project's `design-brief.md` may override visual choices such as primary color,
typeface, density, and tone. Overrides must still preserve the baseline requirements
for accessibility, usability, responsive behavior, and state coverage.

## Design Brief Contract

For any feature with a user interface, `spec-design` writes a project-specific
`design-brief.md`. That file is the handoff from upstream to downstream UI work.

The design brief must include:

- Product context and audience.
- Visual direction: tone, color approach, typography style, density, and feel goal.
- Project UI tokens: either confirm the baseline default tokens or record the
  project overrides — at minimum primary color, neutral surface/background, text
  color, border color, success/warning/error colors, radius scale, spacing scale,
  and motion durations.
- Screen map and primary flows.
- Interaction patterns for forms, navigation, feedback, empty states, loading states,
  and destructive actions.
- Component guidance for data display, inputs, actions, layout, and responsive behavior.
- Writing and microcopy direction, including tone calibration by context.
- Accessibility notes and any assumptions that need user review before build.

## Default UI Tokens

Use these tokens when the user has stated no visual preference. When the proposal's
Visual Reference records a preference, the design brief overrides the affected tokens
and derives accessible supporting colors from the user's choice.

### Colors

| Token | Value | Usage |
|-------|-------|-------|
| `primary` | `#1A73E8` | Primary actions, links, active states. Never as background of large areas. |
| `primary-hover` | `#1557B0` | Hover state of primary elements. |
| `primary-active` | `#0D47A1` | Pressed/active state of primary elements. |
| `primary-subtle` | `#E8F0FE` | Subtle primary background: selected items, secondary-button hover. |
| `background` | `#FFFFFF` | Page background. |
| `surface` | `#F8F9FA` | Cards, panels, and secondary containers. |
| `border` | `#DADCE0` | Separators and input borders. |
| `text` | `#202124` | Primary readable text. |
| `muted` | `#5F6368` | Secondary text and metadata. |
| `success` | `#1E8E3E` | Feedback only. |
| `warning` | `#F9AB00` | Feedback only. |
| `error` | `#D93025` | Feedback only. |
| `info` | `#1A73E8` | Feedback only. |
| `accent` | `#E8710A` | Sparingly, for important secondary highlights. |

Feedback colors communicate system states (success, error, warning, info) — never
use them decoratively.

### Typography

- Families: **Inter** for all text; **JetBrains Mono** exclusively for code. Never
  more than two typeface families on the same screen.
- Headings: weight 700. Scale: h1 `2.25rem`/1.15, h2 `1.875rem`/1.2, h3 `1.5rem`/1.25,
  h4 `1.25rem`/1.3, with slightly negative letter spacing.
- Body: `1rem` (16px), weight 400, line height 1.5.
- Labels (forms, badges, metadata): `0.875rem` (14px), weight 500, line height 1.4.
- Code: `0.875rem` (14px) mono, line height 1.6.
- Use `rem` for font sizes — never fixed `px` (required for 200% zoom).
- No more than 3 font weights on the same screen.

### Spacing, Radius, And Elevation

- Spacing scale in multiples of 8px (4px for fine adjustment):
  `space-1` 4px, `space-2` 8px, `space-3` 16px, `space-4` 24px, `space-5` 32px,
  `space-6` 48px, `space-7` 64px. Use the scale for all spacing — no arbitrary values.
- Radius grows with component size: `radius-sm` 4px, `radius-md` 8px (inputs,
  buttons), `radius-lg` 12px (cards, panels), `radius-full` 9999px (badges, chips).
  Do not mix very different radii on the same screen.
- Elevation ladder — depth must be functional, not decorative:
  - none — flat elements and cards sitting on `surface`.
  - xs (`0 1px 2px rgba(0,0,0,0.08)`) — subtle highlight, list-item hover.
  - sm (`0 1px 3px rgba(0,0,0,0.12)`) — cards and panels in focus.
  - md (`0 4px 12px rgba(0,0,0,0.15)`) — dropdowns, tooltips.
  - lg (`0 8px 24px rgba(0,0,0,0.18)`) — modals, popovers.
  - No shadows on flat or status elements.

### Motion Tokens

- Durations: `motion-instant` 100ms, `motion-fast` 200ms, `motion-normal` 300ms,
  `motion-slow` 500ms.
- Easings: default `cubic-bezier(0.4, 0, 0.2, 1)`; decelerate
  `cubic-bezier(0, 0, 0.2, 1)` for elements entering; accelerate
  `cubic-bezier(0.4, 0, 1, 1)` for elements exiting.

### Breakpoints And Container

- Breakpoints: 640px, 768px, 1024px, 1280px, 1536px.
- Grid: 12 columns on desktop, 4 columns on mobile.
- Max content container: 1280px, centered. Mobile side margins: 16px.

## Project Customization

Defaults apply unless the user or product context says otherwise. When the user
requests a specific color or brand feel, record that in the design brief and derive
accessible supporting colors from it (hover, active, subtle variants and readable
text on top of it). Never use a requested color in a way that breaks contrast, focus
visibility, or error readability.

## Accessibility Requirements

Every UI must meet these minimum requirements:

- Text contrast: 4.5:1 for normal text, 3:1 for large text.
- UI component and meaningful icon contrast: 3:1.
- Do not communicate information by color alone; pair color with text, iconography, or
  shape.
- All form controls have visible labels associated with the control.
- Required fields are indicated in text, not only with an asterisk.
- Validation errors are specific and placed close to the relevant field.
- Placeholder text is not the only source of instructions.
- All interactive elements are keyboard reachable in logical visual order.
- Focus indicators are visible and have at least 3:1 contrast.
- Modals trap focus while open, close on `Esc`, and return focus to the opener.
- Icon-only controls have an accessible name.
- Images that convey information have useful alternative text; decorative images use
  empty alt text.
- Touch targets are at least 44 by 44 CSS pixels, with at least 8px between adjacent
  targets to avoid accidental taps.
- Status changes that do not move focus are announced with appropriate live regions.
- The interface remains usable at 200% browser zoom; use `rem` for font sizes.

## Voice And Tone

Voice is stable — it does not change with context. Tone is calibrated per situation.

Voice principles:

- **Direct, not harsh.** Get to the point without filler or needless technical
  jargon, but stay human.
- **Clear, not condescending.** Use language anyone understands without treating the
  user as if they know nothing.
- **Helpful, not vague.** Offer the next step whenever possible; never only name the
  problem. "File too large. The limit is 10 MB — compress it or use another format."
  beats "Invalid file."

Tone by context:

| Situation | Tone |
|-----------|------|
| Onboarding / welcome | Welcoming, encouraging |
| Action completed | Positive, concise |
| Recoverable error | Calm, instructive |
| Critical error / possible data loss | Transparent, empathetic |
| Destructive action | Neutral, precise about consequence |
| Empty state | Motivating, instructional |
| Loading / processing | Informative |
| Tooltip / contextual help | Plain, jargon-free |

Address the user directly and consistently in the second person; never refer to the
user in the third person, and never mix address forms within a product.

Avoid: blaming the user; passive-aggressive phrasing; exposed technical jargon
("timeout", "null pointer", HTTP codes); excessive exclamation; unnecessary
negativity ("Unfortunately…"); messages longer than two sentences without real need.

## Writing Requirements

Interface copy should be direct, clear, and useful.

- Use action labels that describe the result: "Create project", not "Submit".
- Buttons and CTAs use sentence case and no final period.
- Titles, labels, and placeholders use no final period.
- Complete helper, error, and confirmation messages use a final period.
- Ellipsis only in loading states: "Loading…", "Saving…".
- Error messages explain what happened and, when possible, the next step.
- Destructive actions are precise about consequence and reversibility.
- Empty states explain what is missing and offer the next useful action.
- Loading states name the operation when it may take more than a moment.
- Avoid technical errors in user-facing copy unless the user needs the detail to fix the
  issue.
- Links and buttons make sense out of context; avoid "click here".
- Prefer short sentences, one idea each; active voice; no double negatives.
- Alternative texts describe function, not appearance: "Warning icon: irreversible
  action", not "Yellow triangle".

Use the language of the product and user. If the product is in Portuguese, write UI copy in
Portuguese consistently. If it is in English, write in English consistently. Do not mix
languages without a product reason. Apply the target language's own conventions for
capitalization, numbers, and loanwords consistently.

## Interaction States

All interactive components must account for relevant states:

- Default.
- Hover, when pointer input applies.
- Focus.
- Active/pressed.
- Loading or pending.
- Success or completion feedback.
- Error or validation feedback.
- Disabled, with the reason clear when the user can act on it.
- Empty state for lists, dashboards, search results, uploads, and generated content.

State changes should be visible, accessible, and stable. Loading or error text must not
resize controls in a way that shifts the main layout unexpectedly.

## Layout And Responsiveness

Layouts should prioritize the user's task over decoration.

- Use the spacing scale for all gaps: 8–16px inside components, 32–48px between
  sections.
- Use stable responsive constraints for fixed-format elements such as boards, grids,
  sidebars, toolbars, and counters.
- Keep content readable on mobile without horizontal scrolling.
- Keep primary actions close to the content they affect.
- Use cards only for repeated items, modals, and genuinely framed tools.
- Do not put cards inside other cards.
- Avoid purely decorative backgrounds or visual effects that reduce scanability.
- Make text fit within its container on desktop and mobile.
- Preserve enough whitespace for comprehension, but do not make operational tools feel
  like marketing pages.

## Motion

Motion should be functional and restrained: it orients the eye, communicates state,
confirms action, or creates continuity. The user should notice the result, not the
animation.

- Hover/focus/click feedback: `motion-instant` (100ms), default easing.
- Component state changes: `motion-fast` (200ms).
- Common transitions: `motion-normal` (300ms).
- Modal, drawer, or screen entry: up to `motion-slow` (500ms).
- Entries decelerate (fade in + small translate, e.g. 8px up); exits accelerate and
  are faster than entries (fade out + small translate, 200ms).
- Success/error feedback: fade in with slight scale (0.9 → 1), fast and decelerating.
- Loading skeletons: a subtle linear shimmer (~1.5s) is the one acceptable loop.
- Respect `prefers-reduced-motion`; reduce or remove non-essential animation.

Avoid: bounce or spring on functional elements; durations above 600ms for routine
interactions; looping animations that do not communicate active loading or processing;
heavy parallax on content pages; linear easing for elements that move (it reads as
mechanical).

## Build Expectations

During build, UI implementation follows the approved `design-brief.md` and this baseline.
If the design brief conflicts with this baseline, the baseline wins for accessibility,
state coverage, and usability. Visual choices such as color, density, and typography can
vary by project; when the design brief confirms the default tokens, implement them as
specified in Default UI Tokens.

## QA Expectations

Build-QA should validate observable UI requirements when a browser or UI harness is
available:

- Main flows match the spec and design brief.
- Interactive controls expose labels, focus states, and expected keyboard behavior.
- Error, loading, success, disabled, and empty states are exercised when test data allows.
- Text is readable and does not overlap or overflow at desktop and mobile widths.
- Primary color and project tokens are applied consistently and accessibly.
- Motion does not block use and respects reduced-motion where practical to verify.
- When tooling is available, prefer evidence from an automated accessibility audit
  (e.g. axe) and manual keyboard navigation over visual inspection alone.
