# Known Unknowns Prompt

**Framework stage:** UNDERSTAND  
**Version:** 0.3.0  
**Status:** Portable prompt pattern  
**Default permissions:** Read-only

## Purpose

Force explicit uncertainty accounting before the framework can progress to DECIDE.

## Prompt

Review the current capability analysis for:

`{{CAPABILITY}}`

Do not add new assumptions merely to make the analysis look complete.

Identify:

1. facts that are proven by available artifacts;
2. conclusions that are strongly supported but not fully proven;
3. hypotheses that still require validation;
4. dependencies that may exist outside the workspace;
5. runtime behavior not observable from static artifacts;
6. business intent that source code cannot establish;
7. operational, security, regulatory, or performance questions that remain unresolved;
8. the minimum additional evidence needed to resolve each important unknown.

## Required output

| Unknown ID | Question / uncertainty | Why it matters | Current evidence | Missing evidence | Risk if wrong | Suggested validator |
|---|---|---|---|---|---|---|

Then provide:

- blockers to decision-grade understanding;
- non-blocking unknowns;
- recommended SME interviews or runtime observations;
- explicit statement whether the capability is ready to enter DECIDE.

## Rule

Confidence without documented unknowns is not sufficient for stage exit.
