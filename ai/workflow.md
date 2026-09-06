# Workflow

This folder keeps you and the AI agent aligned. It is the single source of truth for how this project is defined, planned, and built — everything below is written for both the human and the agent.

> **Agent:** read this file first at the start of every session, then follow the reading order in §5.

## 1. File map

| File | What it's for |
|---|---|
| `ai/workflow.md` | This file — how the project is run. Read first. |
| `ai/overview.md` | What the project is and why. Written once in Phase 1. |
| `ai/architecture.md` | How the system is structured, and which decisions are settled. Written once in Phase 1. |
| `ai/roadmap.md` | The features, in order, with status. Updated throughout. |
| `ai/feature-template.md` | The skeleton used each time a feature's docs are created. |
| `ai/features/<name>/spec.md` | What one feature does (behavior, rules, acceptance criteria). |
| `ai/features/<name>/tech.md` | How it will be built (components, endpoints, data, flow). |
| `ai/features/<name>/tasks.md` | The ordered task list that drives execution. |
| `ai/dependencies/<name>/docs.md` | Official docs snapshot for each library in use. |

All paths are relative to the **project root** — the folder that contains `ai/`.

## 2. The two phases

### Phase 1 — Define the project (once)

Trigger: the user says **"set up the project"**.

1. Ask questions until the picture is stable: purpose, users, problem, features, constraints. Chat only — no files.
2. When the user says the picture is ready, fill `ai/overview.md`, `ai/architecture.md`, and `ai/roadmap.md` using their built-in templates.
3. The user reviews; iterate until approved (**Gate G1**).
4. On approval: remove the `<!-- -->` guidance comments from the three files, then stop. Do not start Phase 2 until asked.

### Phase 2 — Build features (repeatable)

Trigger: the user says **"next feature"** (or approves starting one). One feature at a time — never two in flight.

1. Read `ai/roadmap.md` and take the first feature whose status is not `completed`. If none: say so and stop.
2. **Discuss** (chat only): purpose, user flow, edge cases, implementation approach. No files. The user may skip this step for speed — docs and gates still apply.
3. Write `ai/features/<name>/spec.md`, `tech.md`, and `tasks.md` from `ai/feature-template.md`. Mark the roadmap item `spec ready`.
4. Present a short summary and wait for approval to start coding (**Gate G2**). Review and iterate if needed.
5. Mark the roadmap item `in development`. Execute `tasks.md` from the top, **one task at a time**: implement it, verify it works, tick it off. Never skip, combine, or jump ahead.
6. When all tasks are done and tests pass, ask the user to validate. Once validated, mark the roadmap item `completed`.
7. Propose a commit (**Gate G3**), then return to step 1.

## 3. States

A roadmap item's status is exactly one of:

- `pending` — not started.
- `spec ready` — feature docs written; awaiting approval to code.
- `in development` — approved; tasks being executed.
- `completed` — built, tested, validated by the user.

Where the project stands at any moment = the roadmap statuses plus the unchecked tasks in the current feature's `tasks.md`.

## 4. Approval gates — the only ones

- **G1** — Phase 1: no Phase 2 until the user approves the filled core docs.
- **G2** — Feature: after writing a feature's three docs, no code until the user approves.
- **G3** — Git: propose the commit message; commit only after approval.

Nothing outside these gates needs approval. User instructions always win.

## 5. Reading order (agents)

At the start of a session, or whenever unsure:

1. `ai/workflow.md` (this file).
2. `ai/roadmap.md`.
3. If a feature is `in development`: its `ai/features/<name>/tasks.md` — resume from the first unchecked task. Otherwise propose the first `pending` feature and start its discussion.
4. Consult `ai/architecture.md` and `ai/overview.md` for design and scope decisions; the current feature's docs when working inside it.

## 6. Rules

- **One thing at a time.** One feature, one task. Finish before starting the next.
- **New dependencies.** Before using a library, save its official docs to `ai/dependencies/<name>/docs.md` — fetch them yourself, or ask the user to paste them. Skip only if 100% certain how it behaves.
- **Git.** Propose one concise commit message per logical change; wait for approval; commit.
- **Doc hygiene.** Each fact lives in one place. When code or plans change, update the owning file. Don't copy rules or structure into other files.
- **Conflicts.** User instructions > approved feature docs > existing code patterns > this file. Ask if still unclear.
