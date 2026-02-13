# Create PRD for Automation Directive

Clarify requirements and create a human-readable automation plan before converting to {name}-spec.json.

## Purpose

This is **Step 1** of the three-step automation workflow:
1. **Create PRD for the Automation** (this directive) → Creates readable plan, gets approval
2. **Create Automation PRD JSON File** (`02-automation-prd-json.md`) → Converts approved plan to {name}-spec.json
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

**Analysis:**
- What is the decision or question to be answered?
- What data sources are available?
- What methodology (quantitative, qualitative, mixed)?
- What format (spreadsheet, report, presentation)?
- Who will act on the findings?

**Cross-Domain (always ask):**
- **Delivery channel**: Where should the final deliverable land? (local files, cloud service, repository, communication channel)
- **Boundaries** (for research/analysis/writing): What limits should be placed on scope? (source count, word count, time period, depth level)

### 2. Generate Automation Plan

After getting answers, create a markdown plan document.

**Save to:** `00-PRDs/{next-id}-{name}/{name}-prd.md`

**Template:**

```markdown
# Automation Plan: {Name}

## Overview
Brief description of what this automation accomplishes.

## Goals
- Specific goal 1
- Specific goal 2
- Specific goal 3

## Risk Assessment
- **Complexity**: Low / Medium / High
- **Key Assumptions**: List assumptions that if wrong, invalidate the plan
- **External Dependencies**: APIs, tools, data sources, or human inputs needed
- **Rollback Strategy**: How to undo if things go wrong

## Tasks
Break down into small, independently completable tasks.

### T-001: {Task Title}
**Description:** What to accomplish
**Complexity:** Low / Medium / High
**Review Required:** Yes (approval) / Yes (spot-check) / No
**Acceptance Criteria:**
- [ ] Criterion 1 (verifiable)
- [ ] Criterion 2 (verifiable)
- [ ] Domain quality check passes
- [ ] Universal quality checks pass (hallucination, consistency, traceability, completeness)

### T-002: {Task Title}
...

## Functional Requirements (Optional — use for complex automations)
Numbered list of specific functionalities or behaviors, separate from tasks:
- FR-1: "The system must allow users to..."
- FR-2: "When X happens, the output must include Y"
- FR-3: "All data must be sourced from Z"

Be explicit and unambiguous. These are referenced by tasks and provide traceability.

## Non-Goals (Out of Scope)
What this automation will NOT include. Critical for managing scope creep.

## Design Considerations (Optional)
- UI/UX requirements (if applicable)
- Link to mockups, wireframes, or examples to follow
- Relevant existing components, templates, or style guides to reuse

## Technical Considerations (Optional)
- Known constraints or dependencies (APIs, rate limits, data formats)
- Integration points with existing systems
- Performance requirements
- Tool/platform prerequisites

## Definition of Done
Specific, measurable criteria for the ENTIRE automation (not per-task):
- [ ] All deliverables produced and quality-verified
- [ ] Quality evidence logged for every task
- [ ] No `[NEEDS VERIFICATION]` flags remaining unresolved
- [ ] AGENTS.md updated with learnings
- [ ] Post-mortem generated

## Human Checkpoints
Identify tasks that need human review before proceeding:
- After T-XXX: "Review [what] before [next phase] begins"
- Before delivery: "Final review of all deliverables"

## Quality Requirements
- Domain-specific checks to run
- Universal checks always apply
- Success criteria

## Deliverables
- List of expected outputs
- **Delivery channel**: Where each deliverable lands (local file, cloud service, repository, communication)

## Success Metrics
How will success be measured? Concrete, measurable outcomes:
- "Report covers all 5 requested competitors with pricing data"
- "Reduce time to complete X by 50%"
- "All code changes pass typecheck and existing test suite"
- "Document covers all API endpoints with working examples"

## Open Questions
Any unresolved issues that need clarification before execution begins.
```

### 3. Verify Acceptance Criteria Quality

Before presenting to the user, verify every acceptance criterion is **objectively verifiable**, not vague. Refer to the "Writing Verifiable Acceptance Criteria" section in `AGENTS-Instructions-AgenticWorkflows.md` for good vs bad examples by domain.

Quick self-check:
- Could another agent determine pass/fail on this criterion without subjective judgment? If no, rewrite it.
- Does every task include a domain-appropriate quality gate as its final criterion? (e.g., "Typecheck passes", "All claims cite verifiable sources", "Spell-check passes")
- For open-ended tasks (research, analysis, writing): are there explicit boundaries (source count, word count, time scope)?

### 4. Review with User

Present the plan and ask for approval:
- Are tasks sized correctly?
- Is the ordering right?
- Anything missing?
- Anything to remove?
- Are the delivery channels correct?
- Are the success metrics measurable?

**Do NOT proceed to `02-automation-prd-json.md` until user approves.**

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

### Example PRD (Research Domain)

This shows a complete, correctly structured PRD for a non-coding domain:

```markdown
# Automation Plan: Competitive Analysis — CRM Market

## Overview
Research and analyze the top CRM platforms to inform a build-vs-buy decision for the sales team.

## Goals
- Identify the top 5 CRM platforms by market share
- Compare pricing, features, and integration capabilities
- Produce a recommendation report with a clear decision matrix

## Risk Assessment
- **Complexity**: Medium
- **Key Assumptions**: Public pricing data is available for all 5 platforms
- **External Dependencies**: Web access for research, company financial reports
- **Rollback Strategy**: N/A (research deliverable, no system changes)

## Tasks

### T-001: Identify Top 5 CRM Platforms by Market Share
**Description:** Research current CRM market landscape and identify the top 5 by market share.
**Complexity:** Low
**Review Required:** No
**Acceptance Criteria:**
- [ ] List of top 5 CRM platforms with market share percentages
- [ ] Each market share figure cites a source published within the last 2 years
- [ ] Saved as structured data (not just prose)
- [ ] All claims cite verifiable sources

### T-002: Gather Pricing and Feature Data for Each Platform
**Description:** For each of the 5 platforms, collect pricing tiers and key feature sets.
**Complexity:** Medium
**Review Required:** Yes (spot-check)
**Acceptance Criteria:**
- [ ] Pricing table with at least 3 tiers per platform (or "contact sales" noted)
- [ ] Feature comparison covering: contacts, pipeline, automation, integrations, reporting
- [ ] All pricing data sourced from official websites (URLs cited)
- [ ] All claims cite verifiable sources

### T-003: Write Recommendation Report with Decision Matrix
**Description:** Synthesize research into a recommendation report with a scoring matrix.
**Complexity:** Medium
**Review Required:** Yes (approval)
**Acceptance Criteria:**
- [ ] Executive summary under 500 words covering all key findings
- [ ] Decision matrix scoring each platform on 5 criteria (1-5 scale) with stated weighting
- [ ] Clear recommendation with justification
- [ ] Report is 2000-3000 words total
- [ ] Spell-check and grammar-check pass
- [ ] All claims cite verifiable sources

## Functional Requirements
- FR-1: All statistics must cite primary sources (not secondary aggregators)
- FR-2: Pricing must reflect current published rates, not historical
- FR-3: Decision matrix must use weighted scoring with weights stated upfront

## Non-Goals (Out of Scope)
- No vendor contact or demo scheduling
- No analysis of CRMs outside the top 5
- No implementation plan (that would be a separate automation)

## Design Considerations
- Report format: Markdown with tables
- Decision matrix: Table format, sortable by total score

## Definition of Done
- [ ] All deliverables produced and quality-verified
- [ ] Quality evidence logged for every task
- [ ] No [NEEDS VERIFICATION] flags remaining unresolved
- [ ] AGENTS.md updated with learnings
- [ ] Post-mortem generated

## Human Checkpoints
- After T-002: "Review pricing/feature data before writing recommendation"
- Before delivery: "Final review of recommendation report"

## Quality Requirements
- Research domain checks: citations, coverage, source quality, accuracy
- Universal checks always apply

## Deliverables
- Competitive analysis report (Markdown)
- Decision matrix (table in report)
- **Delivery channel**: Local file in automation workspace

## Success Metrics
- Report covers all 5 platforms with pricing and features
- All statistics cite sources published within last 2 years
- Decision matrix produces a clear ranking

## Open Questions
- Should we include open-source CRMs or only commercial?
- What is the budget range for the buy decision?
```

### 5. Iterate if Needed

If user requests changes:
1. Save current version as `{name}-prd-v{N}.md` (preserve history)
2. Create updated version incorporating feedback
3. Re-present for approval
4. Repeat until approved

> **PRD Versioning**: Never overwrite an approved PRD. Create a new version (v2, v3, etc.) so the evolution of requirements is traceable.

## Outputs

- `00-PRDs/{id}-{name}/{name}-prd.md` (approved PRD)
- User approval to proceed

## Next Step

Once approved, run `00-Directives/02-automation-prd-json.md` to convert the PRD to `{name}-spec.json`.
