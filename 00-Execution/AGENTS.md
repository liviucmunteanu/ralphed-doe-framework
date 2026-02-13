# AGENTS Context: Generic Execution

> **Purpose**: This folder contains generic (shared) execution scripts and tools used across all automations. Workflow-specific tools live in subfolders named `{id}-{name}/`.

## Contents

Currently empty — no generic execution scripts have been created yet. Scripts are created here as needed during automation execution.

## High-Level Architecture

- Generic tools go in this root folder (reusable across automations)
- Automation-specific tools go in `{id}-{name}/` subfolders
- Lookup order: workflow-specific first (`00-Execution/{id}-{name}/`), then generic fallback (this folder)

## Feedback Loops

The framework requires at least one **automated, deterministic feedback loop** per domain before the first task executes. If no validation script exists for the automation's domain, **create one here** during pre-flight validation (Step 3.5 of `00-Directives/03-run-ralphed-doe-automation.md`).

Expected feedback loop scripts by domain:
| Domain | Example Script |
|--------|---------------|
| Coding | Typecheck + tests + lint (often project-native, not a separate script) |
| Research | `validate-sources.py` — verify URLs are reachable, check citation format |
| Writing | `validate-writing.py` — spell-check, word count, reading level |
| Documentation | `validate-docs.py` — link checker, code example execution |
| Analysis | `validate-analysis.py` — formula verification, row count reconciliation |

## "Watch Out" Warnings

- Always check for existing tools before creating new ones
- Prefer Python or native console scripts (bash, zsh)
- Never hardcode credentials — load from `.env` or `credentials/`
- Scripts should be deterministic and testable — push complexity out of the agent and into code
