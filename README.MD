# ai-dev-blueprint

A copy-paste workflow folder that keeps an AI agent and a solo developer aligned. Define the project once, then build it feature by feature: **discuss → spec → approve → build → validate**.

## Quickstart

1. Copy the `ai/` folder into the root of your project.
2. Say **"Set up the project."** — the agent asks questions, then fills the templates `ai/overview.md`, `ai/architecture.md`, and `ai/roadmap.md`.
3. Review and approve those three files.
4. Say **"Next feature."** — the agent runs the loop: discuss → write feature docs → wait for your approval → build one task at a time → update `ai/roadmap.md` → propose a commit.

That's the whole workflow. For the full process — phases, states, approval gates, rules, agent reading order — open **`ai/workflow.md`**. It is the only place the process is described.

## Repo layout

```
ai/
  workflow.md            # the process — start here
  feature-template.md    # skeleton for feature docs
  overview.md            # template: what the project is
  architecture.md        # template: how it is structured
  roadmap.md             # template: feature order + status
  features/              # created during builds (spec · tech · tasks)
  dependencies/          # created when libraries are added (official docs)
README.md                # this file
```

## Notes

- This repo is the blueprint. A project consumes the `ai/` folder — don't edit the `ai/` files here to change a project.
- To change the workflow, edit `ai/workflow.md` and `ai/feature-template.md`. Don't describe the process anywhere else.
- Works with any chat-capable coding agent. The agent should read `ai/workflow.md` first — if yours doesn't, tell it to.
