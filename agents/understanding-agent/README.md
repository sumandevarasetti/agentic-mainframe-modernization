# Understanding Agent

The Understanding Agent is the **framework-level read-only orchestrator** for the UNDERSTAND stage of the Agentic Strangler.

It does not replace IBM Bob Premium Package for Z modes, skills, workflows, tools, or Z Understand. On IBM Z, it maps framework playbooks to verified native PP4Z capabilities and adapts the resulting evidence into a Current-State Evidence Pack.

Its responsibilities are:

- coordinate Discovery, Dependency Analysis and Rule Extraction playbooks;
- prefer verified native PP4Z capabilities where available;
- invoke supplemental prompts only for missing evidence or normalization;
- preserve uncertainty and known unknowns;
- produce the Current-State Evidence Pack;
- prevent progression to DECIDE until human validation is complete.

It does **not** select a modernization disposition and does not modify application source.

`agent.yaml` is a portable framework contract, not IBM Bob-native agent syntax.
