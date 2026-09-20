# Known Unknowns Prompt

**Framework stage:** UNDERSTAND  
**Version:** 0.3.4  
**Status:** Portable prompt pattern  
**Default permissions:** Read-only

## Purpose

Force explicit uncertainty accounting before the framework can progress to DECIDE.

A useful Known Unknowns analysis must identify both:

1. **application-local unknowns** — missing source, ambiguous behavior, conflicting tests, external dependencies; and
2. **evidence-boundary unknowns** — entire classes of real-world evidence that the available workspace cannot establish.

## Prompt

Review the current capability analysis for:

`{{CAPABILITY}}`

Do not add assumptions merely to make the analysis look complete. Do not infer production behavior from static source alone.

First classify what is:

1. proven by available artifacts;
2. strongly supported but not fully proven;
3. unresolved and requiring additional evidence.

Then perform an explicit uncertainty sweep across **every** category below, even when the answer is "no evidence available":

1. missing source code or missing implementation;
2. external-system contracts and behavior;
3. runtime behavior not observable from static artifacts;
4. performance, scale, latency, throughput, capacity, and concurrency;
5. resilience, operability, recovery, timeout, retry, and failure modes;
6. security and production operational controls;
7. regulatory, card-network, contractual, or external business-policy requirements;
8. build, compiler, link, deployment, runtime, middleware, and platform assumptions;
9. production data, configuration, topology, and runtime state;
10. business intent that code cannot establish;
11. conflicting or ambiguous test/specification evidence;
12. dependencies that may exist outside the workspace.

For each important unknown, identify the **minimum additional evidence** required to resolve it.

## Required output

| Unknown ID | Category | Question / uncertainty | Why it matters | Current evidence | Missing evidence | Risk if wrong | Suggested validator | Blocks stage exit? |
|---|---|---|---|---|---|---|---|---|

Then provide:

- blockers to decision-grade understanding;
- non-blocking unknowns;
- evidence-boundary limitations that apply to the whole analysis;
- recommended SME interviews, runtime observations, external documents, missing source, or tests;
- explicit statement whether the capability is ready to enter DECIDE.

## Rules

- Confidence without documented unknowns is not sufficient for stage exit.
- A static workspace cannot prove production runtime behavior merely because no contradiction is visible.
- Do not treat absence of evidence as evidence that a concern does not exist.
- Do not use evaluator ground truth during a scored run.
