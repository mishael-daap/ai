# ai-dev-blueprint

An agent skill that keeps an AI agent and a solo developer aligned. It bootstraps a small `ai/` workflow folder into a project, then runs the loop: **discuss → spec → approve → build → validate**.

## Install

Install it as a skill (any Agent Skills–capable harness, e.g. pi, Claude Code, Codex), or drop the folder into your skills directory. The skill is defined by `SKILL.md`.

## Use

In a project root:

```bash
# from the skill directory (the one containing SKILL.md):
bash scripts/bootstrap.sh /path/to/project     # creates /path/to/project/ai/
```

Then talk to your agent:

1. **"Set up the project."** — the agent asks questions, then fills `ai/overview.md`, `ai/architecture.md`, `ai/roadmap.md`. Approve them (**G1**).
2. **"Next feature."** — the agent discusses, writes `ai/features/<name>/{spec,tech,tasks}.md`, waits for approval (**G2**), then executes tasks one at a time. When done you validate it, then the agent proposes a commit (**G3**).

Scaffold a feature's docs directly with:

```bash
bash scripts/new-feature.sh "user login" /path/to/project
# → /path/to/project/ai/features/user-login/{spec,tech,tasks}.md
```

The full process — phases, states, gates, rules, reading order — is in **`assets/workflow.md`**, which is copied into each project as `ai/workflow.md` and is the authoritative spec.

## Layout

```
SKILL.md                 # skill entry point: when to use, the loop, gates, rules
assets/                  # templates copied into a project's ai/
  workflow.md            #   the process (authoritative spec)
  overview.md            #   what the project is
  architecture.md        #   how it is structured
  roadmap.md             #   feature order + status
  feature-template.md    #   skeleton for a feature's three docs
scripts/
  bootstrap.sh           # create ai/ in a project (idempotent)
  new-feature.sh         # scaffold ai/features/<name>/{spec,tech,tasks}.md
```

A consuming project ends up with:

```
ai/
  workflow.md  overview.md  architecture.md  roadmap.md  feature-template.md
  features/<name>/spec.md  tech.md  tasks.md
  dependencies/<name>/docs.md
```

## Notes

- This repo is the blueprint. A project consumes `ai/` — don't edit the skill's `assets/` to change a project; edit the project's `ai/` files.
- To change the workflow, edit `SKILL.md` and `assets/workflow.md`. Don't describe the process anywhere else.
- Works with any chat-capable coding agent. Tell it to read `SKILL.md` (or `ai/workflow.md` in a project) if it doesn't pick it up on its own.
