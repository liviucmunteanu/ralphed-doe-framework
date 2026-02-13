# AGENTS Context: Reviews

> **Purpose**: This folder holds deliverables awaiting human review. When a task has `reviewRequired: true` and passes quality checks, its outputs are placed here for the user to inspect before the task is marked complete.

## Contents

Currently empty — no reviews are pending.

## How It Works

1. Agent completes a task with `reviewRequired: true`
2. Agent runs quality checks and pre-completion checklist
3. Agent copies/links deliverables to `00-Reviews/{id}-{name}/`
4. Agent creates a `review-summary.md` explaining what to check
5. Agent provides a **status summary** to the user (see framework Operating Principle 16):
   - Progress (X of Y tasks complete)
   - What's being reviewed
   - Any `[NEEDS VERIFICATION]` flags
   - What the user needs to do next
6. Agent pauses and waits for user sign-off
7. After approval, task is marked `passes: true` and review files are cleaned up

## Review Types

- **approval**: User must explicitly approve before proceeding (high-stakes deliverables, final outputs)
- **spot-check**: User glances at output, confirms direction (medium-risk tasks)
- **none**: No human review needed (default for low-risk, deterministic tasks)

## "Watch Out" Warnings

- Never archive an automation that has unresolved `[NEEDS VERIFICATION]` flags
- Review files here are transient — clean up after approval
- Review subfolders use the same `{id}-{name}` naming as the automation they belong to
- When a blocked task is escalated, the blocker notification should also be communicated here or directly to the user
