# AGENTS Context: Generic Directives

> **Purpose**: This folder contains the three generic (shared) directives that form the core automation workflow. Workflow-specific directives live in subfolders named `{id}-{name}/`.

## Contents

- `01-create-automation-prd.md` — **Step 1**: Clarify requirements, ask domain-specific and cross-domain questions (delivery channel, boundaries), generate a PRD with verifiable acceptance criteria, get user approval
- `02-automation-prd-json.md` — **Step 2**: Check for existing automations to archive, convert approved PRD to `{name}-spec.json` (including `commitConvention` and `deliveryChannel` fields), create folder structure, initialize progress and AGENTS.md files
- `03-run-ralphed-doe-automation.md` — **Step 3**: Execute tasks agentically — read patterns first, run pre-flight validation (including feedback loop check), execute one task at a time, run quality checks + pre-completion checklists, log quality evidence, handle review gates with status communication, archive with date stamps

## Relationships

- Directives reference templates in `00-Templates/` (task-spec, post-mortem, quality checks)
- Directives reference quality standards in `AGENTS-Instructions-AgenticWorkflows.md` (verifiable acceptance criteria, pre-completion checklists, feedback loops)
- Step 3 creates deliverables in `00-Reviews/` for tasks requiring human review

## "Watch Out" Warnings

- Always run directives in order (01 → 02 → 03). Never skip Step 1 (PRD creation) — it ensures requirements are clear before execution.
- Step 1 now includes a **criteria quality verification step** (Step 3 in the directive) — don't skip it. Vague criteria are the #1 cause of tasks failing quality checks.
- Step 2 now checks for existing automations before creating a new one — completed automations should be archived first.
- Step 3's progress log format includes Status, Iteration, and Quality Evidence fields — older progress files may not have these. Add them when resuming.
- All three directives support 6 domains: coding, research, writing, documentation, analysis, other.
