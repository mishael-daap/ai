---
name: ai-dev-blueprint
description: Runs a gated define-then-build workflow with an AI agent (discuss → spec → approve → build → validate). Use when the user says "set up the project", "next feature", or asks to define a project's overview/architecture/roadmap, or wants feature-by-feature development with spec/tech/tasks docs and approval gates.
---

# AI Dev Blueprint

A project-scoped workflow folder (`ai/`) that keeps one agent and one developer aligned: define the project once, then build it feature by feature.

## When to use this skill

- The user says **"set up the project"** → run Phase 1 (define).
- The user says **"next feature"** → run Phase 2 (build).
- The user asks for a project overview, architecture, or roadmap, or wants to plan/build a feature with spec → tasks docs.

## Setup: bootstrap `ai/` into the project

The scripts live in **this skill's directory** (next to this SKILL.md). Use their absolute
path, and target the project root — the folder that will contain `ai/`:

```bash
SKILL_DIR="<directory containing this SKILL.md>"
bash "$SKILL_DIR/scripts/bootstrap.sh" "$PROJECT_ROOT"   # omit arg to use the cwd
```

Always pass the project root explicitly (or `cd` there first): the script copies into
`<target>/ai/`, not into the skill directory.

It creates `ai/features/` and `ai/dependencies/`, and copies `assets/*` into `ai/` **without overwriting existing files** (safe to re-run). Then the project owns those files — they are the source of truth for that project, versioned in its git repo.

## The loop

```
discuss → spec → approve → build → validate
```

**Phase 1 — Define (once).** Trigger: "set up the project".
1. Ask questions in chat only (purpose, users, problem, features, constraints). No files.
2. When the picture is stable, fill `ai/overview.md`, `ai/architecture.md`, `ai/roadmap.md` from their templates.
3. Iterate until the user approves (**Gate G1**).
4. On approval, strip the `<!-- -->` comments from the three files and stop.

**Phase 2 — Build (repeatable).** Trigger: "next feature". One feature at a time, never two in flight.
1. Read `ai/roadmap.md`; take the first item whose status is not `completed`. If none, say so and stop.
2. Discuss in chat (skippable — docs and gates still apply).
3. Create the feature docs, e.g. with `bash "$SKILL_DIR/scripts/new-feature.sh" "<name>" "$PROJECT_ROOT"`; mark the item `spec ready`.
4. Summarize; wait for approval before coding (**Gate G2**).
5. Mark `in development`; run `ai/features/<name>/tasks.md` top-down, **one task at a time**: implement, verify, tick off. Never skip, combine, or jump ahead.
6. When all tasks are done and tests pass, ask the user to validate; then mark `completed`.
7. Propose a commit (**Gate G3**); back to step 1.

`scripts/new-feature.sh <name> [project-root]` scaffolds `ai/features/<name>/{spec,tech,tasks}.md` from the template.

## States

`pending` → `spec ready` → `in development` → `completed`.
Project position = roadmap statuses + unchecked tasks in the current feature's `tasks.md`.

## Gates — the only ones

- **G1** — Phase 1 core docs before Phase 2.
- **G2** — feature docs before code.
- **G3** — before any git commit.

Nothing else needs approval. User instructions always win.

## Reading order

At the start of a session: `ai/workflow.md` → `ai/roadmap.md` → if a feature is `in development`, its `tasks.md` (resume the first unchecked task), else propose the first `pending` feature and discuss. Consult `ai/architecture.md`/`ai/overview.md` for design and scope.

## Rules

- **One thing at a time** — one feature, one task.
- **New dependencies** — save official docs to `ai/dependencies/<name>/docs.md` before using a library (fetch them, or ask the user to paste). Skip only if 100% certain.
- **Git** — propose one concise commit message per logical change; commit only after approval.
- **Doc hygiene** — each fact lives in one place; update the owning file.
- **Conflicts** — user instructions > approved feature docs > existing code patterns > `ai/workflow.md`. Ask if still unclear.

## Reference

- `assets/workflow.md` — the full process, copied into each project as `ai/workflow.md`. This SKILL.md is the agent-facing entry point; `workflow.md` is the project-resident spec. Read it for the authoritative detail.
- `assets/feature-template.md` — skeleton for a feature's three docs.
