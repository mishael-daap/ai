# Feature Template

Used each time a feature's docs are created (workflow §2, Phase 2, step 3). Create one folder per feature:

```
ai/features/<feature-name>/
  spec.md     # what the feature does
  tech.md     # how it will be built
  tasks.md    # ordered task list
```

Keep every file terse and concrete. No extra files. Match the formatting of earlier features if any exist.

---

## spec.md — what the feature does

Done well when: clear user flows, edge cases covered, every acceptance criterion testable.

```md
# Feature: <Name>

## Purpose
One or two lines: what this achieves for the user.

## User Flow
1. <step from the user's perspective>
2. <step>

## Rules
- <validation rule>
- <constraint or edge case>

## Acceptance Criteria
- [ ] <testable condition>
- [ ] <testable condition>
```

---

## tech.md — how it will be built

Done well when: concrete (endpoints, models, names), consistent with `ai/architecture.md`, no fluff.

```md
# Technical Plan: <Name>

## Components
- <service / module / area, and its job>

## API
- <METHOD /path — what it does>   <!-- only if this feature has an API -->

## Data Model
<Entity> {
  <field>: <type>
}

## Flow
<request → validation → service → db → response, one line>

## Notes
- <decision worth recording>
```

---

## tasks.md — drives execution

Done well when: tasks are small, ordered, and each one is testable on its own.

```md
# Tasks: <Name>

- [ ] <one small unit of work>
- [ ] <next unit, in dependency order>
```

While tasks run, the roadmap item stays `in development`. Execute from the top, one at a time: implement → verify it works → tick it off.
