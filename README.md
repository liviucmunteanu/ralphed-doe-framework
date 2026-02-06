# 🚀 Ralphed-DOE Framework

**Your AI agents' favorite automation playground.**

Think of this as a template for teaching AI agents how to get real work done—from research to coding to everything in between. It's like giving your AI assistant a Swiss Army knife, a map, and a memory that actually works across sessions.

## 🎯 What's This All About?

Ever asked an AI to do something complex and watched it forget what it was doing halfway through? Or seen it confidently complete a task... incorrectly? Yeah, we've all been there.

This framework solves that by:

- **📋 Separating concerns** — Think of it like a kitchen: directives are the recipes, you're the chef deciding what to cook, and scripts are the actual cooking
- **🤖 Agentic Orchestration** — Your AI reads the plan and manages everything itself (no janky shell scripts needed)
- **🧠 Context Persistence** — `AGENTS.md` files act as your AI's "memory" across sessions (because nobody likes repeating themselves)
- **🔄 Self-Annealing** — The system literally gets smarter over time as your agents update their own docs

**TL;DR**: It works for coding, research, writing, documentation—basically anything where you'd otherwise be manually coordinating a complex multi-step process.

---

## 🏃 Quick Start (The "Let the Agent Do It" Method)

### Step 1: Grab the Framework

```bash
git clone <this-repo> my-awesome-project
cd my-awesome-project
rm -rf .git && git init  # Fresh start, clean slate
```

### Step 2: Let Your AI Agent Set Everything Up

Here's where it gets cool. Instead of running a bunch of manual commands, just ask your AI agent:

> **"Hey, instantiate the development environment according to `AGENTS-Instructions-AgenticWorkflows.md`"**

Your agent will:
- Create all the necessary directories (`.tmp/`, `automations/`, etc.)
- Set up your `.env` file with placeholders for API keys
- Copy the framework instructions to the right config files (`AGENTS.md`, `GEMINI.md`, `CLAUDE.md`, `.cursorrules`, etc.)
- Initialize all the `AGENTS.md` context files in the right folders
- Make sure your `.gitignore` is properly configured

**Pro tip**: The agent knows what to do because `AGENTS-Instructions-AgenticWorkflows.md` contains all the setup logic. You're literally just asking it to follow its own instructions. Meta, right?

### Step 3: Add Your API Keys

Open `.env` and add your actual keys:

```bash
OPENAI_API_KEY=sk-your-actual-key
ANTHROPIC_API_KEY=sk-your-actual-key
# Add whatever else you need
```

**Done!** Your agent is now fully configured and ready to roll.

---

## 📂 What's Inside (The Directory Tour)

```
your-project/
├── AGENTS-Instructions-AgenticWorkflows.md   # 📖 The "agent manual"
├── directives/                               # 📋 Generic how-to guides (shared)
│   ├── AGENTS.md                             # 🧠 Context: "What these directives do"
│   ├── 01-create-automation-prd.md           # Step 1: Plan it
│   ├── 02-automation-prd-json.md             # Step 2: Structure it
│   └── 03-run-ralphed-doe-automation.md      # Step 3: Execute it
├── execution/                                # 🔧 Generic tools (shared scripts)
│   └── AGENTS.md                             # 🧠 Context: "What these tools do"
├── templates/                                # 📄 Reusable templates
│   ├── task-spec.template.json               # Task definition blueprint
│   └── quality-checks/                       # Domain-specific validators
├── automations/                              # 🎯 Where the magic happens
│   ├── AGENTS.md                             # 🧠 Context: "How automations work here"
│   ├── 001-feature-name/                     # Example automation
│   │   ├── task-spec.json                    # What needs to be done
│   │   ├── progress.txt                      # Learning log
│   │   ├── AGENTS.md                         # 🧠 Context: "This specific workflow"
│   │   ├── directives/                       # Custom SOPs just for this
│   │   └── execution/                        # Custom tools just for this
│   ├── prds/                                 # Planning documents
│   └── archive/                              # Completed work (don't delete, archive!)
├── KBs/                                      # 📚 Your growing knowledge base
└── .tmp/                                     # Scratch space (gitignored)
```

**See all those `AGENTS.md` files?** They're like breadcrumbs your AI leaves for itself. Each folder gets its own context file so agents know exactly what they're looking at.

---

## 🎬 How to Actually Use This (The 3-Step Dance)

Got a complex task? Here's the workflow:

### 🔍 Step 1: Create a PRD (Plan It Out)

Tell your agent what you want:

```
Run directives/01-create-automation-prd.md for: "Build a feature that does X"
```

The agent will ask clarifying questions and write up a plan for you to approve. Think of it as having a really detail-oriented coworker who wants to make sure they understand before diving in.

### 📐 Step 2: Convert to JSON (Structure It)

Once you approve the plan:

```
Run directives/02-automation-prd-json.md using: automations/prds/my-plan.md
```

This breaks your plan into discrete tasks and sets up all the folders. It's like creating a project board, but for an AI.

### ⚡ Step 3: Let It Rip (Execute It)

Now the agent takes over:

```
Run directives/03-run-ralphed-doe-automation.md for: automations/001-my-feature/
```

The agent will work through each task, run quality checks, learn from failures, and keep going until everything passes. You can walk away and come back to completed work. (Or watch it work. We won't judge.)

---

## 💡 The Secret Sauce (Key Principles)

1. **🧠 Context First** — Agents always read `AGENTS.md` when entering a folder. It's their orientation.
2. **🎯 Generic vs Specific** — Got a tool that's useful everywhere? Put it in `execution/`. Just for this workflow? Use `automations/{workflow}/execution/`.
3. **📝 Self-Annealing** — When the agent learns something ("Oh, this library has a weird quirk"), it updates `AGENTS.md`. Future runs benefit from past lessons.
4. **🔁 Agent Orchestration** — The agent *is* the loop. It reads `task-spec.json`, executes tasks, checks quality, and keeps going.

---

## 🛠️ Adding Your Own Tools

**Workflow-Specific Tool** (only this automation needs it):
```bash
# Put it here
automations/001-my-feature/execution/my_custom_script.py
```

**Generic Tool** (useful across multiple automations):
```bash
# Put it here
execution/my_reusable_tool.py
```

The agent checks workflow-specific folders first, then falls back to generic ones. Smart, right?

---

## 🤔 Wait, So What's Different From Just Using An AI?

Good question! Here's what this framework adds:

| Regular AI Chat | Ralphed-DOE Framework |
|---|---|
| Forgets context after a few messages | Persistent memory via `AGENTS.md` |
| You manually coordinate steps | Agent manages the whole workflow |
| Repeats mistakes on new runs | Learns and improves via `progress.txt` |
| Generic approach for everything | Domain-specific quality checks |
| Hope it works | Validation at every step |

Think of it as the difference between asking someone to "cook dinner" versus giving them a recipe, a well-stocked kitchen, and a checklist.

---

**Questions? Suggestions? Found a bug?** Open an issue or submit a PR. This framework gets better when people use it and share what they learn.

Now go build something cool. 🚀