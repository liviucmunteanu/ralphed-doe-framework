# DOE + Ralph Framework

A template framework for building reliable AI-powered automations using a 3-layer architecture (Directives, Orchestration, Execution) enhanced with Ralph's autonomous execution pattern.

## What This Is

This framework enables AI agents to complete complex, multi-step tasks reliably by:

- **Separating concerns** — Directives define *what*, you orchestrate *how*, scripts *execute*
- **Pushing complexity into deterministic code** — Reducing compounding LLM errors
- **Using fresh context per iteration** — Avoiding context window exhaustion on large tasks
- **Domain-specific quality checks** — Ensuring outputs meet standards before completion

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
cp .env.example .env  # If example exists, or create new:
touch .env

# Add your API keys and configuration
echo "OPENAI_API_KEY=your-key-here" >> .env
echo "ANTHROPIC_API_KEY=your-key-here" >> .env

# Create required directories
mkdir -p .tmp
mkdir -p .tmp/archive
mkdir -p credentials
mkdir -p automations/archive

# Add to .gitignore (if not already present)
echo ".tmp/" >> .gitignore
echo ".env" >> .gitignore
echo "credentials/" >> .gitignore
```

### 3. Configure Your AI Agent

Copy the agent instructions to your AI tool's configuration:

| AI Tool | Configuration File |
|---------|-------------------|
| Claude Code | `CLAUDE.md` |
| GitHub Copilot | `AGENTS.md` |
| Google Gemini | `GEMINI.md` |

```bash
# Example: Set up for Claude Code
cp AGENTS-Instructions-AgenticWorkflows.md CLAUDE.md
```

## Directory Structure

```
project/
├── README.md                                 # This file
├── AGENTS-Instructions-AgenticWorkflows.md   # Agent instructions (copy to CLAUDE.md, etc.)
├── directives/                               # SOPs in Markdown (Layer 1)
│   ├── plan-automation.md                    # Step 1: Plan with user
│   ├── create-automation.md                  # Step 2: Generate automation files
│   └── run-automation.md                     # Step 3: Execute automation
├── execution/                                # Deterministic scripts (Layer 3)
├── templates/                                # Reusable templates
│   ├── task-spec.template.json
│   ├── loop-script.template.sh
│   └── quality-checks/                       # Domain-specific validation
│       ├── coding.json
│       ├── research.json
│       ├── writing.json
│       └── documentation.json
├── automations/                              # Active automation runs
│   └── archive/                              # Completed automations
├── .tmp/                                     # Intermediate files (gitignored)
│   └── archive/                              # Archived intermediates
├── credentials/                              # OAuth tokens, certs (gitignored)
└── .env                                      # Environment variables (gitignored)
```

## Usage

### For Simple Tasks (Interactive Mode)

Just ask your AI agent directly. It will check `execution/` for existing tools and use them.

### For Complex Tasks (Ralph Mode)

Use the two-step workflow:

**Step 1: Plan**
```
Run directives/plan-automation.md for: [describe your goal]
```

The agent will ask clarifying questions and generate a human-readable plan for your approval.

**Step 2: Create & Execute**
```
Run directives/create-automation.md using the approved plan
```

This generates:
- `automations/{id}-{name}/task-spec.json` — Task definitions
- `automations/{id}-{name}/progress.txt` — Memory across iterations
- `automations/{id}-{name}/{name}-ralph-loop.sh` — Loop script

**Step 3: Run**
```bash
./automations/001-feature-name/001-feature-name-ralph-loop.sh --max-iterations 10 --tool claude
```

## Adding Custom Scripts

Add new execution scripts to `execution/`:

```python
# execution/my_custom_tool.py
"""
Description of what this tool does.
Usage: python execution/my_custom_tool.py --arg1 value
"""
import os
from dotenv import load_dotenv

load_dotenv()

def main():
    # Your deterministic logic here
    pass

if __name__ == "__main__":
    main()
```

Update or create a directive in `directives/` that references your new tool.

## Key Principles

1. **Check for tools first** — Don't reinvent; use existing scripts
2. **Self-anneal** — Errors improve the system (fix → update → test)
3. **Keep tasks small** — Each task must complete in one context window
4. **Update directives** — They're living documents, improve them as you learn
5. **Archive, don't delete** — Move completed work to `archive/` folders

## Learn More

- [Full Agent Instructions](./AGENTS-Instructions-AgenticWorkflows.md)
- [Plan Automation Directive](./directives/plan-automation.md)
- [Create Automation Directive](./directives/create-automation.md)
- [Run Automation Directive](./directives/run-automation.md)

## License

MIT
