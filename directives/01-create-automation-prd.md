# Create PRD for Automation Directive

Clarify requirements and create a human-readable automation plan before converting to task-spec.json.

## Purpose

This is **Step 1** of the three-step automation workflow:
1. **Create PRD for the Automation** (this directive) → Creates readable plan, gets approval
2. **Create Automation PRD JSON File** (`02-automation-prd-json.md`) → Converts approved plan to task-spec.json
3. **Run Ralphed-DOE Automation** (`03-run-ralphed-doe-automation.md`) → Executes tasks agentically

## Inputs

- **Request**: User's description of what to automate
- **Domain**: coding | research | writing | documentation | other

## Steps

### 1. Ask Clarifying Questions

Ask 3-5 essential questions with **lettered options** for quick response.

**Format questions like this:**
```
1. What is the primary goal?
   A. [Option based on domain]
   B. [Option based on domain]
   C. [Option based on domain]
   D. Other: [please specify]

2. What is the scope?
   A. Minimal viable version
   B. Full-featured implementation
   C. Just research/discovery
   D. Just the outline/structure
```

Users can respond with "1A, 2C, 3B" for quick iteration.

### Domain-Specific Questions

**Coding:**
- What problem does this solve?
- Who is the target user?
- Frontend, backend, or full-stack?
- What existing components can be reused?
- What are the quality requirements?

**Research:**
- What is the research question?
- What depth (overview vs. deep-dive)?
- What sources are preferred?
- What format for deliverables?
- What is the deadline/timeline?

**Writing:**
- Who is the target audience?
- What is the tone (formal, casual, technical)?
- What is the word count/length?
- What format (blog, report, copy, etc.)?
- Are there examples to follow?

**Documentation:**
- What type (API, user guide, tutorial)?
- Who is the audience (developers, end-users)?
- What existing docs to reference?
- What sections are required?
- What level of detail?

### 2. Generate Automation Plan

After getting answers, create a markdown plan document.

**Save to:** `automations/prds/{next-id}-{name}-prd.md`

**Template:**

```markdown
# Automation Plan: {Name}

## Overview
Brief description of what this automation accomplishes.

## Goals
- Specific goal 1
- Specific goal 2
- Specific goal 3

## Tasks
Break down into small, independently completable tasks.

### T-001: {Task Title}
**Description:** What to accomplish
**Acceptance Criteria:**
- [ ] Criterion 1 (verifiable)
- [ ] Criterion 2 (verifiable)
- [ ] Domain quality check passes

### T-002: {Task Title}
...

## Non-Goals (Out of Scope)
What this automation will NOT include.

## Quality Requirements
- Domain-specific checks to run
- Success criteria

## Deliverables
- List of expected outputs

## Open Questions
Any unresolved issues that need clarification.
```

### 3. Review with User

Present the plan and ask for approval:
- Are tasks sized correctly?
- Is the ordering right?
- Anything missing?
- Anything to remove?

**Do NOT proceed to create-automation.md until user approves.**

## Task Sizing Guidance

**Right-sized tasks (completable in one iteration):**

| Domain | Good Task Size |
|--------|---------------|
| Coding | Add one component, one endpoint, one migration |
| Research | Research one topic, analyze one competitor |
| Writing | Write one section, create one outline |
| Documentation | Document one module, one API endpoint |

**Too big (split these):**
- "Build the feature" → schema, backend, frontend, tests
- "Research the market" → competitors, trends, pricing
- "Write the report" → sections, executive summary, appendix
- "Document the API" → auth, endpoints, examples

### 4. Iterate if Needed

If user requests changes:
1. Update the plan document
2. Re-present for approval
3. Repeat until approved

## Outputs

- `automations/prds/{id}-{name}-prd.md` (approved PRD)
- User approval to proceed

## Next Step

Once approved, run `directives/02-automation-prd-json.md` to convert the PRD to `task-spec.json`.
