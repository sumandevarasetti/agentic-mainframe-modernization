# The Agentic Strangler

**Framework version:** 0.1.0  
**Status:** Canonical public definition  
**Companion book:** *Project Bob — Accelerating Mainframe Modernization with Agentic AI*

## Relationship to Project Strangler

The architectural lifecycle is:

**Observe → Encapsulate → Extract → Redirect → Retire**

The Agentic Strangler does not replace it. It adds a human-governed execution loop:

# UNDERSTAND → DECIDE → PLAN → TRANSFORM → PROVE → SHIFT → LEARN

The architectural lifecycle describes **how the legacy footprint evolves**. The Agentic Strangler describes **how a human-agent engineering system executes each safe modernization increment**.

## Phrase originality

This repository does **not** claim that the phrase "Agentic Strangler" was coined here. The contribution is the specific mainframe-oriented lifecycle, evidence model, human authority model, reusable workflow structure, and reference implementation.

## Core thesis

> The defining contribution of agentic AI to mainframe modernization is not automatic code generation. It is the ability to compress the cycle from understanding a legacy capability to making, proving, and safely introducing a modernization decision.

## Operating rules

1. **No Evidence, No Progression.**
2. **Agents perform work. Humans retain authority.**
3. **Agent autonomy should generally decrease as irreversibility increases.**
4. **Modernization is decision-first, not generation-first.**
5. **KEEP is a valid modernization decision.**
6. **Production progression is evidence-driven, not schedule-driven.**
7. **LEARN turns one increment into reusable knowledge for the next.**

---

# 1. UNDERSTAND

**Definition:** Construct an evidence-linked model of a legacy capability that is sufficiently complete to reason about changing it without relying primarily on undocumented assumptions.

**Question:** What actually implements this capability, and what might be affected if it changes?

**Agent contribution:** inventory artifacts, build dependency graphs, trace data, explain programs, recover business rules, identify exceptions, surface missing evidence, generate SME questions.

**Human authority:** validate ambiguous semantics, regulatory intent, historical rationale, policy meaning, and conflicting evidence.

**Required evidence:** Current-State Evidence Pack containing capability definition, artifacts, dependencies, rules, data/runtime relationships, exceptions, known unknowns, tests, and source references.

**Exit gate:** decision-grade understanding plus explicit known unknowns.

**Failure mode:** code comprehension mistaken for application understanding.

---

# 2. DECIDE

**Definition:** Explicitly select what should happen to a capability based on business value, architecture, risk, operations, and the evidence produced during understanding.

**Question:** Should we change this capability at all—and if so, how?

**Allowed dispositions:** KEEP, REFACTOR, EXPOSE, EXTRACT, TRANSFORM, REPLATFORM, RETIRE.

**Agent contribution:** compare options, estimate blast radius, identify seams, surface risks, recommend a disposition, explain rejected alternatives.

**Human authority:** the final modernization decision belongs to a human.

**Required evidence:** Modernization Decision Record.

**Exit gate:** named human accepts a specific disposition.

**Failure mode:** transformation bias.

---

# 3. PLAN

**Definition:** Convert an approved disposition into a bounded, executable sequence of changes with explicit dependencies, validation requirements, rollback paths, and human approval points.

**Question:** Exactly what will change, in what order, and how will we know whether each step succeeded?

**Required evidence:** Modernization Execution Plan with scope, non-scope, sequence, proof strategy, rollback strategy, gates, and exit criteria.

**Human authority:** approve architecture compatibility, sequencing, risk, operational feasibility, rollback realism, and scope.

**Failure mode:** agentic scope creep.

---

# 4. TRANSFORM

**Definition:** Controlled execution of the approved plan while preserving traceability to evidence, decision, and plan.

**Question:** Can we implement the approved change without exceeding the approved boundary?

**Possible outcomes:** refactor, expose, extract, transform, replatform, event-enable, create adapters, prepare retirement.

**Required evidence:** Traceable Change Set: Objective → Evidence → Decision → Plan → Change.

**Human authority:** consequential design/code acceptance and any scope expansion.

**Failure mode:** successful generation mistaken for successful modernization.

---

# 5. PROVE

**Definition:** Accumulate objective evidence demonstrating that the transformed capability satisfies intended behavior and required nonfunctional constraints without unacceptable risk.

**Question:** What evidence gives justified confidence that the new path can replace or augment the old path?

**Required evidence:** Modernization Proof Package covering traceability, behavioral comparison, tests, static analysis, performance, security/compliance, expected differences, unexplained differences, residual risk, and approvals.

**Human authority:** determine evidence sufficiency and accept residual risk.

**Failure mode:** proof by plausibility.

---

# 6. SHIFT

**Definition:** Controlled transfer of production traffic, responsibility, or workload toward the approved modernized path using predefined telemetry, thresholds, and rollback.

**Question:** Can production responsibility move safely based on measured evidence rather than schedule pressure?

**Required evidence:** Shift Record.

**Human authority:** authorize production exposure, material exposure increases, discrepancy acceptance, full cutover, and retirement eligibility.

**Failure mode:** schedule-driven cutover.

---

# 7. LEARN

**Definition:** Deliberately convert modernization outcomes into updated knowledge, evidence, tests, agent context, architecture guidance, and portfolio priorities.

**Question:** What did this modernization teach us that should make the next decision safer or faster?

**Required evidence:** Knowledge Delta.

**Human authority:** validate material changes to domain meaning, policy, architecture guidance, and risk thresholds.

**Failure mode:** throwaway modernization knowledge.

---

# No Evidence, No Progression

```text
UNDERSTAND
   ↓ evidence
DECIDE
   ↓ authorization
PLAN
   ↓ bounded execution contract
TRANSFORM
   ↓ candidate change
PROVE
   ↓ justified confidence
SHIFT
   ↓ production evidence
LEARN
   ↓ reusable knowledge
UNDERSTAND
```

# Human authority and irreversibility

> **Agent autonomy should generally decrease as irreversibility increases.**

```text
MORE REVERSIBLE                                            LESS REVERSIBLE
─────────────────────────────────────────────────────────────────────────>
Analyze → Recommend → Generate → Test → Deploy → Shift → Retire
```

# Automated Rewrite vs. Agentic Strangler

| Automated Rewrite | Agentic Strangler |
|---|---|
| Starts with code | Starts with understanding |
| Assumes transformation | Decides whether transformation is appropriate |
| Optimizes generation | Optimizes modernization outcome |
| Often language-centric | Capability-centric |
| One-shot | Incremental learning loop |
| Validation after generation | Evidence throughout |
| Human review late | Human authority at consequential gates |
| Tool-centric | Methodology-centric |

> Automated rewriting asks, “How quickly can we convert this code?” The Agentic Strangler asks, “What should change, why, how little can we safely change, and what evidence would justify that change?”

# KEEP is a valid outcome

A modernization system must be able to recommend **KEEP** when a capability is stable, understood, economical, performant, and not strategically constraining the enterprise.

# Related assets

- [Human Gates](../governance/human-gates.yaml)
- [Full Agentic Strangler Workflow](../workflows/full-agentic-strangler/)
- [AtlasPay Chapter 3 Example](../examples/atlaspay/modernization/chapter-03/)
- [Book Mapping](book-mapping.md)
