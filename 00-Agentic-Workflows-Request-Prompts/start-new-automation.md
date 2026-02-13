# Start New Automation — Prompt Template

Copy everything between the `---` lines, fill in the `[PLACEHOLDERS]`, delete optional sections that don't apply, and paste to your AI agent.

---

## Universal Template (All Domains)

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md` and follow the three-step automation workflow defined in `00-Directives/`.

## What I Need

[DESCRIBE YOUR TASK IN 2-5 SENTENCES. Be specific about what you want delivered, not how to do it.]

## Domain

[coding | research | writing | documentation | analysis]

## Delivery Channel

[Where should the final deliverable(s) land?]
- Local files in the project
- Cloud service (specify: Google Sheets, Notion, etc.)
- Repository (branch/PR)
- Communication (Slack, email draft, etc.)

## Scope & Boundaries

[DEFINE LIMITS — delete lines that don't apply:]
- Source/competitor count: [e.g., "5 competitors max"]
- Word count / length: [e.g., "2000-3000 words"]
- Time scope: [e.g., "data from last 12 months only"]
- Depth: [e.g., "overview only, no deep-dives"]
- Budget constraints: [e.g., "no paid API calls without asking first"]

## Key Constraints

[LIST ANY HARD REQUIREMENTS — delete if none:]
- [e.g., "Must use Python 3.11+"]
- [e.g., "Follow AP style guide"]
- [e.g., "All sources must be from peer-reviewed journals"]
- [e.g., "Must integrate with existing auth system in /src/auth"]

## What I Already Have

[LIST EXISTING ASSETS — delete if none:]
- [e.g., "Rough outline in /docs/draft.md"]
- [e.g., "Competitor list in /data/competitors.csv"]
- [e.g., "Existing API at /src/api/routes.ts"]
- [e.g., "Previous research in 00-KBs/market-research/"]

## Risk Level & Review Preferences

- Risk level: [low | medium | high]
- I want to review: [everything | high-stakes deliverables only | final output only]

## Start

Begin with Step 1: `00-Directives/01-create-automation-prd.md`. Ask me clarifying questions, then create the PRD for my approval before proceeding.
```

---

## Domain Quick-Starts

Pre-filled variants with domain-specific defaults. Replace `[PLACEHOLDERS]` only.

### Research & Analysis

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md` and follow the three-step automation workflow defined in `00-Directives/`.

## What I Need

Research and analyze [TOPIC]. Produce a [FORMAT: report / analysis / comparison / brief] that covers [SPECIFIC ASPECTS TO COVER].

The deliverable should help me [DECISION OR ACTION THIS ENABLES].

## Domain

research

## Delivery Channel

[Local files in the project | Google Docs | other]

## Scope & Boundaries

- Cover [NUMBER] [sources / competitors / topics / options] maximum
- Focus on data from the last [TIME PERIOD]
- Final report should be [WORD COUNT RANGE] words
- Depth: [overview / detailed analysis / deep-dive with recommendations]

## Key Constraints

- [e.g., "Only use publicly available data"]
- [e.g., "Cite all statistics with primary sources"]
- [e.g., "Include a decision matrix with weighted scoring"]

## What I Already Have

- [e.g., "Initial list of competitors in /data/competitors.csv"]
- [e.g., "Previous market research in 00-KBs/"]
- [e.g., "Nothing — start from scratch"]

## Risk Level & Review Preferences

- Risk level: medium
- I want to review: data/findings before the final report is written

## Start

Begin with Step 1: `00-Directives/01-create-automation-prd.md`. Ask me clarifying questions, then create the PRD for my approval before proceeding.
```

### Writing & Content Creation

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md` and follow the three-step automation workflow defined in `00-Directives/`.

## What I Need

Write [CONTENT TYPE: blog post / report / white paper / email sequence / case study / copy] about [TOPIC].

Target audience: [WHO WILL READ THIS].
Purpose: [WHAT THE READER SHOULD THINK/DO/FEEL AFTER READING].

## Domain

writing

## Delivery Channel

[Local files in the project | Google Docs | CMS draft | other]

## Scope & Boundaries

- Length: [WORD COUNT RANGE] words
- Tone: [formal / conversational / technical / persuasive]
- Style guide: [AP / Chicago / brand guide at PATH / none]
- Sections: [NUMBER] sections approximately

## Key Constraints

- [e.g., "Follow the brand voice guide at /docs/brand-voice.md"]
- [e.g., "Include 3 real-world examples with data"]
- [e.g., "SEO-optimized for keywords: X, Y, Z"]
- [e.g., "No jargon — 8th-grade reading level"]

## What I Already Have

- [e.g., "Rough outline at /docs/outline.md"]
- [e.g., "Research notes at /docs/research-notes.md"]
- [e.g., "Nothing — start from scratch"]

## Risk Level & Review Preferences

- Risk level: medium
- I want to review: outline before writing begins, then final draft

## Start

Begin with Step 1: `00-Directives/01-create-automation-prd.md`. Ask me clarifying questions, then create the PRD for my approval before proceeding.
```

### Coding & Software Development

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md` and follow the three-step automation workflow defined in `00-Directives/`.

## What I Need

[DESCRIBE THE FEATURE / BUG FIX / REFACTOR IN 2-5 SENTENCES. Include what it should do, not how.]

## Domain

coding

## Delivery Channel

repository (branch/PR)

## Scope & Boundaries

- Scope: [frontend only / backend only / full-stack / infrastructure]
- Testing: [unit tests required / integration tests required / existing tests must pass]
- Browser support: [if applicable]

## Key Constraints

- Stack: [e.g., "Next.js 14, TypeScript, Prisma, PostgreSQL"]
- Patterns: [e.g., "Follow existing patterns in /src/components"]
- Quality: [e.g., "Must pass tsc --noEmit, eslint, and existing test suite"]
- [e.g., "No new dependencies without asking first"]

## What I Already Have

- [e.g., "Existing auth system at /src/auth/"]
- [e.g., "Database schema at /prisma/schema.prisma"]
- [e.g., "Design mockup at /docs/mockup.png"]
- [e.g., "Related issue: #123"]

## Risk Level & Review Preferences

- Risk level: [low | medium | high]
- I want to review: [schema changes before implementation / PR before merge / nothing — ship it]

## Start

Begin with Step 1: `00-Directives/01-create-automation-prd.md`. Ask me clarifying questions, then create the PRD for my approval before proceeding.
```

### Documentation

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md` and follow the three-step automation workflow defined in `00-Directives/`.

## What I Need

Create [DOC TYPE: API reference / user guide / tutorial / onboarding guide / architecture docs] for [WHAT IS BEING DOCUMENTED].

Target audience: [developers / end-users / internal team / new hires].

## Domain

documentation

## Delivery Channel

[Local files in the project | Notion / Confluence | repository wiki | other]

## Scope & Boundaries

- Cover: [LIST SPECIFIC MODULES / ENDPOINTS / FEATURES TO DOCUMENT]
- Depth: [reference only / reference + examples / full tutorial with walkthroughs]
- Code examples: [required for every endpoint / key endpoints only / not needed]

## Key Constraints

- [e.g., "Must match existing doc style in /docs/"]
- [e.g., "All code examples must be tested and runnable"]
- [e.g., "Include request/response examples for every API endpoint"]
- [e.g., "Use JSDoc format for inline documentation"]

## What I Already Have

- [e.g., "Existing partial docs at /docs/api/"]
- [e.g., "OpenAPI spec at /api/openapi.yaml"]
- [e.g., "README with basic setup instructions"]
- [e.g., "Nothing — document from source code"]

## Risk Level & Review Preferences

- Risk level: low
- I want to review: final output before publishing

## Start

Begin with Step 1: `00-Directives/01-create-automation-prd.md`. Ask me clarifying questions, then create the PRD for my approval before proceeding.
```

### Data Analysis & Strategy

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md` and follow the three-step automation workflow defined in `00-Directives/`.

## What I Need

Analyze [DATA / SITUATION / PROBLEM] and produce [DELIVERABLE: strategic recommendation / financial model / data report / decision framework].

This will inform [WHAT DECISION OR ACTION].

## Domain

analysis

## Delivery Channel

[Local files / Google Sheets / presentation / other]

## Scope & Boundaries

- Data sources: [LIST SPECIFIC DATA SOURCES TO USE]
- Time range: [e.g., "last 12 months" / "Q1-Q3 2025" / "all available"]
- Granularity: [e.g., "monthly" / "by region" / "by product line"]
- Output format: [spreadsheet with formulas / narrative report / both]

## Key Constraints

- [e.g., "All assumptions must be stated explicitly"]
- [e.g., "Include sensitivity analysis for key variables"]
- [e.g., "Present 3 options with pros/cons and risk assessment"]
- [e.g., "Data transformations must be documented step-by-step"]

## What I Already Have

- [e.g., "Raw data at /data/sales-2025.csv"]
- [e.g., "Previous analysis at /reports/q2-review.md"]
- [e.g., "KPIs defined in /docs/kpis.md"]
- [e.g., "Nothing — need to gather data first"]

## Risk Level & Review Preferences

- Risk level: medium
- I want to review: methodology before analysis begins, then final recommendations

## Start

Begin with Step 1: `00-Directives/01-create-automation-prd.md`. Ask me clarifying questions, then create the PRD for my approval before proceeding.
```
