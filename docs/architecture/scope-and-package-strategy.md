# Scope and IBM Bob Premium Package Strategy

## Current project scope

The Agentic Mainframe Modernization Framework is methodologically portable, but the **current book, reference implementation, experiments, and evidence are intentionally focused on IBM Z**.

The primary product execution layer is:

**IBM Bob Premium Package for Z (PP4Z)**

The canonical reference estate is:

**AtlasPay — COBOL, CICS, Db2, VSAM, JCL, and MQ**

## Other IBM Bob Premium Packages

IBM also offers Premium Packages for other modernization domains, including IBM i and Java modernization. Those packages reinforce that the broader Agentic Strangler concepts may be applicable beyond IBM Z.

They are **acknowledged but out of scope for the current implementation**.

This repository does not currently provide:

- IBM i-specific playbooks or experiments;
- Java-modernization playbooks or experiments;
- package-specific capability mappings for IBM i or Java;
- benchmark claims for those packages.

## Why keep the implementation Z-focused

The book is about mainframe modernization and needs depth more than breadth. PP4Z, Z Understand, and AtlasPay provide a coherent implementation surface for testing the full lifecycle with real platform-specific capabilities and measurable evidence.

Expanding into IBM i and Java now would dilute the core narrative, multiply product-specific verification work, and risk turning one modernization framework into several partially explored implementations.

## Portability rule

The framework core should avoid unnecessary IBM Z assumptions where practical:

- lifecycle stages remain product-neutral;
- evidence contracts remain product-neutral;
- human gates remain product-neutral;
- evaluation concepts remain product-neutral;
- platform-specific execution details remain in integration layers.

This means future implementations may map the same framework contracts to other IBM Bob Premium Packages or other modernization products without changing the core methodology.

## Canonical statement

> **Project Bob is Z-focused in implementation, portable in methodology.**

For the current book and repository:

> **IBM Bob Premium Package for Z is the primary execution engine; Agentic Strangler is the evidence-driven modernization discipline that governs and evaluates how those capabilities are used.**
