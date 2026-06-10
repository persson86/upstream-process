# Design Brief: <short title>

## Origin

- Spec: `spec.md`
- UI Baseline: `sdd-lite/UI_BASELINE.md`
- Date:
- Features covered:

## Product Context

- Audience:
- Primary job:
- Usage context:

## Visual Direction

**Tone:** <minimal | bold | warm | data-dense | editorial | utilitarian>

**Color approach:** <light/dark default, project primary color, accent rationale, neutral palette>

**Typography style:** <precise/technical | readable/friendly | display-forward>

**Density:** <compact | balanced | spacious>

**Feel goal:** <One sentence: what the user should feel after 5 seconds on the screen.>

## Project UI Tokens

Start from the Default UI Tokens in `sdd-lite/UI_BASELINE.md`. State per token
group whether the project confirms the default or overrides it. Overrides must
preserve the accessibility and usability rules in `sdd-lite/UI_BASELINE.md`.

- **Token source:** <baseline defaults | overridden per Visual Reference — list overrides>
- **Primary:** <hex/color token and usage>
- **Background:** <hex/color token>
- **Surface:** <hex/color token>
- **Text:** <hex/color token>
- **Muted text:** <hex/color token>
- **Border:** <hex/color token>
- **Feedback:** success <token>, warning <token>, error <token>, info <token>
- **Radius:** <small/medium/large scale>
- **Spacing:** <spacing scale or rhythm>
- **Motion:** <fast/normal/slow duration choices>

## Screen Map

| Screen | Purpose |
|--------|---------|
| <name> | <one-line purpose> |
| <name> | <one-line purpose> |

## Primary Flows

### Flow 1: <user story or use case name>

1. <Screen name> — <what user does>
2. <Screen name> — <what user does>
3. <Screen name> — <outcome>

### Flow 2: <user story or use case name>

1. <Screen name> — <what user does>
2. <Screen name> — <outcome>

## Key Interaction Patterns

**Forms:** <inline vs modal, validation style, submit feedback>

**Navigation:** <tabs | sidebar | breadcrumbs | flat>

**Feedback and errors:** <toast | inline | blocking modal>

**Empty and loading states:** <pattern description>

**Destructive actions:** <confirmation, copy, undo/recovery behavior>

## Component Guidance

**Data display:** <table | cards | list — and why>

**Input:** <single form | wizard | inline editing — and why>

**Actions:** <primary CTA placement, destructive confirmation approach>

**Layout:** <single column | split panel | dashboard grid — and why>

**Responsive behavior:** <mobile/tablet/desktop behavior and constraints>

## Accessibility And UI Quality

- **Contrast:** <how primary/text/surface choices satisfy contrast>
- **Keyboard/focus:** <focus order, modal behavior, shortcuts if any>
- **Labels and errors:** <field labels, required fields, validation copy>
- **Touch targets:** <target sizing and mobile spacing>
- **Reduced motion:** <how motion is reduced or removed>
- **State coverage:** <default, hover, focus, loading, success, error, disabled, empty>

## Writing And Microcopy

- **Language:** <product language and consistency rule>
- **Tone calibration:** <key contexts and tone, per the Voice And Tone table in `sdd-lite/UI_BASELINE.md`>
- **CTA style:** <verb/result pattern for primary actions>
- **Error style:** <tone and next-step pattern>
- **Empty-state style:** <what empty states should say and offer>

## Assumptions

Decisions not directly derivable from the proposal or spec. Review and adjust before `@build`.

- **Assumption:** <decision> — <why this was chosen; impact if different direction preferred>.
- **Assumption:** <decision> — <why this was chosen; impact if different direction preferred>.
