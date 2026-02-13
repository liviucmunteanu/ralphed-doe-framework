# AGENTS Context: Automations

> **Purpose**: This folder contains active automation workspaces. Each subfolder `{id}-{name}/` is one automation with its spec, progress log, and context. Completed automations are archived in `00-Archive/`.

## Contents

- `00-Archive/` — Completed automations with post-mortems (date-stamped: `YYYY-MM-DD-{id}-{name}/`)
- Active automation subfolders (none currently active)

## High-Level Architecture

- Each automation: `{id}-{name}/` with `{name}-spec.json`, `{name}-progress.txt`, `AGENTS.md`
- Related directives: `00-Directives/{id}-{name}/`
- Related execution tools: `00-Execution/{id}-{name}/`
- Related PRD: `00-PRDs/{id}-{name}/`
- When archiving: directives and execution subfolders move INTO the archive alongside the spec and progress

## Naming Convention

- ID: 3-digit zero-padded (001, 002, etc.)
- Name: Descriptive, max 3-4 words, kebab-case
- `{name}` = the kebab-case part without numeric prefix (e.g., `001-feature-auth` → `{name}` = `feature-auth`)

## Lifecycle

1. Created by `00-Directives/02-automation-prd-json.md` (Step 2)
2. Executed by `00-Directives/03-run-ralphed-doe-automation.md` (Step 3)
3. Archived to `00-Archive/YYYY-MM-DD-{id}-{name}/` after all tasks pass, post-mortem is generated, and `[NEEDS VERIFICATION]` flags are resolved

## "Watch Out" Warnings

- Always read `AGENTS.md` when entering any automation subfolder
- Read `{name}-progress.txt` **Codebase Patterns section first** before starting any task
- Archive path is **date-stamped**: `00-Archive/YYYY-MM-DD-{id}-{name}/` — not just `{id}-{name}`
- A **post-mortem must be generated** before archiving (see framework Post-Mortem Process)
- Multiple automations can coexist — they use sequential IDs and independent folder structures
- Before creating a new automation, check if completed ones here need archiving first
