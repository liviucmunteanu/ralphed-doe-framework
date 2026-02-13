# AGENTS Context: Quality Checks

> **Purpose**: Domain-specific quality check definitions in JSON format. These files define which checks must pass before a task can be marked as complete. Referenced by `00-Directives/03-run-ralphed-doe-automation.md` during task execution.

## Contents

- `universal.json` — Cross-domain checks that **ALWAYS run** regardless of domain: hallucination prevention, consistency, traceability, completeness
- `coding.json` — Security, typecheck, tests, lint/quality, browser verification (mandatory for UI tasks)
- `research.json` — Citations, coverage, source quality, accuracy
- `writing.json` — Grammar, readability, format, completeness
- `documentation.json` — Links, API accuracy, examples, structure
- `analysis.json` — Data integrity, methodology, conclusion validity

## How They're Used

1. Agent reads `{name}-spec.json` to determine the automation's `domain`
2. Agent loads `quality-checks/{domain}.json` for domain-specific checks
3. Agent **always also loads** `quality-checks/universal.json`
4. Both sets of checks must pass before a task is marked `passes: true`
5. Results are recorded in the task's `qualityEvidence` field

## Relationships

- These files map 1:1 to the quality check tables in `AGENTS-Instructions-AgenticWorkflows.md` (Domain-Specific Quality Checks section)
- Pre-completion checklists in the framework are the operational counterpart of these definitions
- Feedback loops in `00-Execution/` are the automated implementation of these checks

## "Watch Out" Warnings

- `universal.json` always runs on top of the domain-specific file — never skip it
- If a new domain is added, create a corresponding JSON file here AND update the framework's quality check tables
- These files define WHAT to check, not HOW — the "how" depends on the tools available in the project
