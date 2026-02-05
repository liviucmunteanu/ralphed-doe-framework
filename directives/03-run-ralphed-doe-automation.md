# Run Ralphed-DOE Automation Directive

Execute tasks from a task-spec.json file using **agentic orchestration**.

This is **Step 3** of the three-step automation workflow:
1. **Create PRD for the Automation** (`01-create-automation-prd.md`) → Creates readable plan, gets approval
2. **Create Automation PRD JSON File** (`02-automation-prd-json.md`) → Converts approved PRD to task-spec.json
3. **Run Ralphed-DOE Automation** (this directive) → Executes tasks agentically

## Inputs

- **Automation Path**: e.g., `automations/001-feature-name/`

## Before Starting

### 1. Identify Directives and Tools

Check for workflow-specific inputs first, then fall back to generic ones:

**Tool Lookup Order:**
1. `{automation_path}/execution/` (Workflow-specific)
2. `execution/` (Generic)

**Directive Lookup Order:**
1. `{automation_path}/directives/` (Workflow-specific)
2. `directives/` (Generic)

### 2. Read Codebase Patterns First

```bash
head -50 {automation_path}/progress.txt
```

Look for the `## Codebase Patterns` section. These are learnings from previous iterations that you MUST follow.

### 3. Check Current State

```bash
cat {automation_path}/task-spec.json | jq '.tasks[] | {id, title, passes}'
```

Identify which tasks are complete (`passes: true`) and which remain.

## Execution Loop

### 4. Pick Next Task

Select the **highest priority** task where `passes: false`:
```bash
cat task-spec.json | jq '.tasks | map(select(.passes == false)) | sort_by(.priority) | .[0]'
```

### 5. Execute Single Task

Work on ONLY this task. Follow its:
- **Description**: What to accomplish
- **Acceptance Criteria**: How to verify it's done

Keep your work focused. Do not touch other tasks.

### 6. Run Quality Checks

Based on the domain in task-spec.json, run the appropriate checks from `templates/quality-checks/{domain}.json`:

| Domain | Checks |
|--------|--------|
| coding | security, typecheck, tests, quality, browser |
| research | citations, coverage, source quality, accuracy |
| writing | grammar, readability, format, completeness |
| documentation | links, API accuracy, examples, structure |

**All required checks must pass before marking task complete.**

### 7. Update Task Status

If all checks pass, update task-spec.json:
```json
{
  "id": "T-001",
  ...
  "passes": true,
  "notes": "Completed on YYYY-MM-DD. Brief note about implementation."
}
```

### 8. Commit Changes (for coding domain)

```bash
git add .
git commit -m "feat: [Task ID] - [Task Title]"
```

### 9. Append to progress.txt

Add entry at the bottom:
```markdown
## [YYYY-MM-DD HH:MM] - [Task ID]
- What was accomplished
- Files/deliverables changed
- **Learnings for future iterations:**
  - Patterns discovered
  - Gotchas encountered
  - Useful context for future work

---
```

### 10. Consolidate Patterns

If you discovered something **reusable** that future iterations should know, add it to the `## Codebase Patterns` section at the TOP of progress.txt.

Only add **general patterns**, not task-specific details:
- "Use X approach for Y situations"
- "Always check Z when modifying W"
- "Configuration for Q is in file R"

## Stop Condition

After completing a task, check if ALL tasks have `passes: true`:
```bash
cat task-spec.json | jq '[.tasks[] | select(.passes == false)] | length'
```

If result is `0`, output:
```
<promise>COMPLETE</promise>
```

If tasks remain, continue to the next task. You are the orchestrator—continue executing tasks until all pass or you need user input.

## Important Rules

1. **Focus on one task at a time** - Complete each task before moving to the next
2. **Parallelize when safe** - Tasks with no unmet dependencies and `parallelizable: true` can use sub-agents
3. **Quality gates** - Never mark a task complete if checks fail
4. **Learn and share** - Always update progress.txt with learnings
5. **Keep CI green** - For coding, never commit broken code
6. **Persist context** - You are the orchestrator; use progress.txt for learnings across tasks

## Handling Failures

If a task cannot be completed:
1. Document what went wrong in `notes` field
2. Update progress.txt with the blocker
3. Do NOT mark `passes: true`
4. The loop will retry or a human can intervene

## Archiving Completed Automations

When all tasks pass, move to archive:
```bash
mv automations/{id}-{name} automations/archive/{id}-{name}
```
