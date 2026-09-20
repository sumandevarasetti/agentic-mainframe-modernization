# AtlasPay Evaluation

AtlasPay has intentionally known ground truth so UNDERSTAND-stage prompts, playbooks, agents, and product integrations can be evaluated objectively.

Primary files:

- `ground-truth.yaml`
- `understand-eval.yaml`

Formal scored runs:

- `runs/run-001/evaluation.md`
- `runs/run-001/artifact-manifest.yaml`

Do not feed the ground-truth file into the analysis being evaluated. It is the answer key.

## Holdout status

Run 001 was frozen before the answer key was opened. After that evaluation, AtlasPay is no longer a clean blind holdout for this project.

Future AtlasPay executions should be labeled **regression tests**.

Use AWS CardDemo or another held-out estate for independent validation of framework refinements.
