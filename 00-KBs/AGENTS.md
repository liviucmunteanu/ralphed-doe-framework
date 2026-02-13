# AGENTS Context: Knowledge Base

> **Purpose**: Reference materials, external frameworks, domain knowledge, and the framework's cumulative lessons-learned log. Agents consult KBs for context and append framework improvement entries after completing automations.

## Contents

- `lessons-learned.yml` — Cumulative log of framework improvement opportunities discovered during automation execution. Append-only during automation runs; changes to the framework are applied separately through reviewed updates. Created automatically after the first automation completes.

## How KBs Are Used

- **During PRD creation**: Reference KBs for domain knowledge, prior research, or established patterns
- **During execution**: Consult KBs for context the agent needs but that isn't in the automation's own `AGENTS.md` or `{name}-progress.txt`
- **During contradiction checks** (hallucination prevention): Cross-reference new content against known facts in KBs
- **After each automation completes**: Append framework-level lessons to `lessons-learned.yml` (see `AGENTS-Instructions-AgenticWorkflows.md` -> Lessons Learned section)
- **During framework review**: Read `lessons-learned.yml` to identify pending improvements (`applied: false`)

## lessons-learned.yml

This file is the bridge between automation execution and framework evolution. It captures what should change about the framework's directives, templates, quality checks, and operating principles based on real-world usage.

- **Append after each automation** (between post-mortem generation and archiving)
- **Do not apply lessons automatically** — they accumulate and are reviewed by the user
- **Entry categories**: directive-gap, quality-check-gap, template-improvement, process-improvement, pattern-to-generalize, principle-refinement
- **IDs are sequential**: LL-001, LL-002, etc. Read the file to determine the next ID before appending.

## "Watch Out" Warnings

- KBs are reference material — do not modify them during automation execution (except `lessons-learned.yml`, which is append-only)
- If a KB article contradicts the framework, the framework takes precedence (KBs may be outdated)
- Large KBs should be organized into subfolders by topic
- `lessons-learned.yml` entries with `applied: false` are pending — the framework has NOT been updated for those yet
- This folder may be gitignored in some configurations — check `.gitignore` if KBs seem missing
