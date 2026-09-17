---
name: ui-product-design
description: Shape, build, inspect, critique, and polish product-specific UI/UX. Activate for any new page, screen, flow, component system, dashboard, landing page, onboarding, navigation, form, or material visual redesign.
---

# UI / Product Design Operating System

Do not generate a generic interface directly from the feature request. First understand the product, user, job-to-be-done, information hierarchy, operating context, and existing design language. Then shape the experience. Only then implement.

## Required pipeline

For a new surface or meaningful redesign:

1. **Product context**
   - Read canonical product/spec/context documents before UI code.
   - Identify the primary user, job-to-be-done, primary action, information hierarchy, navigation model, density, and important states.
   - Infer from repository evidence before asking the user for information already documented.

2. **Shape before build**
   - Use Impeccable's shape/craft workflow when available.
   - Decide a small design contract before coding: visual thesis, typography roles, spacing rhythm, surface/elevation strategy, radii, color roles, icon language, interaction states, motion principles, and responsive behavior.
   - Reuse the current design system when one exists. Never silently invent a competing visual language.

3. **Source components deliberately**
   - Prefer existing project primitives first.
   - Then use shadcn-compatible primitives/blocks and 21st.dev discovery when useful.
   - Component catalogs are implementation material, not art directors. Do not assemble unrelated attractive components into a collage.
   - Hand-write a focused component when sourcing one would make the product less coherent.

4. **Purposeful motion**
   - Motion must communicate hierarchy, continuity, causality, state change, or feedback.
   - Prefer subtle transitions over constant movement.
   - Respect `prefers-reduced-motion`.
   - Never make important content depend on animation completion.

5. **Rendered visual iteration is mandatory**
   - Run the real application and inspect the rendered UI in a browser.
   - Use Playwright/browser tooling when available.
   - Verify the primary desktop viewport and a relevant narrow/mobile viewport for responsive web UI.
   - Inspect the states the feature actually has: loading, empty, error, hover/focus, selected, disabled, success.
   - Do not approve UI by reading JSX/CSS alone.

6. **Critique, detect, polish**
   - Use Impeccable critique/audit/polish where appropriate.
   - Run `npx impeccable detect` on the changed UI surface when Impeccable is available.
   - Apply the `web-design-guidelines` skill to the changed UI before completion.
   - Resolve material UX findings before marking the task done.

7. **Accessibility is correctness**
   - Core flows must work with keyboard only.
   - Prefer semantic HTML to ARIA.
   - Focus must be visible, logical, and correctly managed in overlays/dialogs/menus.
   - Labels and accessible names must be explicit.
   - Do not encode meaning with color alone.
   - Preserve logical heading and reading order.
   - Respect reduced motion.
   - For accessibility-critical flows, include manual screen-reader/NVDA verification when practical.

## Anti-generic / anti-AI rules

Avoid these unless product context explicitly justifies them:

- automatic purple/blue gradients;
- glassmorphism as default styling;
- ubiquitous Inter or another default AI-template font without reason;
- cards inside cards inside cards;
- rounded icon tiles above every heading;
- excessive pills, shadows, borders, and floating containers;
- automatic four-metric dashboard grids;
- dashboard layouts for products that are not naturally dashboards;
- decorative charts with no decision value;
- huge marketing-style headings inside operational app screens;
- excessive center alignment;
- placeholder marketing copy;
- identical visual emphasis for primary and secondary actions;
- microinteractions that slow routine work;
- visual novelty that harms comprehension.

The interface must look specific to the product, not specific to an AI template.

## Tool roles

- **Impeccable:** design reasoning, shaping, anti-generic detection, critique, audit, polish.
- **shadcn MCP/registry:** primitives, blocks, registry search, implementation infrastructure.
- **21st.dev skills:** exploration, component discovery, implementation references, build/review workflows.
- **Playwright/browser tooling:** rendered verification and interaction checks.
- **web-design-guidelines:** final web UX/accessibility quality review.
- **Context7:** current library/API documentation when implementation details are uncertain.

Do not install or invoke Anthropic `frontend-design` as a second design authority when Impeccable is active unless the repository explicitly requires it. Motion Primitives, React Bits, Magic UI, and similar libraries are optional sources, not default dependencies.

## Scope proportionality

For a tiny visual fix, preserve the existing design contract, render the changed state, and run only the relevant checks. Do not trigger a redesign.

For a new page/surface or major redesign, the full sequence is mandatory:

`context -> shape -> design contract -> build -> browser inspect -> critique/detect -> polish -> guidelines review`

## Completion gate

A material UI/UX task is complete only when:

- product intent is visible in the hierarchy;
- one coherent visual language is used;
- important states exist;
- responsive behavior is verified when applicable;
- keyboard/focus behavior is correct;
- the rendered UI has been visually inspected;
- obvious generic-AI design tells are removed;
- material critique/audit findings are resolved;
- required build/tests pass.

If browser or design tooling is unavailable, state that explicitly. Never claim visual verification that did not happen.
