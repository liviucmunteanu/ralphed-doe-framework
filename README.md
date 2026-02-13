# Ralphed-DOE Framework

A structured framework for running complex, multi-step professional tasks through AI agents. It works across any domain — coding, research, writing, documentation, data analysis, and strategy — by separating what to do (directives) from how to decide (orchestration) from how to execute (deterministic scripts and tools).

The framework is built on two foundations: the [DOE (Directive-Orchestration-Execution) architecture](https://en.wikipedia.org/wiki/Separation_of_concerns) for reliability, and [Geoffrey Huntley's Ralph pattern](https://ghuntley.com/ralph/) for autonomous multi-iteration execution. The combination produces a system where AI agents can tackle large projects across multiple context windows while maintaining quality, learning from failures, and producing auditable evidence of their work.

---

## Why This Exists

AI agents are powerful but unreliable at scale. A single request might succeed 90% of the time, but chain five steps together and your success rate drops to 59%. The problems compound:

- Agents forget context between sessions
- Errors in early steps cascade into later steps undetected
- Confident-sounding hallucinations contaminate deliverables
- There is no record of what was checked, what was verified, or what was assumed
- Complex tasks exceed a single context window, and there is no handoff mechanism

This framework addresses each of these by pushing complexity into deterministic code, persisting memory across sessions, requiring provable quality evidence at every step, and providing a structured handoff protocol for multi-window work.

---

## Architecture

The framework uses a 3-layer architecture:

**Layer 1 — Directives (What to do):** SOPs written in Markdown that define goals, inputs, tools, outputs, and edge cases. Written as if for a competent mid-level employee or AI agent — explicit, unambiguous, free of unexplained jargon.

**Layer 2 — Orchestration (Decision making):** The AI agent itself. It reads directives, calls execution tools in the right order, handles errors, asks for clarification, and updates directives with learnings. For multi-step automations, the agent reads the task spec directly and manages execution — no external loop scripts required.

**Layer 3 — Execution (Doing the work):** Deterministic scripts (Python, bash, etc.) that handle API calls, data processing, file operations, and validation. Domain-specific quality checks verify each task's output. The agent orchestrates; the scripts execute.

This separation means the agent focuses on decision-making while reliability-critical operations run as deterministic code.

---

## Directory Structure

```
project/
├── AGENTS-Instructions-AgenticWorkflows.md   # Framework reference (the "agent manual")
├── README.md                                 # This file
├── 00-Directives/                            # Generic directives (shared across automations)
│   ├── AGENTS.md
│   ├── 01-create-automation-prd.md           # Step 1: Clarify requirements, create PRD
│   ├── 02-automation-prd-json.md             # Step 2: Convert PRD to task spec JSON
│   ├── 03-run-ralphed-doe-automation.md      # Step 3: Execute tasks agentically
│   └── {id}-{name}/                          # Workflow-specific directives
│       └── AGENTS.md
├── 00-Execution/                             # Generic execution scripts (shared)
│   ├── AGENTS.md
│   └── {id}-{name}/                          # Workflow-specific scripts
│       └── AGENTS.md
├── 00-Templates/                             # Reusable templates
│   ├── AGENTS.md
│   ├── task-spec.template.json
│   ├── loop-script.template.sh
│   ├── post-mortem.template.md
│   └── quality-checks/                       # Domain-specific quality check definitions
│       ├── AGENTS.md
│       ├── universal.json                    # Cross-domain checks (always run)
│       ├── coding.json
│       ├── research.json
│       ├── writing.json
│       ├── documentation.json
│       └── analysis.json
├── 00-Automations/                           # Active automation workspaces
│   ├── AGENTS.md
│   ├── 00-Archive/                           # Completed automations (date-stamped)
│   │   └── AGENTS.md
│   └── {id}-{name}/                          # One automation
│       ├── {name}-spec.json                  # Task specification
│       ├── {name}-progress.txt               # Learning log with consolidated patterns
│       └── AGENTS.md                         # Context and self-annealing
├── 00-PRDs/                                  # Approved PRD documents
│   ├── AGENTS.md
│   └── {id}-{name}/
│       └── {name}-prd.md
├── 00-Reviews/                               # Human review staging area
│   └── AGENTS.md
├── 00-KBs/                                   # Knowledge base (reference material)
│   └── AGENTS.md
├── 00-Agentic-Workflows-Request-Prompts/     # Copy-paste prompt templates
│   ├── AGENTS.md
│   ├── start-new-automation.md               # Full 3-step automation kickoff
│   ├── resume-automation.md                  # Continue an in-progress automation
│   └── quick-task.md                         # Single-shot interactive tasks
├── .tmp/                                     # Intermediate files (gitignored)
└── .env                                      # API keys and credentials
```

Every folder contains an `AGENTS.md` file that serves as the localized memory for that context. Agents read it when entering a folder and update it when they learn something future agents should know.

---

## Setup

### 1. Clone and Initialize

```bash
git clone <this-repo> my-project
cd my-project
rm -rf .git && git init
```

### 2. Configure Environment

Create a `.env` file with your API keys and credentials:

```bash
cp .env.example .env  # If an example exists, or create from scratch
```

Add the keys your automations will need. Never hardcode credentials in scripts.

### 3. Copy Framework Instructions to Your AI Tool

The framework instructions in `AGENTS-Instructions-AgenticWorkflows.md` need to be accessible to your AI agent. How you do this depends on your tool:

- **Claude Code**: The file is read automatically if present in the project root. You can also copy relevant sections to `CLAUDE.md`.
- **Amp**: Copy to `prompt.md` in your project's scripts directory, or install as a skill.
- **Cursor / Other**: Copy to `.cursorrules` or the equivalent configuration file.

The agent needs access to the framework file to understand the architecture, quality standards, and operating principles.

---

## How to Use the Framework

### Option A: Full Automation (3+ Tasks, Complex Work)

Use this for multi-step projects: research reports, feature development, documentation suites, strategic analyses.

**1. Pick a prompt template** from `00-Agentic-Workflows-Request-Prompts/start-new-automation.md`. Choose the universal template or one of the domain-specific quick-starts (research, writing, coding, documentation, analysis).

**2. Fill in the placeholders** and paste the prompt to your AI agent. The prompt instructs the agent to follow the three-step workflow:

- **Step 1 — Create PRD** (`01-create-automation-prd.md`): The agent asks clarifying questions (domain-specific and cross-domain: delivery channel, scope boundaries), generates a structured PRD with verifiable acceptance criteria, and presents it for your approval.

- **Step 2 — Generate Task Spec** (`02-automation-prd-json.md`): The agent converts the approved PRD into a `{name}-spec.json` file with tasks, dependencies, quality requirements, and acceptance criteria. It creates the folder structure and initializes the progress log.

- **Step 3 — Execute** (`03-run-ralphed-doe-automation.md`): The agent works through tasks one at a time — reading consolidated patterns first, running quality checks after each task, recording quality evidence, and updating the progress log. Tasks requiring human review pause for your sign-off. When all tasks pass, the agent generates a post-mortem and archives the automation.

**3. Review and iterate.** The agent will pause at human checkpoints you defined in the PRD. You approve, request changes, or resolve blockers as needed.

### Option B: Resume an Existing Automation

When an automation spans multiple context windows (new chat session, fresh agent instance), use `00-Agentic-Workflows-Request-Prompts/resume-automation.md`. The agent reads the spec, progress log, and AGENTS.md to pick up exactly where the previous session left off.

Variants are provided for: standard resume, resume after resolving a blocker, and final review/archiving.

### Option C: Quick Interactive Task

For small, single-shot tasks (fewer than 3 steps, no dependencies), use `00-Agentic-Workflows-Request-Prompts/quick-task.md`. This applies the framework's quality standards without the full PRD/spec overhead.

---

## Supported Domains

The framework supports six domains, each with specific quality checks:

| Domain | Quality Checks | Example Tasks |
|--------|---------------|---------------|
| Coding | Security, typecheck, tests, lint, browser verification | Feature development, bug fixes, refactoring |
| Research | Citations, coverage, source quality, accuracy | Competitive analysis, market research, literature review |
| Writing | Grammar, readability, format, completeness | Blog posts, reports, white papers, email sequences |
| Documentation | Links, API accuracy, examples, structure | API references, user guides, tutorials |
| Analysis | Data integrity, methodology, conclusion validity | Financial models, strategic planning, data analysis |
| Other | Custom (specify manually) | Anything not covered above |

Universal quality checks (hallucination prevention, consistency, traceability, completeness) run on every task in every domain.

---

## Key Concepts

### Quality Evidence

Every task must produce provable evidence that quality checks passed. This is recorded in the `qualityEvidence` field of `{name}-spec.json` — not just a boolean "it passed," but what was checked and what the evidence was. This makes the automation auditable.

### Feedback Loops

Quality checks only work if they actually run and produce signals the agent can act on. Every domain must have at least one automated, deterministic feedback loop (typecheck for coding, source verification for research, spell-check for writing, etc.). If none exists, the agent creates one before starting the first task.

### Pre-Completion Checklists

Before marking any task as passing, the agent runs a domain-specific checklist (universal items plus domain-specific items). These function as a pilot's preflight check — a final gate before the task is recorded as complete.

### Verifiable Acceptance Criteria

The framework requires that every acceptance criterion be objectively verifiable. "Works correctly" is not acceptable. "Filter dropdown has options: All, Active, Completed" is. The framework includes good vs bad examples for every domain in the main instructions file.

### Self-Annealing

When something breaks, the agent fixes it, updates the relevant `AGENTS.md` and progress log with what it learned, and the system becomes stronger. Future iterations (and future agents) benefit from past failures. The escalation policy caps this at 3 retries — if it still fails, the task is blocked and the user is notified.

### Context Persistence

Memory across sessions is maintained through three mechanisms:
- `AGENTS.md` files: Localized context per folder (architectural decisions, warnings, patterns)
- `{name}-progress.txt`: Consolidated codebase patterns at the top, per-task learnings below
- `{name}-spec.json`: Task status, quality evidence, blocker reasons

When an agent enters a new context window, it reads all three to reconstruct the state.

### Time-Boxing

Open-ended tasks (research, analysis, writing) can expand indefinitely. The framework requires explicit boundaries in acceptance criteria: source count, word count, depth limit, or time scope. Unbounded tasks are a context-window risk.

### Post-Mortems

Every completed automation gets a post-mortem before archiving. This captures what was delivered, what worked, what failed, key learnings, metrics, and recommendations. Post-mortems are how the system improves across automations, not just across tasks within one automation.

---

## How Tools and Directives Are Organized

The framework distinguishes between generic and workflow-specific components:

- **Generic** (shared): Reusable across many automations. Live in the root of `00-Directives/` and `00-Execution/`.
- **Workflow-specific**: Relevant only to one automation. Live in subfolders named `{id}-{name}/` within `00-Directives/` and `00-Execution/`.

Lookup order: workflow-specific first, then generic fallback. This allows specific automations to override generic behaviors without cluttering the shared namespace.

When an automation is archived, its workflow-specific directives and tools are moved into the archive alongside the spec and progress files. Generic components remain available for future automations.

---

## Naming Conventions

- **Automation IDs**: 3-digit zero-padded (`001`, `002`, `003`)
- **Names**: Kebab-case, max 3-4 words (`competitor-research`, `api-documentation`)
- **Full format**: `{id}-{name}` (e.g., `001-competitor-research`)
- **`{name}` reference**: The kebab-case part without the numeric prefix
- **Archive folders**: Date-stamped: `YYYY-MM-DD-{id}-{name}/`
- **Commit messages** (coding domain): `feat: [Task ID] - [Task Title]`

---

## Credentials and Secrets

- `.env` — API keys, tokens, environment-specific configuration
- `credentials/` — OAuth tokens, service account files, certificates (add to `.gitignore`)
- `.tmp/` — Intermediate processing files (gitignored, can be deleted and regenerated)

Never hardcode credentials in scripts. Always load from environment variables or credential files.

---

## Comparison to Unstructured AI Usage

| Unstructured AI Chat | Ralphed-DOE Framework |
|---|---|
| Forgets context between sessions | Persistent memory via AGENTS.md, progress.txt, spec.json |
| You manually coordinate steps | Agent manages the workflow end to end |
| Repeats mistakes across runs | Learns and consolidates patterns |
| Generic approach for everything | Domain-specific quality checks and feedback loops |
| No verification of output quality | Quality evidence recorded at every step |
| Silent failures compound | Escalation policy: 3 retries, then block and notify |
| Confident hallucinations go undetected | Hallucination prevention protocol with [NEEDS VERIFICATION] flags |
| No review process | Human review gates with status communication |
| One-shot, no iteration | Multi-window execution with structured handoff |
| No record of what was done | Full audit trail: PRD, spec, progress, quality evidence, post-mortem |

---

## References

- [AGENTS-Instructions-AgenticWorkflows.md](AGENTS-Instructions-AgenticWorkflows.md) — The complete framework specification
- [Geoffrey Huntley's Ralph pattern](https://ghuntley.com/ralph/) — The autonomous agent loop that inspired the execution model
- [00-Agentic-Workflows-Request-Prompts/](00-Agentic-Workflows-Request-Prompts/) — Ready-to-use prompt templates for all scenarios
