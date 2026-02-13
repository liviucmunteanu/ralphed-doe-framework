# AGENTS Context: Archive

> **Purpose**: Completed automations are archived here after all tasks pass, post-mortems are generated, and `[NEEDS VERIFICATION]` flags are resolved. Each subfolder is a date-stamped snapshot of a completed automation.

## Contents

Currently empty — no automations have been archived yet. (`.gitkeep` is present to preserve the directory in version control.)

## Naming Convention

Archive folders are date-stamped: `YYYY-MM-DD-{id}-{name}/`

Example: `2026-02-15-001-competitor-research/`

## What's Inside Each Archive Folder

- `{name}-spec.json` — Final task spec with all tasks `passes: true` and `qualityEvidence` recorded
- `{name}-progress.txt` — Complete progress log with Codebase Patterns and per-task learnings
- `{name}-post-mortem.md` — Post-mortem analysis (what worked, what didn't, metrics, recommendations)
- `AGENTS.md` — The automation's context file at time of completion
- `directives/` — Workflow-specific directives (moved from `00-Directives/{id}-{name}/`)
- `execution/` — Workflow-specific scripts/tools (moved from `00-Execution/{id}-{name}/`)

## How Archives Are Used

- **Learning across automations**: Read post-mortems from previous automations to avoid repeating mistakes
- **Promoting tools**: If a workflow-specific script in `execution/` proves broadly useful, promote it to the generic `00-Execution/` folder
- **Auditing**: Archives provide a complete trail from PRD → spec → progress → post-mortem

## "Watch Out" Warnings

- Archives are read-only — do not modify archived automations
- The corresponding PRD remains in `00-PRDs/{id}-{name}/` (it is NOT moved into the archive)
- Review files in `00-Reviews/{id}-{name}/` are cleaned up during archiving, not preserved
- If an automation needs to be re-opened, copy it back out of the archive to `00-Automations/` — don't edit in place
