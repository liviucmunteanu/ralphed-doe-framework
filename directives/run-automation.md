# Run Automation Directive

Execute tasks from a task-spec.json file using Ralph-style autonomous iteration.

## Inputs

- **Automation Path**: e.g., `automations/001-feature-name/`
- **Current Iteration**: Which iteration this is (for logging)

## Before Starting

### 1. Read Codebase Patterns First

```bash
head -50 {automation_path}/progress.txt
```

Look for the `## Codebase Patterns` section. These are learnings from previous iterations that you MUST follow.

### 2. Check Current State

```bash
cat {automation_path}/task-spec.json | jq '.tasks[] | {id, title, passes}'
```

Identify which tasks are complete (`passes: true`) and which remain.

## Execution Loop

### 3. Pick Next Task

Select the **highest priority** task where `passes: false`:
```bash
cat task-spec.json | jq '.tasks | map(select(.passes == false)) | sort_by(.priority) | .[0]'
```

### 4. Execute Single Task

Work on ONLY this task. Follow its:
- **Description**: What to accomplish
- **Acceptance Criteria**: How to verify it's done

Keep your work focused. Do not touch other tasks.

### 5. Run Quality Checks

Based on the domain in task-spec.json, run the appropriate checks from `templates/quality-checks/{domain}.json`:

| Domain | Checks |
|--------|--------|
| coding | security, typecheck, tests, quality, browser |
| research | citations, coverage, source quality, accuracy |
| writing | grammar, readability, format, completeness |
| documentation | links, API accuracy, examples, structure |

**All required checks must pass before marking task complete.**

### 6. Update Task Status

If all checks pass, update task-spec.json:
```json
{
  "id": "T-001",
  ...
  "passes": true,
  "notes": "Completed on YYYY-MM-DD. Brief note about implementation."
}
```

### 7. Commit Changes (for coding domain)

```bash
git add .
git commit -m "feat: [Task ID] - [Task Title]"
```

### 8. Append to progress.txt

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

### 9. Consolidate Patterns

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

If tasks remain, end your response normally. The loop will spawn a fresh iteration.

## Important Rules

1. **ONE task per iteration** - Do not try to do multiple tasks
2. **Fresh context** - Each iteration starts with no memory except progress.txt and task-spec.json
3. **Quality gates** - Never mark a task complete if checks fail
4. **Learn and share** - Always update progress.txt with learnings
5. **Keep CI green** - For coding, never commit broken code

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
