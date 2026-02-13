# Run Ralphed-DOE Automation Directive

Execute tasks from a {name}-spec.json file using **agentic orchestration**.

This is **Step 3** of the three-step automation workflow:
1. **Create PRD for the Automation** (`01-create-automation-prd.md`) → Creates readable plan, gets approval
2. **Create Automation PRD JSON File** (`02-automation-prd-json.md`) → Converts approved PRD to {name}-spec.json
3. **Run Ralphed-DOE Automation** (this directive) → Executes tasks agentically

## Inputs

- **Automation Path**: e.g., `00-Automations/001-feature-name/`

> **Note:** The `{id}-{name}` segment (e.g., `001-feature-name`) is used to locate related folders across `00-Directives/`, `00-Execution/`, and `00-PRDs/`.

## Before Starting

### 1. Identify Directives and Tools

Check for workflow-specific inputs first, then fall back to generic ones. Extract the `{id}-{name}` segment from the automation path to locate related folders:

**Tool Lookup Order:**
1. `00-Execution/{id}-{name}/` (Workflow-specific)
2. `00-Execution/` (Generic)

**Directive Lookup Order:**
1. `00-Directives/{id}-{name}/` (Workflow-specific)
2. `00-Directives/` (Generic)

### 2. Read Context & Memory (Patterns First)

Read the "shared brain" and learning logs. **Read the Codebase Patterns section at the TOP of `{name}-progress.txt` FIRST** — this contains consolidated learnings from all previous iterations. Skipping it means repeating mistakes that were already solved.

```bash
cat {automation_path}/AGENTS.md
cat {automation_path}/{name}-progress.txt
```

- **AGENTS.md**: High-level context, architecture, and "watch out" warnings.
- **{name}-progress.txt**: `## Codebase Patterns` section (read first) + per-task learnings from previous iterations.

**Rule**: You MUST obey the architectural decisions and warnings in `AGENTS.md`.

### 3. Check Current State

```bash
cat {automation_path}/{name}-spec.json | jq '.tasks[] | {id, title, passes, blocked}'
```

Identify which tasks are complete (`passes: true`), blocked (`blocked: true`), and which remain.

### 3.5 Pre-flight Validation

Before starting execution, verify:
- [ ] All required tools/APIs referenced in tasks are accessible
- [ ] Required credentials in `.env` are present and valid
- [ ] No blocked tasks without resolution that would prevent progress
- [ ] All dependency tasks for the next task have `passes: true`
- [ ] Sufficient context window budget to complete at least one task + quality checks
- [ ] **Feedback loop exists for this domain** — check `00-Execution/` for a validation script. If none exists, create one before starting the first task (even a simple one is better than pure self-assessment). See `AGENTS-Instructions-AgenticWorkflows.md` → Feedback Loops (Critical).

**If pre-flight fails**: Document what's missing in `{name}-progress.txt` and notify user.

## Execution Loop

### 4. Pick Next Task

Select the **highest priority** task where `passes: false`:
```bash
cat {automation_path}/{name}-spec.json | jq '.tasks | map(select(.passes == false)) | sort_by(.priority) | .[0]'
```

### 5. Execute Single Task

Work on ONLY this task. Follow its:
- **Description**: What to accomplish
- **Acceptance Criteria**: How to verify it's done

Keep your work focused. Do not touch other tasks.

### 6. Run Quality Checks

Based on the domain in {name}-spec.json, run the appropriate checks from `00-Templates/quality-checks/{domain}.json`.

**Universal checks ALWAYS run** (from `00-Templates/quality-checks/universal.json`) in addition to domain-specific checks:

| Domain | Domain Checks | + Universal Checks (always) |
|--------|---------------|----------------------------|
| coding | security, typecheck, tests, quality, browser | hallucination, consistency, traceability, completeness |
| research | citations, coverage, source quality, accuracy | hallucination, consistency, traceability, completeness |
| writing | grammar, readability, format, completeness | hallucination, consistency, traceability, completeness |
| documentation | links, API accuracy, examples, structure | hallucination, consistency, traceability, completeness |
| analysis | data integrity, methodology, conclusions, bias | hallucination, consistency, traceability, completeness |

**All required checks must pass before marking task complete.**

### 6.5 Handle Failures with Escalation

If quality checks fail:
1. Increment `actualIterations` on the task
2. If `actualIterations < maxRetries`: self-anneal (read error, fix approach, retry)
3. If `actualIterations >= maxRetries`: set `"blocked": true`, add `"blockerReason"`, **STOP** and notify user
4. **NEVER** mark `passes: true` on a task that hasn't passed all quality checks

### 6.7 Run Pre-Completion Checklist

Before marking a task as passing, run the applicable pre-completion checklist from `AGENTS-Instructions-AgenticWorkflows.md` → Pre-Completion Checklists. The universal checklist applies to ALL tasks; domain-specific items are additive.

### 7. Update Task Status (with Quality Evidence)

If all checks AND the pre-completion checklist pass, update {name}-spec.json with quality evidence:
```json
{
  "id": "T-001",
  "passes": true,
  "actualIterations": 1,
  "qualityEvidence": {
    "checksRun": ["domain_check_1", "domain_check_2", "hallucination_check", "consistency_check"],
    "results": {
      "domain_check_1": { "pass": true, "evidence": "Brief description of what was verified" },
      "hallucination_check": { "pass": true, "evidence": "All N claims sourced" }
    },
    "universalChecksRun": true,
    "timestamp": "YYYY-MM-DDTHH:MM:SSZ"
  },
  "notes": "Completed on YYYY-MM-DD. Brief note about implementation."
}
```

### 7.5 Handle Human Review Gates

If the task has `"reviewRequired": true`:
1. Place deliverables in `00-Reviews/{id}-{name}/`
2. Create a `review-summary.md` with:
   - What was produced
   - Quality evidence summary
   - What the reviewer should check
   - Any `[NEEDS VERIFICATION]` flags that need resolution
3. **Provide a status summary** to the user (see framework Operating Principle 16):
   ```markdown
   ## Status Update: [Automation Name]
   - **Progress**: X of Y tasks complete
   - **Current task**: [Task ID] — [Title] — Awaiting review
   - **Blockers**: [None | Description]
   - **Next step**: [What the user needs to review/approve]
   - **Deliverables ready for review**: [List of files/links]
   ```
4. **Pause** and wait for human sign-off
5. Only mark `passes: true` after human approval

### 8. Commit Changes (for coding domain)

```bash
git add .
git commit -m "feat: [Task ID] - [Task Title]"
```

### 9. Append to {name}-progress.txt

Add entry at the bottom (must match the framework's progress format):
```markdown
## [YYYY-MM-DD HH:MM] - [Task ID]
- **Status**: PASSED | FAILED | BLOCKED
- **Iteration**: X of Y max
- What was accomplished
- Files/deliverables changed
- **Quality Evidence:**
  - [check-name]: PASS — [brief evidence]
  - hallucination_check: PASS — "All N claims sourced"
- **Learnings for future iterations:**
  - Patterns discovered
  - Gotchas encountered
  - Useful context for future work

---
```

### 10. Consolidate & Self-Anneal

1. **Patterns**: Add reusable technical patterns to the top of `{name}-progress.txt`.
2. **Context (Self-Annealing)**: Update `AGENTS.md` if you learned something critical for the *lifetime* of the automation:
   - "We decided to use X library because Y failed."
   - "Watch out for race conditions in Z module."
   - "Architecture update: component A now depends on B."

**Goal**: Make the next agent smarter than you were.

## Stop Condition

After completing a task, check if ALL tasks have `passes: true`:
```bash
cat {automation_path}/{name}-spec.json | jq '[.tasks[] | select(.passes == false)] | length'
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
4. **Learn and share** - Always update {name}-progress.txt with learnings
5. **Keep CI green** - For coding, never commit broken code
6. **Persist context** - You are the orchestrator; use {name}-progress.txt for learnings across tasks

## Handling Failures

If a task cannot be completed:
1. Document what went wrong in `notes` field
2. Update {name}-progress.txt with the blocker
3. Do NOT mark `passes: true`
4. The loop will retry or a human can intervene

## Archiving Completed Automations

When all tasks pass:

### 1. Generate Post-Mortem
Create a post-mortem from `00-Templates/post-mortem.template.md` and save to the automation folder:
```bash
cp 00-Templates/post-mortem.template.md 00-Automations/{id}-{name}/post-mortem.md
# Fill in all sections based on progress.txt and spec.json
```

### 2. Append Lessons Learned

Review the post-mortem's "Key Learnings" and "Recommendations for Next Time" sections. For any insight that applies to the **framework itself** (not just this specific automation), append an entry to `00-KBs/lessons-learned.yml`.

See `AGENTS-Instructions-AgenticWorkflows.md` -> Lessons Learned section for the YAML format and entry rules. Each entry needs: sequential ID (LL-NNN), date, category, summary, detail, affected framework files, and priority.

If the file does not exist yet, create it with a header comment:
```yaml
# 00-KBs/lessons-learned.yml
# Framework improvement log — append after each completed automation.
# Review periodically and apply approved changes to the framework.
```

If no framework-level lessons were learned from this automation, skip this step (not every automation produces framework improvements).

### 3. Verify No Unresolved Flags
Before archiving, ensure:
- [ ] No `[NEEDS VERIFICATION]` flags remaining unresolved in deliverables
- [ ] No tasks with `blocked: true` that weren't resolved
- [ ] All human review gates passed
- [ ] Lessons learned appended to `00-KBs/lessons-learned.yml` (if applicable)

### 4. Archive (Date-Stamped)
```bash
# Create date-stamped archive folder
ARCHIVE_DATE=$(date +%Y-%m-%d)
mkdir -p "00-Automations/00-Archive/${ARCHIVE_DATE}-{id}-{name}"

# Move the automation workspace to archive
mv 00-Automations/{id}-{name}/* "00-Automations/00-Archive/${ARCHIVE_DATE}-{id}-{name}/"
rmdir 00-Automations/{id}-{name}

# Move workflow-specific directives and execution into the archive
mv 00-Directives/{id}-{name} "00-Automations/00-Archive/${ARCHIVE_DATE}-{id}-{name}/directives"
mv 00-Execution/{id}-{name} "00-Automations/00-Archive/${ARCHIVE_DATE}-{id}-{name}/execution"

# Clean up reviews if any
rm -rf 00-Reviews/{id}-{name}
```

### 5. Final Status Communication

After archiving, provide a final status summary to the user:
```markdown
## Automation Complete: [Name]
- **Tasks**: X total, Y passed first try, Z required retries
- **Deliverables**: [List with locations/links]
- **Post-mortem**: [Path to post-mortem file]
- **Archived to**: 00-Automations/00-Archive/YYYY-MM-DD-{id}-{name}/
```
