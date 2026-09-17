# SME Question Generator

**Framework stage:** UNDERSTAND  
**Version:** 0.3.0  
**Status:** Portable prompt pattern

## Purpose

Generate a small set of high-value SME questions from unresolved evidence gaps.

## Prompt

Using the current capability analysis and known-unknown register for:

`{{CAPABILITY}}`

Generate only questions whose answers could materially affect modernization decisioning, proof requirements, or risk.

For each question:

1. state the unresolved issue;
2. cite the evidence gap that triggered the question;
3. identify the best SME role to answer it;
4. explain what decision could change based on the answer;
5. prioritize as `critical`, `high`, `medium`, or `low`.

Avoid questions that can already be answered from repository evidence.

## Required output

| Priority | Question | Evidence gap | Suggested SME | Decision/risk affected |
|---|---|---|---|---|

Finish with the **top five questions to answer before DECIDE**.
