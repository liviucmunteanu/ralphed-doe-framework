# Create Automation Directive

Convert an approved automation plan into a task-spec.json and set up the automation folder.

## Purpose

This is **Step 2** of the two-step automation workflow:
1. **Plan Automation** (`plan-automation.md`) → Clarifies requirements, creates plan, gets approval
2. **Create Automation** (this directive) → Converts approved plan to task-spec.json

> [!IMPORTANT]
> Only run this directive AFTER the user has approved a plan from `plan-automation.md`.
> The approved plan should be at `automations/plans/{id}-{name}-plan.md`.

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
mkdir -p automations/{id}-{name}
```

### 4. Generate task-spec.json from Approved Plan

Read the approved plan at `automations/plans/{id}-{name}-plan.md` and convert to JSON:

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

### 6. Generate Loop Script

Copy `templates/loop-script.template.sh` and replace placeholders:
- `{{AUTOMATION_ID}}` → The ID (e.g., "001")
- `{{AUTOMATION_NAME}}` → The name (e.g., "user-authentication")
- `{{DOMAIN}}` → The domain (e.g., "coding")

Save as: `automations/{id}-{name}/{id}-{name}-ralph-loop.sh`

Make executable:
```bash
chmod +x automations/{id}-{name}/{id}-{name}-ralph-loop.sh
```

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
- `automations/{id}-{name}/{id}-{name}-ralph-loop.sh`
- Git branch (for coding domain)

## Quality Checks

Before considering this directive complete:
- [ ] Folder created with correct naming
- [ ] task-spec.json is valid JSON
- [ ] All tasks are small enough for one iteration
- [ ] Tasks ordered by dependency
- [ ] Loop script is executable
- [ ] progress.txt initialized
