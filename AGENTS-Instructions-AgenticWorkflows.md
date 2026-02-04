# Agent Instructions (DOE + Ralph Framework)

You operate within a 3-layer architecture enhanced with Ralph's autonomous execution pattern. This framework enables reliable automation across any domain—coding, research, documentation, writing, and beyond—by separating concerns and pushing complexity into deterministic tools while you focus on decision-making.

---

## The 3-Layer Architecture

**Layer 1: Directives (What to do)**
- SOPs written in Markdown, live in `directives/`
- Define goals, inputs, tools/scripts, outputs, and edge cases
- Now includes Task Specifications (`task-spec.json`) for autonomous execution

**Layer 2: Orchestration (Decision making)**
- This is you. Your job: intelligent routing.
- Read directives, call execution tools in the right order, handle errors, ask for clarification
- For multi-step automations: run autonomous loops with fresh context per iteration

**Layer 3: Execution (Doing the work)**
- Deterministic scripts in `execution/`
- Domain-specific quality checks in `templates/quality-checks/`
- API calls, data processing, file operations, validation
- Reliable, testable, fast. Use scripts instead of manual work.

**Why this works:** If you do everything yourself, errors compound. 90% accuracy per step = 59% success over 5 steps. Push complexity into deterministic code. Focus on decision-making.

---

## Autonomous Execution Pattern (Ralph)

For larger tasks, use the Ralph pattern: break work into small, independently completable Tasks, then execute them one at a time with fresh context per iteration.

### Core Concept
- Each iteration = fresh agent instance with clean context
- Memory persists via: `progress.txt`, `task-spec.json`, git history
- Stop condition: all tasks have `passes: true`

### When to Use Ralph Mode
- 3+ sequential tasks to complete
- Clear dependencies between tasks
- Well-defined acceptance criteria per task
- Work spans multiple context windows

### Task Sizing (Critical)
Each task must be completable in ONE context window. If a task is too big, you run out of context before finishing.

**Right-sized tasks:**
- Add a database column and migration
- Research and summarize one competitor
- Write one section of a document
- Create one UI component

**Too big (split these):**
- "Build the entire dashboard" → Split into schema, queries, UI, filters
- "Research the market" → Split into competitors, trends, pricing, positioning
- "Write the documentation" → Split into sections, examples, API reference

**Rule of thumb:** If you can't describe the deliverable in 2-3 sentences, it's too big.

---

## File Organization

### Directory Structure

```
project/
├── AGENTS-Instructions-AgenticWorkflows.md   # This file
├── directives/                               # SOPs (Layer 1)
│   ├── create-automation.md
│   └── run-automation.md
├── execution/                                # Scripts (Layer 3)
├── templates/                                # Reusable templates
│   ├── task-spec.template.json
│   ├── loop-script.template.sh
│   └── quality-checks/
│       ├── coding.json
│       ├── research.json
│       ├── writing.json
│       └── documentation.json
├── automations/                              # Active and archived runs
│   ├── 001-feature-name/
│   │   ├── task-spec.json
│   │   ├── progress.txt
│   │   └── 001-feature-name-ralph-loop.sh
│   ├── 002-research-topic/
│   │   └── ...
│   └── archive/                              # Completed automations
├── .tmp/                                     # Intermediate files (gitignored)
└── .env                                      # Environment variables
```

### Concurrent Automations

Multiple automations can run in the same project using sequential naming:
- `automations/001-feature-auth/`
- `automations/002-research-competitors/`
- `automations/003-write-documentation/`

Each automation folder is self-contained with its own task-spec, progress file, and loop script.

### Deliverables vs Intermediates

- **Deliverables**: Final outputs—reports, documents, datasets, or other files the user will access
- **Intermediates**: Temporary files needed during processing (scraped data, partial exports, caches)

**Key principle:** All intermediate files go in `.tmp/`. This folder can be deleted and regenerated at any time. Never commit `.tmp/` to version control.

**Archiving intermediates:** When an automation completes and intermediate files may be useful for reference:
1. Move relevant `.tmp/` contents to `.tmp/archive/{automation-name}-DDMMYYYY/`
2. Use a descriptive name matching the automation (e.g., `competitor-research-04022026/`)
3. Delete non-essential intermediates (caches, redundant exports)
4. Archive folder can be purged periodically based on retention needs

### Credentials Management

Store credentials and secrets securely:
- **`.env`** — API keys, tokens, and environment-specific configuration
- **`credentials/`** — OAuth tokens, service account files, certificates (add to `.gitignore`)

Never hardcode credentials in scripts. Always load from environment variables or credential files.

---

## Task Specification Format

The universal `task-spec.json` format works for any domain:

```json
{
  "id": "001-feature-name",
  "name": "Feature Name",
  "domain": "coding",
  "description": "What this automation accomplishes",
  "branchName": "ralph/feature-name",
  "tasks": [
    {
      "id": "T-001",
      "title": "Task title",
      "description": "Clear description of what to accomplish",
      "acceptanceCriteria": [
        "Criterion 1 (must be verifiable)",
        "Criterion 2 (must be verifiable)"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ],
  "qualityChecks": "coding",
  "deliverables": ["list of expected outputs"]
}
```

### Domain Values
- `coding` — Software development tasks
- `research` — Investigation, analysis, data gathering
- `writing` — Content creation, copywriting, reports
- `documentation` — Technical docs, API references, guides
- `other` — Custom domain (specify quality checks manually)

---

## Domain-Specific Quality Checks

Each domain has specific verification steps that must pass before marking a task complete.

### Coding
| Check | Description |
|-------|-------------|
| Security | Run security scanners (SAST, dependency audit) |
| Typecheck | `tsc --noEmit` or equivalent for your stack |
| Tests | Unit, integration, and relevant test suites |
| Quality | Lint, format, code quality tools |
| Browser | Verify UI changes visually (for frontend tasks) |

### Research
| Check | Description |
|-------|-------------|
| Citations | All claims have verifiable sources |
| Coverage | Topic fully explored per requirements |
| Source Quality | Sources are authoritative and current |
| Accuracy | Facts verified via cross-referencing |

### Writing
| Check | Description |
|-------|-------------|
| Grammar | No grammatical or spelling errors |
| Readability | Appropriate reading level for audience |
| Format | Follows specified style guide/template |
| Completeness | All required sections present |

### Documentation
| Check | Description |
|-------|-------------|
| Links | All links valid and accessible |
| API Accuracy | Code examples work, signatures correct |
| Examples | Examples tested and functional |
| Structure | Follows documentation standards |

### Creating Custom Templates

When a user request doesn't fit existing templates (coding, research, writing, documentation), create domain-specific templates:

**1. Custom Quality Checks**
Create a new quality check file in `templates/quality-checks/`:

```json
// templates/quality-checks/{domain-name}.json
{
  "domain": "domain-name",
  "checks": [
    {
      "name": "Check Name",
      "description": "What this check verifies",
      "command": "optional CLI command to run",
      "manual": false
    }
  ]
}
```

**2. Custom Task Spec Template**
If the task structure differs significantly, create a specialized template:

```bash
cp templates/task-spec.template.json templates/task-spec.{domain-name}.template.json
# Modify with domain-specific fields
```

**3. When to Create Custom Templates**
- The domain has unique quality criteria not covered by existing checks
- Tasks require specialized acceptance criteria patterns
- You find yourself repeatedly defining the same checks manually

**4. Template Naming Convention**
- Quality checks: `templates/quality-checks/{domain-name}.json`
- Task specs: `templates/task-spec.{domain-name}.template.json`
- Loop scripts: `templates/loop-script.{domain-name}.template.sh`

After creating a custom template, update the `Domain Values` section in this file to include the new domain.

---

## Operating Principles

### 1. Check for Tools First
Before writing a script, check `execution/` per your directive. Only create new scripts if none exist. Create scripts in the most appropriate language for the task. Either Python or native console scripts (bash, zsh, etc.) are preferred. 

### 2. Use the Right Mode
- **Interactive mode**: Direct user requests, quick tasks, single operations
- **Ralph mode**: Multi-step automations, features, research projects, documents

### 3. Self-Anneal When Things Break
When errors occur:
1. Read error message and stack trace
2. Fix the script/approach
3. Test again (check with user first if using paid APIs)
4. Update the directive/progress with what you learned
5. System is now stronger

### 4. Update Progress as You Learn
After each iteration, append to `progress.txt`:
```markdown
## [Date/Time] - [Task ID]
- What was accomplished
- Files/deliverables changed
- **Learnings for future iterations:**
  - Patterns discovered
  - Gotchas encountered
  - Useful context

---
```

### 5. Update Directives as You Learn
Directives are living documents. When you discover API constraints, better approaches, common errors, or timing expectations—update the directive. But don't create or overwrite directives without asking unless explicitly told to. Directives are your instruction set and must be preserved (and improved upon over time).

### 6. Consolidate Patterns
Reusable patterns go in the `## Codebase Patterns` section at the TOP of `progress.txt`:
```markdown
## Codebase Patterns
- Use X approach for Y situation
- Always check Z before doing W
- The configuration for Q is in file R
```

### 7. Order Tasks by Dependencies
Tasks execute in priority order. Earlier tasks must not depend on later ones:
1. Schema/data structure changes
2. Backend/processing logic
3. Frontend/presentation
4. Summary/aggregation views

---

## Creating and Running Automations

### Two-Step Planning Workflow

Before creating an automation, use the two-step workflow to ensure clarity:

**Step 1: Plan Automation** (`directives/plan-automation.md`)
1. Ask clarifying questions with lettered options (user responds "1A, 2B, 3C")
2. Generate a human-readable plan document
3. Review with user and iterate until approved
4. Save approved plan to `automations/plans/{id}-{name}-plan.md`

**Step 2: Create Automation** (`directives/create-automation.md`)
1. Convert approved plan to `task-spec.json`
2. Generate loop script
3. Initialize progress.txt
4. Create git branch (for coding domain)

This ensures requirements are understood before execution begins.

### Creating a New Automation

1. Run `directives/plan-automation.md` first
2. Get user approval on the plan
3. Run `directives/create-automation.md` to generate files

See the directives for detailed steps.

### Running an Automation

1. Read `task-spec.json` and `progress.txt` (Codebase Patterns first)
2. Pick highest priority task where `passes: false`
3. Execute that single task
4. Run quality checks for the domain
5. If checks pass:
   - Mark task as `passes: true`
   - Commit changes (for code) or save deliverables
   - Append to `progress.txt`
6. Repeat until all tasks pass

See `directives/run-automation.md` for detailed steps.

### Stop Condition

When all tasks have `passes: true`, the automation is complete:
```
<promise>COMPLETE</promise>
```

Archive completed automations to `automations/archive/{id}-{name}/`.

---

## Loop Script Generation

Each automation gets its own loop script auto-generated from the template. The script:

1. Spawns fresh agent instances per iteration
2. Passes the task-spec and progress files
3. Runs domain-specific quality checks
4. Handles max iterations limit
5. Detects completion signal

Example invocation:
```bash
./automations/001-feature-auth/001-feature-auth-ralph-loop.sh --max-iterations 10 --tool claude
```

---

## Summary

You sit between human intent (directives) and deterministic execution (scripts/tools). For complex work:

1. **Break it down** into small, completable tasks
2. **Create a task-spec** with clear acceptance criteria
3. **Execute iteratively** with fresh context each time
4. **Verify with quality checks** specific to the domain
5. **Learn and improve** via progress.txt and pattern consolidation

Be pragmatic. Be reliable. Self-anneal. Keep tasks small. Keep them as small as possible to make them easy to resolve.