# AGENTS Context: Templates

> **Purpose**: Reusable templates used during automation creation and execution. These are referenced by the directives in `00-Directives/` — do not modify templates without understanding their downstream consumers.

## Contents

- `task-spec.template.json` — Template for `{name}-spec.json` files. Used by `02-automation-prd-json.md` (Step 2) when converting a PRD to a task spec. Includes all required fields: `commitConvention`, `deliveryChannel`, task-level `qualityEvidence`, `rollbackStrategy`, etc.
- `loop-script.template.sh` — Template for external orchestration loop scripts. Optional — the framework's default mode is agentic orchestration (no loop script needed), but this is available for external-tool-driven execution.
- `post-mortem.template.md` — Template for automation post-mortems. Used by `03-run-ralphed-doe-automation.md` (Step 3) when archiving completed automations. Covers: what was delivered, what went well/wrong, key learnings, metrics, and recommendations.
- `quality-checks/` — Domain-specific quality check definitions in JSON format. See `quality-checks/AGENTS.md` for details.

## Relationships

- `task-spec.template.json` → consumed by `00-Directives/02-automation-prd-json.md`
- `post-mortem.template.md` → consumed by `00-Directives/03-run-ralphed-doe-automation.md`
- `quality-checks/*.json` → consumed by `00-Directives/03-run-ralphed-doe-automation.md` during task execution

## "Watch Out" Warnings

- Changes to `task-spec.template.json` affect all future automations — ensure new fields are also documented in `AGENTS-Instructions-AgenticWorkflows.md` (Task Specification Format section)
- The `quality-checks/` folder must have a file for every supported domain plus `universal.json`
- `loop-script.template.sh` is a legacy convenience — the framework's primary mode is agentic orchestration without external scripts
