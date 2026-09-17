# Understanding Agent

The Understanding Agent is the read-only orchestrator for the UNDERSTAND stage of the Agentic Strangler.

It coordinates discovery, dependency analysis, business-rule recovery, known-unknown detection, and SME-question generation to produce a **Current-State Evidence Pack**.

It does **not** select a modernization disposition and does not modify source.

This is a portable framework definition, not IBM Bob-native agent syntax.

See `agent.yaml` and the AtlasPay runbook under `../../examples/atlaspay/modernization/understand/`.
