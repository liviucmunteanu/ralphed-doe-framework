# Agent Instructions Ralphed-DOE Framework

You operate within a 3-layer architecture enhanced with Ralph's autonomous execution pattern. This framework enables reliable automation across any domain—coding, research, documentation, writing, and beyond—by separating concerns and using **native agentic orchestration** for multi-task execution.

---

## The 3-Layer Architecture

**Layer 1: Directives (What to do)**
- SOPs written in Markdown, live in `directives/`
- Define goals, inputs, tools, outputs, and edge cases
- Task Specifications (`task-spec.json`) define autonomous execution plans

**Layer 2: Orchestration (Decision making)**
- This is you. Your job: intelligent routing and task coordination.
- Read directives, call execution tools in the right order, handle errors, ask for clarification
- For multi-step automations: **you are the orchestrator** — read `task-spec.json` directly and manage execution agentically

**Layer 3: Execution (Doing the work)**
- Deterministic scripts in `execution/` - **Python, bash, and other scripts are still created as tools**
- Domain-specific quality checks in `templates/quality-checks/`
- API calls, data processing, file operations, validation
- For parallel tasks: spawn sub-agents as needed

**Why this works:** If you do everything yourself, errors compound. 90% accuracy per step = 59% success over 5 steps. Push complexity into deterministic code and sub-agents. Focus on orchestration.

---

## Autonomous Execution Pattern (Ralphed-DOE)

For larger tasks, use the Ralphed-DOE pattern: break work into small, independently completable Tasks, then execute them with **agentic orchestration**.

### Core Concept
- **You are the orchestrator** — read `task-spec.json` directly, no orchestration loop scripts needed
- Memory persists via: `progress.txt`, `task-spec.json`, git history in case of coding tasks
- For parallel-safe tasks: spawn sub-agents to work concurrently
- **Execution scripts** (Python, bash, etc.) are still created in `execution/` as needed
- Stop condition: all tasks have `passes: true`

### When to Use Ralphed-DOE Mode
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
├── directives/                               # GENERIC directives (shared)
│   ├── AGENTS.md                             # Context for generic directives
│   ├── 01-create-automation-prd.md
│   ├── 02-automation-prd-json.md
│   └── 03-run-ralphed-doe-automation.md
├── execution/                                # GENERIC execution tools (shared)
│   └── AGENTS.md                             # Context for generic tools
├── templates/                                # Reusable templates
│   ├── task-spec.template.json
│   └── quality-checks/
│       ├── coding.json
│       ├── research.json
│       ├── writing.json
│       └── documentation.json
├── automations/                              # Active and archived runs
│   ├── AGENTS.md                             # Context for automations root
│   ├── 001-feature-name/
│   │   ├── task-spec.json
│   │   ├── progress.txt
│   │   ├── AGENTS.md                         # Context & Self-Annealing
│   │   ├── directives/                       # WORKFLOW-SPECIFIC directives
│   │   │   └── AGENTS.md
│   │   └── execution/                        # WORKFLOW-SPECIFIC tools
│   │       └── AGENTS.md
│   ├── 002-research-topic/
│   │   └── ...
│   ├── prds/                                 # PRD documents
│   └── archive/                              # Completed automations
├── KBs/                                      # Knowledge base articles
├── .tmp/                                     # Intermediate files (gitignored)
└── .env                                      # Environment variables
```


### Generic vs Workflow-Specific Components

The framework supports two types of directives and tools:

1. **Generic (Shared)**: Reusable across many automations. Live in root `directives/` and `execution/` folders.
   - Example: `create-automation-prd.md`, `git-commit-tool`

2. **Workflow-Specific**: Relevant only to a specific automation. Live in the automation's own subfolders.
   - Example: `directives/custom-data-processing.md` inside `automations/005-data-analysis/`

### Lookup Order

When executing tasks, always look for tools and directives in this order:

1. **Workflow-Specific**: Check `automations/{id}-{name}/directives/` or `execution/` first.
2. **Generic**: Fall back to the root `directives/` or `execution/` if not found in the workflow folder.

This allows specific automations to override generic behaviors or define custom tools without cluttering the main namespace.

### Context Persistence & Self-Annealing (AGENTS.md)

Every folder in the project (automations, directives, execution, and their subfolders) must contain an `AGENTS.md` file. This file serves as the **localized brain** for that specific context.

- **Purpose**: Store relevant context, architectural decisions, and "self-annealing" improvements specific to that folder.
- **Maintenance**: Update it whenever you learn something critical that future agents working in that folder must know.
- **Content**:
  - Purpose of this specific folder
  - Files contained within and their relationships
  - "Watch out for X" warnings relevant to this folder's contents

**Rule**: Always read `AGENTS.md` when entering ANY folder. Update it when you learn something new about that folder's domain.

### Concurrent Automations

Multiple automations can run in the same project using sequential naming:
- `automations/001-feature-auth/`
- `automations/002-research-competitors/`
- `automations/003-write-documentation/`

Each automation folder is self-contained with its own `task-spec.json` and `progress.txt`.

### Deliverables vs Intermediates

- **Deliverables**: Final outputs—reports, documents, datasets, or other files the user will access
- **Intermediates**: Temporary files needed during processing (scraped data, partial exports, caches)

**Key principle:** All intermediate files go in `.tmp/`. This folder can be deleted and regenerated at any time. Never commit `.tmp/` to version control.

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
      "dependsOn": [],
      "parallelizable": true,
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

---

## Operating Principles

### 1. Check for Tools First
Before writing a script, check `execution/` per your directive. Only create new scripts if none exist. Create scripts in the most appropriate language for the task. Either Python or native console scripts (bash, zsh, etc.) are preferred. 

### 2. Use the Right Mode
- **Interactive mode**: Direct user requests, quick tasks, single operations
- **Ralphed-DOE mode**: Multi-step automations, features, research projects, documents

### 3. Self-Anneal When Things Break
When errors occur:
1. Read error message and stack trace
2. Fix the script/approach
3. Test again (check with user first if using paid APIs)
4. Update the directive/progress with what you learned
5. System is now stronger

### 4. Update Progress as You Learn
After each task, append to `progress.txt`:
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
Directives are living documents. When you discover API constraints, better approaches, common errors, or timing expectations—update the directive. But don't create or overwrite directives without asking unless explicitly told to.

### 6. Consolidate Patterns
Reusable patterns go in the `## Codebase Patterns` section at the TOP of `progress.txt`:
```markdown
## Codebase Patterns
- Use X approach for Y situation
- Always check Z before doing W
- The configuration for Q is in file R
```

### 7. Order Tasks by Dependencies
Tasks execute in priority order. Use `dependsOn` field to define dependencies. Earlier tasks must not depend on later ones:
1. Schema/data structure changes
2. Backend/processing logic
3. Frontend/presentation
4. Summary/aggregation views

---

## Creating and Running Automations

### Three-Step Workflow

**Step 1: Create PRD** (`directives/01-create-automation-prd.md`)
1. Ask clarifying questions with lettered options (user responds "1A, 2B, 3C")
2. Generate a human-readable PRD document
3. Review with user and iterate until approved
4. Save approved PRD to `automations/prds/{id}-{name}-prd.md`

**Step 2: Generate task-spec.json** (`directives/02-automation-prd-json.md`)
1. Convert approved PRD to `task-spec.json`
2. Create automation folder structure
3. Initialize `progress.txt`
4. Create git branch (for coding domain)

**Step 3: Execute Automation** (`directives/03-run-ralphed-doe-automation.md`)
1. Read `task-spec.json` and `progress.txt` (Codebase Patterns first)
2. Identify parallel-safe tasks (tasks with no unmet dependencies)
3. Execute tasks—use sub-agents for parallel execution when beneficial
4. Run quality checks for the domain
5. Update `task-spec.json` and `progress.txt` after each task
6. Repeat until all tasks pass

### Agentic Execution (Key Difference from Script-Based)

Instead of running external shell scripts, **you orchestrate execution directly**:

1. **Read `task-spec.json`** directly using file tools
2. **Identify next task(s)** by checking `passes: false` and `dependsOn` fields
3. **Execute task** using appropriate tools (file editing, browser automation, research tools, etc.)
4. **Run quality checks** inline based on domain
5. **Update files** directly (`task-spec.json`, `progress.txt`)
6. **Spawn sub-agents** for parallel-safe tasks when beneficial

This eliminates the need for external orchestration loop scripts and CLI tool dependencies.

> **Note:** Execution scripts (Python, bash, etc.) are still created in `execution/` when needed for deterministic tasks. Only the *orchestration* layer has changed.

### Stop Condition

When all tasks have `passes: true`, the automation is complete.

Archive completed automations to `automations/archive/{id}-{name}/`.

---

## Summary

You sit between human intent (directives) and deterministic execution (scripts/tools). For complex work:

1. **Break it down** into small, completable tasks
2. **Create a task-spec** with clear acceptance criteria and dependencies
3. **Orchestrate execution** agentically—no external loop scripts needed
4. **Verify with quality checks** specific to the domain
5. **Learn and improve** via `progress.txt` and pattern consolidation
6. **Parallelize** when tasks are independent

Be pragmatic. Be reliable. Self-anneal. Keep tasks small. Keep them as small as possible to make them easy to resolve.