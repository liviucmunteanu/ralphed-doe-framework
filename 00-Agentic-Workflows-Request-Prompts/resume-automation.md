# Resume Existing Automation — Prompt Template

Use this when an automation is already in progress and you need to continue it in a new context window (new chat session, fresh agent instance, etc.).

---

## Resume Template

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md`, then resume the in-progress automation.

## Automation to Resume

Path: `00-Automations/[ID]-[NAME]/`

## What to Do

Follow `00-Directives/03-run-ralphed-doe-automation.md`:

1. Read `AGENTS.md` in the automation folder
2. Read `[NAME]-progress.txt` — **start with the Codebase Patterns section at the top**
3. Read `[NAME]-spec.json` — identify which tasks remain (`passes: false`)
4. Run pre-flight validation
5. Pick the next highest-priority task and execute it
6. Continue until all tasks pass or you need my input

## Additional Context

[OPTIONAL — add any context the previous session didn't capture:]
- [e.g., "The last session got stuck on T-003 because the API was rate-limited. Try using the batch endpoint instead."]
- [e.g., "I resolved the blocker on T-002 manually — the data is now in /data/cleaned.csv. Mark T-002 as passed and move on."]
- [e.g., "Skip T-004 — we decided it's out of scope. Mark it as passed with a note."]
- [e.g., "No additional context — just pick up where progress.txt left off."]
```

---

## Resume After Blocker Resolution

Use this when you've manually resolved a blocker and want the agent to continue.

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md`, then resume the automation at `00-Automations/[ID]-[NAME]/`.

## Blocker Resolution

Task [TASK-ID] was blocked because: [ORIGINAL BLOCKER REASON].

I've resolved it by: [WHAT YOU DID TO FIX IT].

## What to Do

1. Read the automation's `AGENTS.md` and `[NAME]-progress.txt` (Codebase Patterns first)
2. Update [TASK-ID] in `[NAME]-spec.json`: set `blocked: false`, clear `blockerReason`, add a note about the resolution
3. [Re-attempt TASK-ID / Mark TASK-ID as passed and move to the next task]
4. Continue execution per `00-Directives/03-run-ralphed-doe-automation.md`
```

---

## Resume for Final Review & Archiving

Use this when all tasks are done and you want the agent to run final checks and archive.

```
Read the framework at `AGENTS-Instructions-AgenticWorkflows.md`, then finalize the completed automation at `00-Automations/[ID]-[NAME]/`.

## What to Do

1. Read `[NAME]-spec.json` and verify ALL tasks have `passes: true`
2. Check for any unresolved `[NEEDS VERIFICATION]` flags in deliverables
3. Generate a post-mortem (see framework Post-Mortem Process section)
4. Provide me a final status summary
5. Archive the automation per `00-Directives/03-run-ralphed-doe-automation.md` (Archiving section)
```
