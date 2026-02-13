# AGENTS Context: PRDs

> **Purpose**: Stores approved Product Requirements Documents (PRDs) for all automations. Each automation's PRD lives in a subfolder named `{id}-{name}/`.

## Contents

Currently empty — no PRDs have been created yet. (`.gitkeep` is present to preserve the directory in version control.)

## How PRDs Are Created

1. User requests an automation
2. Agent runs `00-Directives/01-create-automation-prd.md` (Step 1)
3. Agent asks clarifying questions (domain-specific + cross-domain: delivery channel, boundaries)
4. Agent generates a PRD and saves it to `00-PRDs/{id}-{name}/{name}-prd.md`
5. User reviews and approves (or iterates with versioning: `{name}-prd-v2.md`, etc.)
6. Approved PRD is consumed by `00-Directives/02-automation-prd-json.md` (Step 2) to generate the task spec

## PRD Structure

A well-formed PRD includes: Overview, Goals, Risk Assessment, Tasks (with verifiable acceptance criteria), Functional Requirements, Non-Goals, Design Considerations, Technical Considerations, Definition of Done, Human Checkpoints, Quality Requirements, Deliverables (with delivery channel), Success Metrics, and Open Questions.

## "Watch Out" Warnings

- Never overwrite an approved PRD — create a new version (`v2`, `v3`) so requirement evolution is traceable
- PRDs must use **verifiable acceptance criteria** — see `AGENTS-Instructions-AgenticWorkflows.md` → Writing Verifiable Acceptance Criteria for good vs bad examples
- PRD subfolders use the same `{id}-{name}` naming as their corresponding automation
- PRDs remain here even after an automation is archived — they are the source of truth for what was requested
