# Create Automation PRD JSON File Directive

Convert an approved automation plan into a task-spec.json and set up the automation folder.

## Purpose

This is **Step 2** of the three-step automation workflow:
1. **Create PRD for the Automation** (`01-create-automation-prd.md`) → Clarifies requirements, creates plan, gets approval
2. **Create Automation PRD JSON File** (this directive) → Converts approved PRD to task-spec.json
3. **Run Ralphed-DOE Automation** (`03-run-ralphed-doe-automation.md`) → Executes tasks agentically

> [!IMPORTANT]
> Only run this directive AFTER the user has approved a plan from `01-create-automation-prd.md`.
> The approved plan should be at `automations/prds/{id}-{name}-prd.md`.

## Inputs

- **Approved Plan**: Path to the approved plan document
- **Domain**: coding | research | writing | documentation | other

## Steps

### 1. Determine Next Sequential ID

Check `automations/` folder for existing automations:
```bash
ls -d automations/[0-9]* 2>/dev/null | sort -V | tail -1
```

Extract the number and increment. If none exist, start with `001`.

### 2. Create Folder Name

Format: `{id}-{kebab-case-name}`

- ID: 3-digit zero-padded (001, 002, etc.)
- Name: Descriptive, max 3-4 words, kebab-case

Examples:
- `001-user-authentication`
- `002-competitor-research`
- `003-api-documentation`

### 3. Create Folder Structure

```bash
mkdir -p automations/{id}-{name}/directives
mkdir -p automations/{id}-{name}/execution
```

This creates:
- The main automation folder
- A folder for workflow-specific directives (e.g. `automations/001-feature/directives/`)
- A folder for workflow-specific tools (e.g. `automations/001-feature/execution/`)

### 4. Generate task-spec.json from Approved Plan

Read the approved plan at `automations/prds/{id}-{name}-prd.md` and convert to JSON:

```json
{
  "id": "{id}-{name}",
  "name": "Human-readable name from plan",
  "domain": "{domain}",
  "description": "From plan overview section",
  "branchName": "ralph/{name}",
  "tasks": [
    // Convert each task from the plan's Tasks section
    // Preserve task IDs, titles, descriptions, and acceptance criteria
    // Ensure priority order matches plan order
  ],
  "qualityChecks": "{domain}",
  "deliverables": ["From plan deliverables section"]
}
```

### 5. Task Sizing Rules

**Each task must be small enough to complete in ONE agent iteration.**

✅ Good task sizing:
- Add a database column
- Research one competitor
- Write one section
- Create one component

❌ Too big (split these):
- "Build the feature" → Split into data, logic, UI tasks
- "Write the report" → Split into sections
- "Document the API" → Split into endpoints/modules

### 6. Add Task Dependencies (Optional)

For tasks that can run in parallel, add dependency information:

```json
{
  "id": "T-001",
  "dependsOn": [],
  "parallelizable": true
}
```

Tasks with empty `dependsOn` arrays and `parallelizable: true` can be executed concurrently by the orchestrating agent.

### 7. Initialize progress.txt

Create initial progress file:

```markdown
# Progress Log: {Automation Name}

## Codebase Patterns
(Add reusable patterns here as you discover them)

---

```

### 8. Create Git Branch (if coding domain)

For coding automations:
```bash
git checkout -b ralph/{name}
```

## Outputs

- `automations/{id}-{name}/task-spec.json`
- `automations/{id}-{name}/progress.txt`
- Git branch (for coding domain)

## Next Step

Run `directives/03-run-ralphed-doe-automation.md` to execute the automation agentically.

## Quality Checks

Before considering this directive complete:
- [ ] Folder created with correct naming
- [ ] task-spec.json is valid JSON
- [ ] All tasks are small enough for one iteration
- [ ] Tasks ordered by dependency
- [ ] Task dependencies defined where applicable
- [ ] progress.txt initialized
