# Agent Instructions Ralphed-DOE Framework

You operate within a 3-layer architecture enhanced with Ralph's autonomous execution pattern. This framework enables reliable automation across any domain—coding, research, documentation, writing, and beyond—by separating concerns and using **native agentic orchestration** for multi-task execution.

---

## The 3-Layer Architecture

**Layer 1: Directives (What to do)**
- SOPs written in Markdown, live in `00-Directives/`
- Define goals, inputs, tools, outputs, and edge cases
- Task Specifications (`{name}-spec.json`) define autonomous execution plans
- Write directives as if for a **competent mid-level employee or AI agent**: explicit, unambiguous, free of unexplained jargon, with enough detail to understand purpose and core logic

**Layer 2: Orchestration (Decision making)**
- This is you. Your job: intelligent routing and task coordination.
- Read directives, call execution tools in the right order, handle errors, ask for clarification
- For multi-step automations: **you are the orchestrator** — read `{name}-spec.json` directly and manage execution agentically

**Layer 3: Execution (Doing the work)**
- Deterministic scripts in `00-Execution/` - **Python, bash, and other scripts are still created as tools**
- Domain-specific quality checks in `00-Templates/quality-checks/`
- API calls, data processing, file operations, validation
- For parallel tasks: spawn sub-agents as needed

**Why this works:** If you do everything yourself, errors compound. 90% accuracy per step = 59% success over 5 steps. Push complexity into deterministic code and sub-agents. Focus on orchestration.

---

## Autonomous Execution Pattern (Ralphed-DOE)

For larger tasks, use the Ralphed-DOE pattern: break work into small, independently completable Tasks, then execute them with **agentic orchestration**.

### Core Concept
- **You are the orchestrator** — read `{name}-spec.json` directly, no orchestration loop scripts needed
- **One task per context window**: The primary orchestrator works on ONE task at a time — pick it, finish it, record progress, then move on. This prevents half-done tasks from accumulating. Sub-agents may work in parallel on independent tasks, but each sub-agent also follows the one-task rule.
- Memory persists via: `{name}-progress.txt`, `{name}-spec.json`, git history in case of coding tasks
- For parallel-safe tasks: spawn sub-agents to work concurrently
- **Execution scripts** (Python, bash, etc.) are still created in `00-Execution/` as needed
- Stop condition: all tasks have `passes: true`
- **Completion signal**: When all tasks pass, output `<promise>COMPLETE</promise>` as a machine-parseable signal. This enables external orchestrators or loop scripts to detect completion deterministically.

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
├── 00-Directives/                            # GENERIC directives (shared)
│   ├── AGENTS.md                             # Context for generic directives
│   ├── 01-create-automation-prd.md
│   ├── 02-automation-prd-json.md
│   ├── 03-run-ralphed-doe-automation.md
│   └── {id}-{name}/                          # WORKFLOW-SPECIFIC directives
│       ├── AGENTS.md
│       └── {name}-custom-directive.md
├── 00-Execution/                             # GENERIC execution tools (shared)
│   ├── AGENTS.md                             # Context for generic tools
│   └── {id}-{name}/                          # WORKFLOW-SPECIFIC tools
│       ├── AGENTS.md
│       └── {name}-script.py
├── 00-Templates/                             # Reusable templates
│   ├── task-spec.template.json
│   ├── loop-script.template.sh
│   ├── post-mortem.template.md               # Post-mortem for completed automations
│   └── quality-checks/
│       ├── universal.json                    # Cross-domain checks (always run)
│       ├── coding.json
│       ├── research.json
│       ├── writing.json
│       ├── documentation.json
│       └── analysis.json                     # Data analysis, strategy, planning
├── 00-Automations/                           # Active automation workspaces
│   ├── AGENTS.md                             # Context for automations root
│   ├── 00-Archive/                           # Completed automations (with post-mortems)
│   └── {id}-{name}/
│       ├── {name}-spec.json                  # Task specification
│       ├── {name}-progress.txt               # Learning log
│       └── AGENTS.md                         # Context & Self-Annealing
├── 00-PRDs/                                  # PRD documents (top-level)
│   └── {id}-{name}/
│       └── {name}-prd.md
├── 00-Reviews/                               # Human review staging area
│   └── AGENTS.md                             # Context for review workflow
├── 00-KBs/                                   # Knowledge base articles
├── .tmp/                                     # Intermediate files (gitignored)
└── .env                                      # Environment variables
```

> **Naming convention:** `{id}` is a 3-digit zero-padded number (001, 002, etc.). `{name}` is the kebab-case descriptive part, derived by stripping the numeric prefix (e.g., `001-feature-auth` → `{name}` = `feature-auth`).


### Generic vs Workflow-Specific Components

The framework supports two types of directives and tools:

1. **Generic (Shared)**: Reusable across many automations. Live in root `00-Directives/` and `00-Execution/` folders.
   - Example: `01-create-automation-prd.md`, `git-commit-tool`

2. **Workflow-Specific**: Relevant only to a specific automation. Live in centralized subfolders named after the automation.
   - Example: `00-Directives/005-data-analysis/{name}-custom-data-processing.md`

### Lookup Order

When executing tasks, always look for tools and directives in this order:

1. **Workflow-Specific**: Check `00-Directives/{id}-{name}/` or `00-Execution/{id}-{name}/` first.
2. **Generic**: Fall back to the root `00-Directives/` or `00-Execution/` if not found in the workflow subfolder.

This allows specific automations to override generic behaviors or define custom tools without cluttering the main namespace.

### Context Persistence & Self-Annealing (AGENTS.md)

Every folder in the project (automations, directives, execution, and their subfolders) must contain an `AGENTS.md` file. This file serves as the **localized brain** for that specific context.

- **Purpose**: Store relevant context, architectural decisions, and "self-annealing" improvements specific to that folder.
- **Maintenance**: Update it whenever you learn something critical that future agents working in that folder must know.
- **Content (DO add)**:
  - Purpose of this specific folder
  - Files contained within and their relationships
  - "Watch out for X" warnings relevant to this folder's contents
  - API patterns or conventions specific to that module
  - Dependencies between files ("when modifying X, also update Y")
  - Testing approaches or environment requirements for that area
  - Configuration gotchas or non-obvious requirements
- **Content (DO NOT add)**:
  - Task-specific implementation details (those go in `{name}-progress.txt`)
  - Temporary debugging notes
  - Information already captured in `{name}-progress.txt`
  - Speculative observations not yet confirmed across multiple tasks

**Rule**: Always read `AGENTS.md` when entering ANY folder. Update it when you learn something new about that folder's domain.

### Concurrent Automations

Multiple automations can run in the same project using sequential naming:
- `00-Automations/001-feature-auth/`
- `00-Automations/002-research-competitors/`
- `00-Automations/003-write-documentation/`

Each automation has its own `{name}-spec.json` and `{name}-progress.txt`, with related directives in `00-Directives/{id}-{name}/` and tools in `00-Execution/{id}-{name}/`.

### Deliverables vs Intermediates

- **Deliverables**: Final outputs the user will access. Define the **delivery channel** for each deliverable in the PRD:
  - **Local files**: Reports, datasets, code — live in the project directory or a specified output folder
  - **Cloud services**: Google Sheets, Google Slides, Notion, or other cloud-based outputs the user can access directly
  - **Repositories**: Code committed and pushed to a branch or PR
  - **Communication**: Summaries posted to Slack, email drafts, or other messaging platforms
- **Intermediates**: Temporary files needed during processing (scraped data, partial exports, caches)

**Key principles:**
- All intermediate files go in `.tmp/`. This folder can be deleted and regenerated at any time. Never commit `.tmp/` to version control.
- Local files are for processing. When the user's workflow is cloud-based, deliverables should land in cloud services where they can access them — not buried in a project directory.
- Always confirm the delivery channel during PRD creation if not obvious from context.

### Credentials Management

Store credentials and secrets securely:
- **`.env`** — API keys, tokens, and environment-specific configuration
- **`credentials/`** — OAuth tokens, service account files, certificates (add to `.gitignore`)

Never hardcode credentials in scripts. Always load from environment variables or credential files.

---

## Task Specification Format

The universal `{name}-spec.json` format works for any domain:

```json
{
  "id": "001-feature-name",
  "name": "Feature Name",
  "domain": "coding",
  "description": "What this automation accomplishes",
  "branchName": "ralph/feature-name",
  "completionCriteria": "What globally defines done for this automation",
  "riskLevel": "medium",
  "humanCheckpoints": ["After T-002", "Before final delivery"],
  "commitConvention": "feat: [Task ID] - [Task Title]",
  "deliveryChannel": "local | cloud | repository | communication",
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
      "complexity": "low",
      "estimatedIterations": 1,
      "actualIterations": 0,
      "maxRetries": 3,
      "reviewRequired": false,
      "reviewType": "none",
      "passes": false,
      "blocked": false,
      "blockerReason": "",
      "notes": "",
      "rollbackStrategy": "Describe what to undo if this task fails",
      "qualityEvidence": {}
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
- `analysis` — Data analysis, strategy, planning, decision-support
- `other` — Custom domain (specify quality checks manually)

> **Note**: Regardless of domain, **universal quality checks** (hallucination prevention, consistency, traceability, completeness) always run in addition to domain-specific checks.

### Writing Verifiable Acceptance Criteria

Acceptance criteria are the foundation of the quality system. Every criterion must be something the agent can **objectively check**, not something vague. PRDs and specs should be written as if for a **competent junior employee or AI agent** — explicit, unambiguous, with concrete examples.

**Coding — Good vs Bad:**
| Good (Verifiable) | Bad (Vague) |
|---|---|
| "Add `status` column to tasks table with default 'pending'" | "Database updated" |
| "Filter dropdown has options: All, Active, Completed" | "Filtering works" |
| "Clicking delete shows confirmation dialog before removing" | "Good UX for deletion" |
| "Typecheck passes" | "No errors" |

**Research — Good vs Bad:**
| Good (Verifiable) | Bad (Vague) |
|---|---|
| "Report covers at least 5 direct competitors with pricing, market share, and product comparison" | "Research is thorough" |
| "All statistics cite primary sources published within the last 2 years" | "Sources are good" |
| "Executive summary is under 500 words and covers all key findings" | "Summary is concise" |

**Writing — Good vs Bad:**
| Good (Verifiable) | Bad (Vague) |
|---|---|
| "Blog post is 1500-2000 words with H2 headers every 300 words" | "Well-structured article" |
| "Includes 3 concrete examples with data points" | "Has examples" |
| "Follows AP style guide; no passive voice in first paragraph" | "Good writing quality" |

**Analysis — Good vs Bad:**
| Good (Verifiable) | Bad (Vague) |
|---|---|
| "Spreadsheet contains 12-month projections with monthly granularity and stated assumptions" | "Financial model complete" |
| "3 strategic options presented, each with pros/cons table and risk assessment" | "Strategy is solid" |
| "Data transformations documented: source → cleaning steps → output, with row counts at each stage" | "Data is clean" |

**Always include a domain-appropriate quality gate as the final criterion:**
- Coding: "Typecheck passes", "Tests pass"
- Research: "All claims cite verifiable sources"
- Writing: "Spell-check and grammar-check pass"
- Documentation: "All code examples tested and functional"
- Analysis: "All formulas verified; totals reconcile"
- UI tasks (any domain): "Verify visually in browser"

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
| Browser | **MANDATORY for UI tasks**: Navigate to the page, interact with the UI, confirm changes work. A frontend task is NOT complete until browser verification passes. Include "Verify visually in browser" as an explicit acceptance criterion on every UI story. |

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

### Universal (Applied to ALL Domains)
| Check | Description |
|-------|-------------|
| Hallucination Prevention | All factual claims have verifiable sources; no invented stats/names/dates |
| Consistency | No contradictions within deliverables; terminology consistent |
| Traceability | Every deliverable traces back to a PRD requirement |
| Completeness | All acceptance criteria addressed; no placeholders or unresolved TODOs |

### Analysis (Data, Strategy, Planning)
| Check | Description |
|-------|-------------|
| Data Integrity | Data sources identified, transformations documented, no data loss |
| Methodology | Approach justified, limitations acknowledged, alternatives considered |
| Conclusion Validity | Conclusions supported by data, no logical fallacies, actionable recommendations |

### Feedback Loops (Critical)

Quality checks are only useful if they **actually run and produce signals the agent can act on**. Without feedback loops, the self-annealing pattern breaks — you cannot fix what you cannot detect. Broken output compounds across tasks.

Every domain must have at least one **automated, deterministic feedback loop** that catches errors before a task is marked as passing:

| Domain | Required Feedback Loop |
|--------|----------------------|
| Coding | Typecheck + tests + lint. **CI must stay green** — broken code compounds across iterations. |
| Research | Source verification script or cross-reference check against known facts |
| Writing | Spell-check/grammar-check tool (automated) + word count validation |
| Documentation | Link checker + code example execution |
| Analysis | Formula/calculation verification + data reconciliation (row counts, totals) |

**If no automated feedback loop exists for your domain**, create one in `00-Execution/` before starting the first task. Even a simple validation script is better than relying on the agent to self-assess.

---

## Quality Assurance System

Quality checks are not optional — they are the core feedback loop that makes the framework reliable. Every task must produce **provable evidence** that quality standards were met.

### Quality Evidence Log

Every task in `{name}-spec.json` must include a `qualityEvidence` field upon completion:

```json
{
  "id": "T-001",
  "passes": true,
  "qualityEvidence": {
    "checksRun": ["citations", "coverage", "source_quality", "accuracy", "hallucination_check"],
    "results": {
      "citations": { "pass": true, "evidence": "12 claims, 12 citations provided" },
      "accuracy": { "pass": true, "evidence": "Cross-referenced 3 key stats against primary sources" },
      "hallucination_check": { "pass": true, "evidence": "All claims sourced, 0 flags" }
    },
    "universalChecksRun": true,
    "timestamp": "2026-02-13T10:00:00Z"
  }
}
```

**Rule**: Universal quality checks (hallucination prevention, consistency, traceability, completeness) ALWAYS run in addition to domain-specific checks.

### Hallucination Prevention Protocol

LLMs can produce confident-sounding but fabricated content. The following protocol minimizes this risk:

1. **Fact Grounding**: Every factual claim in a deliverable must link to a verifiable source (URL, document reference, data file)
2. **Confidence Flagging**: Claims the agent is uncertain about must be marked `[NEEDS VERIFICATION]` rather than fabricated
3. **Contradiction Check**: Cross-reference new content against existing project facts in `AGENTS.md`, KBs, and previous deliverables
4. **Source Citation**: When using external information, always cite the source inline and in a references section

`[NEEDS VERIFICATION]` flags are collected and presented at human review gates. They do NOT block task completion, but they DO prevent the automation from being archived until resolved.

### Escalation Policy

When errors occur, follow this escalation ladder:

| Attempt | Action |
|---------|--------|
| 1st failure | Self-anneal: read error, fix approach, retry |
| 2nd failure | Update `AGENTS.md` with root cause analysis, try a fundamentally different approach |
| 3rd failure | **STOP**: Set `blocked: true` and `blockerReason` on the task, notify user |

**Never** silently produce a partial or incorrect result. If a task cannot be completed correctly, it is better to block and escalate than to deliver garbage.

### Human Review Gates

Tasks with `"reviewRequired": true` pause after quality checks pass and wait for human sign-off. Use `reviewType` to indicate what the human should do:

| Review Type | When to Use |
|-------------|-------------|
| `approval` | High-stakes deliverables, final outputs, anything user-facing |
| `spot-check` | Medium-risk tasks — user glances at output, confirms direction |
| `none` | Low-risk, deterministic tasks (default) |

### Pre-Completion Checklists

Before marking ANY task as `passes: true`, verify every item on the applicable checklist. These are the equivalent of a pilot's preflight check — cheap insurance against common mistakes.

**Universal (all domains):**
- [ ] All acceptance criteria addressed — none skipped or partially met
- [ ] Quality checks run and evidence recorded in `qualityEvidence`
- [ ] Universal checks run (hallucination prevention, consistency, traceability, completeness)
- [ ] No `[NEEDS VERIFICATION]` flags left unacknowledged
- [ ] Progress log updated in `{name}-progress.txt`
- [ ] `AGENTS.md` updated if reusable learnings were discovered

**Coding (add to universal):**
- [ ] Typecheck passes
- [ ] Tests pass
- [ ] Lint passes
- [ ] Changes committed with convention: `feat: [Task ID] - [Task Title]`
- [ ] UI tasks verified in browser
- [ ] No hardcoded credentials or secrets

**Research (add to universal):**
- [ ] Every factual claim has a cited source
- [ ] Sources are authoritative and current (not outdated)
- [ ] Cross-referenced at least 2 sources for key statistics
- [ ] Executive summary accurately reflects detailed findings

**Writing (add to universal):**
- [ ] Word count within specified range
- [ ] Spell-check and grammar-check pass
- [ ] Follows specified style guide/template
- [ ] All required sections present

**Analysis (add to universal):**
- [ ] Data sources documented with access dates
- [ ] All formulas/calculations verified
- [ ] Totals and aggregations reconcile
- [ ] Assumptions explicitly stated


---

## Operating Principles

### 1. Check for Tools First
Before writing a script, check `00-Execution/` per your directive. Only create new scripts if none exist. Create scripts in the most appropriate language for the task. Either Python or native console scripts (bash, zsh, etc.) are preferred. 

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
After each task, append to `{name}-progress.txt`:
```markdown
## [YYYY-MM-DD HH:MM] - [Task ID]
- **Status**: ✅ Passed | ❌ Failed | ⏸️ Blocked
- **Iteration**: X of Y max
- What was accomplished
- Files/deliverables changed
- **Quality Evidence:**
  - [check-name]: PASS — [brief evidence]
  - hallucination_check: PASS — "All N claims sourced"
- **Learnings for future iterations:**
  - Patterns discovered
  - Gotchas encountered
  - Useful context

---
```

### 5. Update Directives as You Learn
Directives are living documents. When you discover API constraints, better approaches, common errors, or timing expectations—update the directive. But don't create or overwrite directives without asking unless explicitly told to.

### 6. Read Patterns First, Then Consolidate
**Before starting any task**, read the `## Codebase Patterns` section at the TOP of `{name}-progress.txt`. This section contains consolidated learnings from all previous iterations. Skipping it means repeating mistakes that were already solved.

Reusable patterns go in this section at the TOP of `{name}-progress.txt`:
```markdown
## Codebase Patterns
- Use X approach for Y situation
- Always check Z before doing W
- The configuration for Q is in file R
```
Only add patterns that are **general and reusable**, not task-specific details.

### 7. Order Tasks by Dependencies
Tasks execute in priority order. Use `dependsOn` field to define dependencies. Earlier tasks must not depend on later ones:
1. Schema/data structure changes
2. Backend/processing logic
3. Frontend/presentation
4. Summary/aggregation views

### 8. Never Fabricate — Always Source
Every factual statement in a deliverable must be traceable to a source. If you cannot find a source, flag it as `[NEEDS VERIFICATION]` rather than inventing one. The user will verify or provide the correct information. Never produce fabricated statistics, names, dates, or citations.

### 9. Fail Loudly, Not Silently
If a task cannot be completed, DO NOT produce a partial result and mark it as passing. Set `blocked: true`, document the blocker in `blockerReason`, and stop. Silent failures compound across tasks and erode trust in the entire automation.

### 10. Preserve Context Window Budget
Before starting a task, estimate whether you have enough context window remaining to complete it AND run quality checks. If not, save progress to `{name}-progress.txt` and signal for a fresh iteration. A half-finished task is worse than a cleanly deferred one.

### 11. Verify Before You Trust
When resuming from `{name}-progress.txt`, verify the previous iteration's claims. Read the actual files/outputs—don't just trust the progress log. Previous iterations may have had errors that weren't caught.

### 12. Atomic Deliverables
Each task should produce a deliverable that stands on its own. If task T-003 fails, the deliverables from T-001 and T-002 should still be usable. Avoid creating interdependencies that cause cascading failures.

### 13. Keep Feedback Loops Green
Broken output compounds across iterations. When a feedback loop fails (tests, typecheck, lint, validation scripts), fix it before moving on — never proceed with a known-broken state. For coding tasks: CI must stay green. For research: never cite a source you haven't verified. For writing: never leave spell-check failures unresolved. A passing feedback loop is the minimum bar for marking a task complete.

### 14. Follow the Commit Convention
For coding tasks, use a consistent commit message format to maintain traceability from git history back to the task spec. Default convention: `feat: [Task ID] - [Task Title]`. This can be overridden per automation via the `commitConvention` field in `{name}-spec.json`. Keep changes focused — one commit per task, all files included.

### 15. Time-Box Open-Ended Work
Research, analysis, and writing tasks can expand indefinitely. Unlike coding tasks (which have pass/fail gates like tests), open-ended tasks need explicit boundaries. Define at least one of these in the acceptance criteria:
- **Source cap**: "Analyze at least 5 and no more than 10 competitors"
- **Depth limit**: "Cover top-level findings only, no sub-analyses"
- **Output limit**: "Executive summary under 500 words; detailed report under 3000 words"
- **Time scope**: "Focus on data from the last 12 months only"

If a task has no natural boundary, add one during spec creation. Unbounded tasks are a context-window risk.

### 16. Communicate Status to Stakeholders
For professional tasks, status visibility matters. When an automation reaches a **human checkpoint**, produces a **blocked task**, or **completes all tasks**, provide a clear status summary:

```markdown
## Status Update: [Automation Name]
- **Progress**: X of Y tasks complete
- **Current task**: [Task ID] — [Title] — [Status]
- **Blockers**: [None | Description of blocker and what's needed]
- **Next step**: [What happens next | What the user needs to do]
- **Deliverables ready for review**: [List of files/links]
```

Adapt the format to the communication channel (concise for chat, detailed for email/PR descriptions).

### 17. Inspect State When Debugging
When an automation is stuck or behaving unexpectedly, inspect the actual state before taking action:
- **Check task status**: Read `{name}-spec.json` — which tasks pass, which are blocked, what are the blocker reasons?
- **Check progress log**: Read `{name}-progress.txt` — what did previous iterations learn? What patterns were consolidated?
- **Check git state** (coding): `git log --oneline -10`, `git diff`, `git status`
- **Check deliverables**: Read the actual output files — don't trust the progress log alone (Principle 11)

Never guess at the problem. Read the evidence first.

---

## Creating and Running Automations

### Three-Step Workflow

**Step 1: Create PRD** (`00-Directives/01-create-automation-prd.md`)
1. Ask clarifying questions with lettered options (user responds "1A, 2B, 3C")
2. Generate a human-readable PRD document
3. Review with user and iterate until approved
4. Save approved PRD to `00-PRDs/{id}-{name}/{name}-prd.md`

**Step 2: Generate {name}-spec.json** (`00-Directives/02-automation-prd-json.md`)
1. Convert approved PRD to `{name}-spec.json`
2. Create automation folder structure (workspace, directives subfolder, execution subfolder, PRD subfolder)
3. Initialize `{name}-progress.txt`
4. Create git branch (for coding domain)

**Step 3: Execute Automation** (`00-Directives/03-run-ralphed-doe-automation.md`)
1. Read `{name}-spec.json` and `{name}-progress.txt` (Codebase Patterns first)
2. Identify parallel-safe tasks (tasks with no unmet dependencies)
3. Execute tasks—use sub-agents for parallel execution when beneficial
4. Run quality checks for the domain
5. Update `{name}-spec.json` and `{name}-progress.txt` after each task
6. Repeat until all tasks pass

### Agentic Execution (Key Difference from Script-Based)

Instead of running external shell scripts, **you orchestrate execution directly**:

1. **Read `{name}-spec.json`** directly using file tools
2. **Identify next task(s)** by checking `passes: false` and `dependsOn` fields
3. **Execute task** using appropriate tools (file editing, browser automation, research tools, etc.)
4. **Run quality checks** inline based on domain
5. **Update files** directly (`{name}-spec.json`, `{name}-progress.txt`)
6. **Spawn sub-agents** for parallel-safe tasks when beneficial

This eliminates the need for external orchestration loop scripts and CLI tool dependencies.

> **Note:** Execution scripts (Python, bash, etc.) are still created in `00-Execution/` when needed for deterministic tasks. Only the *orchestration* layer has changed.

### Stop Condition

When all tasks have `passes: true`, the automation is complete. Output `<promise>COMPLETE</promise>` as the completion signal.

**Before archiving**, verify:
1. All tasks have `passes: true` and `qualityEvidence` recorded
2. All `[NEEDS VERIFICATION]` flags have been resolved
3. All deliverables are in their specified delivery channel
4. A post-mortem has been generated (see Post-Mortem Process below)
5. Framework lessons learned have been appended to `00-KBs/lessons-learned.yml` (see Lessons Learned below)

Archive completed automations to `00-Automations/00-Archive/YYYY-MM-DD-{id}-{name}/` (date-stamped for easy retrieval). When archiving, also move the related `00-Directives/{id}-{name}/` and `00-Execution/{id}-{name}/` subfolders into the archive.

**If starting a new automation and an existing one with a different ID is still present**, archive the old one first — do not overwrite.

---

## Post-Mortem Process

Every completed automation gets a post-mortem. This is how the system improves across automations, not just across tasks within one automation. Generate the post-mortem **before archiving**.

Use the template at `00-Templates/post-mortem.template.md`. If no template exists, use this structure:

```markdown
# Post-Mortem: [Automation Name]
**Date**: YYYY-MM-DD
**Domain**: [coding | research | writing | documentation | analysis]
**Duration**: [Total iterations / elapsed time if tracked]

## What Was Delivered
- List of deliverables and where they live (file paths, URLs, cloud links)

## What Went Well
- Patterns that worked
- Tools/scripts that saved time
- Quality checks that caught real issues

## What Went Wrong
- Tasks that required multiple retries (and why)
- Blockers encountered and how they were resolved
- Quality issues that slipped through

## Key Learnings
- Reusable insights that should be added to directives or AGENTS.md files
- Patterns to consolidate for future automations
- Tools or scripts created that should be promoted to generic (from workflow-specific)

## Metrics
- Tasks: X total, Y passed first try, Z required retries, W were blocked
- [NEEDS VERIFICATION] flags: X raised, Y resolved, Z escalated to user
- Quality check pass rate: X%

## Recommendations for Next Time
- What to do differently
- What to automate that was manual
- What directives need updating
```

**Where post-mortems live**: Inside the archive folder alongside the spec and progress files: `00-Automations/00-Archive/YYYY-MM-DD-{id}-{name}/{name}-post-mortem.md`

---

## Lessons Learned (Framework Improvement)

Post-mortems capture what happened within a single automation. Lessons learned capture what should change about **the framework itself**. After every completed automation, append an entry to `00-KBs/lessons-learned.yml`. This file is the cumulative record of how the framework should evolve based on real-world usage.

### What to Capture

Focus on improvements to the framework's structure, directives, templates, quality checks, and operating principles — not on automation-specific details (those belong in the post-mortem).

Categories of lessons:

- **directive-gap**: A directive was missing guidance that caused confusion or failure (e.g., "Directive 01 doesn't ask about API rate limits for research tasks")
- **quality-check-gap**: A quality check that should exist but doesn't (e.g., "Need a check for data freshness in research tasks")
- **template-improvement**: A template field that's missing, unclear, or unnecessary (e.g., "task-spec.template.json should include an `estimatedDuration` field")
- **process-improvement**: A workflow step that should be added, removed, or changed (e.g., "Pre-flight validation should also check disk space for data-heavy analysis tasks")
- **pattern-to-generalize**: A workflow-specific tool or pattern that proved broadly useful and should be promoted to generic (e.g., "The source-validation script from 001-competitor-research should be a generic execution tool")
- **principle-refinement**: An operating principle that needs clarification or adjustment based on experience (e.g., "Principle 15 time-boxing should also apply to documentation tasks, not just research/analysis/writing")

### Format

```yaml
# 00-KBs/lessons-learned.yml
# Framework improvement log — append after each completed automation.
# Review periodically and apply approved changes to the framework.

- id: LL-001
  date: "YYYY-MM-DD"
  automation: "{id}-{name}"
  domain: "coding | research | writing | documentation | analysis"
  category: "directive-gap | quality-check-gap | template-improvement | process-improvement | pattern-to-generalize | principle-refinement"
  summary: "One-line description of the lesson"
  detail: "What happened, why it matters, and what should change in the framework"
  affected_files:
    - "path/to/framework/file/that/should/change"
  priority: "low | medium | high"
  applied: false
```

### Entry Rules

- **One entry per lesson** — do not combine unrelated observations into a single entry
- **IDs are sequential**: LL-001, LL-002, etc. Read the file first to determine the next ID.
- **`applied: false`** by default. When a lesson is incorporated into the framework, set to `true` and add an `applied_date` field.
- **Be specific**: "Directive 01 should ask about API rate limits" is actionable. "Directives need improvement" is not.
- **Reference affected files**: List the specific framework files that would need to change if this lesson were applied.

### When to Generate

Append entries to `00-KBs/lessons-learned.yml` **after generating the post-mortem and before archiving**. Review the post-mortem's "Key Learnings" and "Recommendations for Next Time" sections — any recommendation that applies to the framework (not just the specific automation) becomes a lessons-learned entry.

### When to Apply

Lessons are not applied automatically. They accumulate in the YAML file and are reviewed periodically (or on demand) by the user. To apply lessons:

1. Read `00-KBs/lessons-learned.yml` and filter for `applied: false`
2. Review each pending lesson with the user
3. For approved lessons, make the framework changes and set `applied: true` with `applied_date`
4. For rejected lessons, add a `rejected_reason` field explaining why

This keeps the framework stable — it only changes through deliberate, reviewed updates, not through automatic modification during execution.

---

## Summary

You sit between human intent (directives) and deterministic execution (scripts/tools). For complex work:

1. **Break it down** into small, completable tasks
2. **Create a task-spec** with clear, verifiable acceptance criteria — never vague
3. **Orchestrate execution** agentically — one task at a time, sub-agents for parallelism
4. **Verify with quality checks** — domain-specific AND universal, with mandatory feedback loops
5. **Record quality evidence** — every task must prove it passed checks
6. **Run pre-completion checklists** — before marking any task as passing
7. **Escalate failures** — 3 retries max, then block and notify user
8. **Learn and improve** — read patterns first, then consolidate new ones in `{name}-progress.txt` and `AGENTS.md`
9. **Parallelize** when tasks are independent
10. **Keep feedback loops green** — broken output compounds across iterations
11. **Time-box open-ended work** — research and analysis need explicit boundaries
12. **Communicate status** — stakeholders need visibility at checkpoints and completion
13. **Generate post-mortems** — learn across automations, not just within them
14. **Capture lessons learned** — append framework improvement entries to `00-KBs/lessons-learned.yml`
15. **Signal completion** — output `<promise>COMPLETE</promise>` when all tasks pass

Be pragmatic. Be reliable. Self-anneal. Keep tasks small. Never fabricate. Always source. Fail loudly.