# Quick Interactive Task — Prompt Template

Use this for single-shot tasks that do NOT need the full Ralphed-DOE automation (fewer than 3 steps, no dependencies, completable in one session). For anything larger, use `start-new-automation.md` instead.

---

## Quick Task Template

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md` for context (Operating Principles and Quality Checks sections). This is a quick interactive task — no need for the full 3-step automation workflow.

## Task

[DESCRIBE WHAT YOU NEED IN 1-3 SENTENCES.]

## Domain

[coding | research | writing | documentation | analysis]

## Constraints

- [e.g., "Use Python 3.11+"]
- [e.g., "Under 500 words"]
- [e.g., "Cite all sources"]
- [DELETE IF NONE]

## Delivery

[Where should the output go?]
- [e.g., "Save to /docs/summary.md"]
- [e.g., "Print the result here in chat"]
- [e.g., "Commit to current branch"]

## Quality

Apply the framework's universal quality checks (hallucination prevention, consistency, traceability, completeness) and [DOMAIN] domain checks. Flag anything uncertain as [NEEDS VERIFICATION].
```

---

## Quick Task Examples

### Quick Research

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md` for quality standards. Quick interactive task.

## Task

Find the current pricing tiers for [PRODUCT/SERVICE] and summarize them in a comparison table. Include the source URL for each price point.

## Domain

research

## Constraints

- Only use official website pricing pages
- Include at least the 3 most common tiers

## Delivery

Print the comparison table here in chat.

## Quality

Cite all prices with URLs. Flag anything not from an official source as [NEEDS VERIFICATION].
```

### Quick Writing

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md` for quality standards. Quick interactive task.

## Task

Write a [TYPE: executive summary / email draft / LinkedIn post / meeting agenda] about [TOPIC].

## Domain

writing

## Constraints

- [LENGTH: e.g., "Under 300 words"]
- [TONE: e.g., "Professional but approachable"]
- [AUDIENCE: e.g., "C-suite executives"]

## Delivery

Save to [PATH] / Print here in chat.

## Quality

Spell-check, grammar-check, appropriate reading level for audience.
```

### Quick Coding

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md` for quality standards. Quick interactive task.

## Task

[DESCRIBE THE CHANGE: e.g., "Add a /health endpoint that returns { status: 'ok', timestamp: Date.now() }"]

## Domain

coding

## Constraints

- [e.g., "Follow existing patterns in /src/api/"]
- [e.g., "Must pass typecheck and existing tests"]

## Delivery

Commit to current branch with message: "feat: [BRIEF DESCRIPTION]"

## Quality

Typecheck passes, lint passes, existing tests pass. No hardcoded credentials.
```

### Quick Analysis

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md` for quality standards. Quick interactive task.

## Task

[DESCRIBE: e.g., "Calculate month-over-month growth rates from the sales data in /data/sales.csv and identify the top 3 performing products."]

## Domain

analysis

## Constraints

- [e.g., "Use the data as-is, no external sources needed"]
- [e.g., "Show your calculations"]

## Delivery

Save to [PATH] / Print results here in chat.

## Quality

Document data transformations. Verify calculations. State any assumptions.
```
