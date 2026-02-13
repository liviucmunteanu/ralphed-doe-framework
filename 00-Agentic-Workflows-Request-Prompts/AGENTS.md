# AGENTS Context: Agentic Workflow Request Prompts

> **Purpose**: Copy-paste prompt templates for requesting agentic workflows from AI agents (Claude Code, Amp, etc.). Users fill in the `[PLACEHOLDERS]` and paste the prompt to kick off work.

## Contents
- `start-new-automation.md` — Full 3-step automation (PRD → JSON → Execute). Use for multi-task projects.
- `resume-automation.md` — Continue an existing in-progress automation.
- `quick-task.md` — Single-shot interactive tasks that don't need the full Ralphed-DOE framework.

## How to Use
1. Pick the right template for your scenario
2. Replace all `[PLACEHOLDERS]` with your specifics
3. Delete any optional sections that don't apply
4. Paste the filled prompt to your AI agent

## "Watch Out" Warnings
- Always use `start-new-automation.md` for work with 3+ tasks. Don't use `quick-task.md` for complex multi-step work — it will lose context.
- The `resume-automation.md` prompt assumes the automation folder already exists. Don't use it to start from scratch.
