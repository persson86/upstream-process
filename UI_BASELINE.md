# UI Baseline

This is the default UI/UX quality baseline for sdd-lite projects. It is product-neutral:
it defines minimum interaction, accessibility, writing, and visual quality rules, but it
does not define a brand identity.

Projects may override visual choices such as primary color, typeface, density, and tone in
their `design-brief.md`. Overrides must still preserve the baseline requirements for
accessibility, usability, responsive behavior, and state coverage.

## Design Brief Contract

For any feature with a user interface, `spec-design` writes a project-specific
`design-brief.md`. That file is the handoff from upstream to downstream UI work.

The design brief must include:

- Product context and audience.
- Visual direction: tone, color approach, typography style, density, and feel goal.
- Project UI tokens: at minimum primary color, neutral surface/background, text color,
  border color, success/warning/error colors, radius scale, spacing scale, and motion
  durations.
- Screen map and primary flows.
- Interaction patterns for forms, navigation, feedback, empty states, loading states,
  and destructive actions.
- Component guidance for data display, inputs, actions, layout, and responsive behavior.
- Accessibility notes and any assumptions that need user review before build.

## Project Customization

The default project should choose its own visual identity. Do not inherit colors, fonts,
or brand voice from the framework repository.

Recommended token starting point:

- `primary`: project-specific action color.
- `background`: page background.
- `surface`: cards, panels, and secondary containers.
- `text`: primary readable text.
- `muted`: secondary text.
- `border`: separators and input borders.
- `success`, `warning`, `error`, `info`: feedback-only colors.
- `radius-sm`, `radius-md`, `radius-lg`: component radius scale.
- `space-1` through `space-8`: spacing scale based on consistent increments.
- `motion-fast`, `motion-normal`, `motion-slow`: transition durations.

When the user requests a specific color or brand feel, record that in the design brief and
derive accessible supporting colors from it. Never use a requested color in a way that
breaks contrast, focus visibility, or error readability.

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
- Touch targets are at least 44 by 44 CSS pixels, with enough spacing to avoid accidental
  taps.
- Status changes that do not move focus are announced with appropriate live regions.
- The interface remains usable at 200% browser zoom.

## Writing Requirements

Interface copy should be direct, clear, and useful.

- Use action labels that describe the result: "Create project", not "Submit".
- Buttons and CTAs use sentence case and no final period.
- Titles, labels, and placeholders use no final period.
- Complete helper, error, and confirmation messages use a final period.
- Error messages explain what happened and, when possible, the next step.
- Destructive actions are precise about consequence and reversibility.
- Empty states explain what is missing and offer the next useful action.
- Loading states name the operation when it may take more than a moment.
- Avoid technical errors in user-facing copy unless the user needs the detail to fix the
  issue.
- Links and buttons make sense out of context; avoid "click here".

Use the language of the product and user. If the product is in Portuguese, write UI copy in
Portuguese consistently. If it is in English, write in English consistently. Do not mix
languages without a product reason.

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

Motion should be functional and restrained.

- Use motion to communicate continuity, state, feedback, or spatial relationship.
- Avoid decorative motion that competes with the user's task.
- Use short durations for routine interactions: about 100ms for hover/focus, 200ms for
  component state changes, 300ms for common transitions, and up to 500ms for modal or
  screen entry.
- Exits are faster than entries.
- Respect `prefers-reduced-motion`; reduce or remove non-essential animation.
- Avoid looping animations unless they communicate an active loading or processing state.

## Build Expectations

During build, UI implementation follows the approved `design-brief.md` and this baseline.
If the design brief conflicts with this baseline, the baseline wins for accessibility,
state coverage, and usability. Visual choices such as color, density, and typography can
vary by project.

## QA Expectations

Build-QA should validate observable UI requirements when a browser or UI harness is
available:

- Main flows match the spec and design brief.
- Interactive controls expose labels, focus states, and expected keyboard behavior.
- Error, loading, success, disabled, and empty states are exercised when test data allows.
- Text is readable and does not overlap or overflow at desktop and mobile widths.
- Primary color and project tokens are applied consistently and accessibly.
- Motion does not block use and respects reduced-motion where practical to verify.
