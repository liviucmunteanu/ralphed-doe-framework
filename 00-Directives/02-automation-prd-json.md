# Create Automation PRD JSON File Directive

Convert an approved automation plan into a {name}-spec.json and set up the automation folder structure.

## Purpose

This is **Step 2** of the three-step automation workflow:
1. **Create PRD for the Automation** (`01-create-automation-prd.md`) → Clarifies requirements, creates plan, gets approval
2. **Create Automation PRD JSON File** (this directive) → Converts approved PRD to {name}-spec.json
3. **Run Ralphed-DOE Automation** (`03-run-ralphed-doe-automation.md`) → Executes tasks agentically

> [!IMPORTANT]
> Only run this directive AFTER the user has approved a plan from `01-create-automation-prd.md`.
> The approved plan should be at `00-PRDs/{id}-{name}/{name}-prd.md`.

## Inputs

- **Approved Plan**: Path to the approved plan document
- **Domain**: coding | research | writing | documentation | analysis | other

## Steps

### 1. Check for Existing Automations (Archive if Needed)

Before creating a new automation, check if a completed or abandoned one exists:
```bash
ls -d 00-Automations/[0-9]* 2>/dev/null | sort -V
```

If an existing automation has a **different ID/name** and all its tasks have `passes: true`, archive it first (see `03-run-ralphed-doe-automation.md`, Archiving section). If it's still in progress, the new automation can coexist — use the next sequential ID.

### 2. Determine Next Sequential ID

Check `00-Automations/` folder for existing automations:
```bash
ls -d 00-Automations/[0-9]* 2>/dev/null | sort -V | tail -1
```

Extract the number and increment. If none exist, start with `001`.

### 3. Create Folder Name

Format: `{id}-{kebab-case-name}`

- ID: 3-digit zero-padded (001, 002, etc.)
- Name: Descriptive, max 3-4 words, kebab-case
- `{name}` = the kebab-case part without the numeric prefix (e.g., `001-feature-auth` → `{name}` = `feature-auth`)

Examples:
- `001-user-authentication`
- `002-competitor-research`
- `003-api-documentation`

### 4. Create Folder Structure

```bash
# Create automation workspace
mkdir -p 00-Automations/{id}-{name}

# Create workflow-specific directives subfolder (centralized)
mkdir -p 00-Directives/{id}-{name}

# Create workflow-specific execution subfolder (centralized)
mkdir -p 00-Execution/{id}-{name}

# Create PRD subfolder
mkdir -p 00-PRDs/{id}-{name}

# Initialize AGENTS.md context files
echo "# Directives Context: {name}\n\n> Purpose: Workflow-specific SOPs for this automation." > 00-Directives/{id}-{name}/AGENTS.md
echo "# Execution Context: {name}\n\n> Purpose: Workflow-specific scripts and tools for this automation." > 00-Execution/{id}-{name}/AGENTS.md
```

This creates:
- The main automation workspace (e.g. `00-Automations/001-feature/`)
- A folder for workflow-specific directives (e.g. `00-Directives/001-feature/`)
- A folder for workflow-specific tools (e.g. `00-Execution/001-feature/`)
- A folder for the PRD document (e.g. `00-PRDs/001-feature/`)

### 5. Generate {name}-spec.json from Approved Plan

Read the approved plan at `00-PRDs/{id}-{name}/{name}-prd.md` and convert to JSON:

```json
{
  "id": "{id}-{name}",
  "name": "Human-readable name from plan",
  "domain": "{domain}",
  "description": "From plan overview section",
  "branchName": "ralph/{name}",
  "completionCriteria": "From Definition of Done section",
  "riskLevel": "From Risk Assessment section",
  "humanCheckpoints": ["From Human Checkpoints section"],
  "commitConvention": "feat: [Task ID] - [Task Title]",
  "deliveryChannel": "From Deliverables section (local | cloud | repository | communication)",
  "tasks": [
    {
      "id": "T-001",
      "title": "Task title",
      "description": "From task description",
      "acceptanceCriteria": ["From task acceptance criteria"],
      "dependsOn": [],
      "parallelizable": true,
      "priority": 1,
      "complexity": "From task complexity rating",
      "estimatedIterations": 1,
      "actualIterations": 0,
      "maxRetries": 3,
      "reviewRequired": false,
      "reviewType": "none",
      "passes": false,
      "blocked": false,
      "blockerReason": "",
      "notes": "",
      "rollbackStrategy": "From task rollback info",
      "qualityEvidence": {}
    }
  ],
  "qualityChecks": "{domain}",
  "deliverables": ["From plan deliverables section"]
}
```

Save to: `00-Automations/{id}-{name}/{name}-spec.json`

### 6. Task Sizing Rules

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

### 7. Add Task Dependencies (Optional)

For tasks that can run in parallel, add dependency information:

```json
{
  "id": "T-001",
  "dependsOn": [],
  "parallelizable": true
}
```

Tasks with empty `dependsOn` arrays and `parallelizable: true` can be executed concurrently by the orchestrating agent.

### 8. Initialize {name}-progress.txt

Create initial progress file at `00-Automations/{id}-{name}/{name}-progress.txt`:

```markdown
# Progress Log: {Automation Name}

## Codebase Patterns
(Add reusable patterns here as you discover them)

---

```

### 9. Initialize AGENTS.md

Create the shared brain file at `00-Automations/{id}-{name}/AGENTS.md`:

```markdown
# AGENTS Context: {Automation Name}

> **Purpose**: This file serves as the shared brain for any agent working in this folder. Update it when you learn something critical that future agents (or yourself in the next step) must know.

## High-Level Architecture
- (Add architectural decisions here)

## Project Constraints
- (Add specific constraints here)

## Domain Dictionary
- (Add domain-specific terms here)

## "Watch Out" Warnings
- (Add warnings based on failures here)
```

### 10. Create Git Branch (if coding domain)

For coding automations:
```bash
git checkout -b ralph/{name}
```

## Outputs

- `00-Automations/{id}-{name}/{name}-spec.json`
- `00-Automations/{id}-{name}/{name}-progress.txt`
- `00-Automations/{id}-{name}/AGENTS.md`
- `00-Directives/{id}-{name}/AGENTS.md`
- `00-Execution/{id}-{name}/AGENTS.md`
- `00-PRDs/{id}-{name}/{name}-prd.md`
- Git branch (for coding domain)

## Next Step

Run `00-Directives/03-run-ralphed-doe-automation.md` to execute the automation agentically.

## Quality Checks

Before considering this directive complete:
- [ ] Existing automations checked — completed ones archived if needed (Step 1)
- [ ] Folder created with correct naming in 00-Automations/, 00-Directives/, 00-Execution/, and 00-PRDs/
- [ ] {name}-spec.json is valid JSON with all required fields
- [ ] All tasks include: complexity, maxRetries, reviewRequired, rollbackStrategy
- [ ] Project-level fields present: completionCriteria, riskLevel, humanCheckpoints, commitConvention, deliveryChannel
- [ ] All tasks are small enough for one iteration
- [ ] Tasks ordered by dependency
- [ ] Task dependencies defined where applicable
- [ ] **Acceptance criteria are verifiable** — no vague criteria like "works correctly" or "good quality" (see `AGENTS-Instructions-AgenticWorkflows.md` → Writing Verifiable Acceptance Criteria)
- [ ] **Every task has a domain-appropriate quality gate** as its final criterion (e.g., "Typecheck passes", "All claims cite verifiable sources")
- [ ] **Open-ended tasks have explicit boundaries** (source count, word count, depth limit, time scope)
- [ ] {name}-progress.txt initialized with Codebase Patterns section placeholder
- [ ] AGENTS.md initialized with template
