# Ralphed-DOE Framework

A template framework for building reliable AI-powered automations using a **3-layer architecture** (Directives, Orchestration, Execution) enhanced with Ralph's **autonomous execution pattern**.

## What This Is

This framework enables AI agents to complete complex, multi-step tasks reliably by:

- **Separating concerns** — Directives define *what*, you orchestrate *how*, scripts *execute*
- **Agentic Orchestration** — The agent reads the plan and orchestrates execution directly (no shell scripts)
- **Context Persistence** — `AGENTS.md` files act as a "shared brain" across sessions
- **Self-Annealing** — The system gets smarter over time as agents update their context documents

Works for any domain: coding, research, writing, documentation, and more.

## Quick Start

### 1. Clone This Template

```bash
git clone <this-repo> my-project
cd my-project
rm -rf .git && git init  # Start fresh git history
```

### 2. Set Up Environment

```bash
# Create environment file
cp .env.example .env  # or touch .env

# Add your API keys
echo "OPENAI_API_KEY=your-key-here" >> .env
echo "ANTHROPIC_API_KEY=your-key-here" >> .env

# Create required directories
mkdir -p .tmp
mkdir -p .tmp/archive
mkdir -p credentials
mkdir -p automations/archive
mkdir -p automations/prds

# Add to .gitignore
echo ".tmp/" >> .gitignore
echo ".env" >> .gitignore
echo "credentials/" >> .gitignore
echo "KBs/" >> .gitignore
```

### 3. Initialize Global Context

Create the root `AGENTS.md` file:

```markdown
# Global Agent Context

> **Purpose**: This file serves as the shared brain for the entire project.

## High-Level Architecture
- We use the Ralphed-DOE framework.
- All automations live in `automations/`.

## Shared Constraints
- Valid JSON for task-specs.
- Python/Bash for execution tools.
```

### 4. Configure Your AI Agent

Copy the agent instructions to your AI tool's configuration:

```bash
# For Claude Code / Cursor / Windsurf
cp AGENTS-Instructions-AgenticWorkflows.md .cursorrules  # or CLAUDE.md
```

## Directory Structure

```
project/
├── AGENTS-Instructions-AgenticWorkflows.md   # Main Agent Instructions
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
├── automations/                              # Active and archived runs
│   ├── AGENTS.md                             # Context for automations root
│   ├── 001-feature-name/
│   │   ├── task-spec.json
│   │   ├── progress.txt
│   │   ├── AGENTS.md                         # WORKFLOW-SPECIFIC context
│   │   ├── directives/                       # WORKFLOW-SPECIFIC directives
│   │   └── execution/                        # WORKFLOW-SPECIFIC tools
│   ├── prds/                                 # PRD documents
│   └── archive/                              # Completed automations
├── KBs/                                      # Knowledge base articles
└── .tmp/                                     # Intermediate files (gitignored)
```

## Usage: The 3-Step Workflow

For complex tasks, use the Ralphed-DOE workflow:

### Step 1: Create PRD
**Goal**: Clarify requirements and get user approval.

```
Run directives/01-create-automation-prd.md for: [describe your goal]
```

### Step 2: Create JSON Plan
**Goal**: Convert approved PRD into a machine-readable task spec and set up folders.

```
Run directives/02-automation-prd-json.md using: [path to approved PRD]
```

### Step 3: Run Automation
**Goal**: The agent orchestrates the execution of tasks.

```
Run directives/03-run-ralphed-doe-automation.md for: automations/{id}-{name}/
```

## Key Principles

1. **Context First** — Always read `AGENTS.md` when entering a folder.
2. **Generic vs Specific** — Use workflow-specific `directives/` and `execution/` folders for custom needs.
3. **Self-Annealing** — Update `AGENTS.md` and `progress.txt` when you learn something new.
4. **Agent Orchestration** — You are the loop. Read `task-spec.json`, execute tasks, update status.

## Adding Custom Tools

1. **Workflow-Specific**: Place script in `automations/{id}-{name}/execution/`. The agent checks here first.
2. **Generic**: Place script in `execution/` if it's useful for multiple automations.

## License

MIT
