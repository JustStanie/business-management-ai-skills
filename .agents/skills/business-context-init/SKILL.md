---
name: business-context-init
description: >-
  Initialize or refresh a chat's understanding of the local Business AI Skills library.
  Use when the user requests initialization, a capability overview, skill discovery,
  or a refresh after adding or removing Skills. Read a compact catalogue, not all Skill bodies.
---

# Business Context Initialization

This is a **read-only, on-demand chat initialization workflow**, not an install command, an independent agent, or persistent model training.

## Workflow

1. Confirm the current working repository root contains `AGENTS.md` and `.agents/skills/`.
2. Read `AGENTS.md`, then `.agents/skills/business-skill-router/references/category-overview.md`.
3. Read `SKILL_INDEX.md` to learn which specialist Skill names and descriptions are available. Check actual `.agents/skills/*/SKILL.md` paths if tools permit, especially if the user says the library changed.
4. Do **not** read all complete specialist `SKILL.md` bodies, launch scripts, access services or modify files. Those are loaded only after a specific question identifies the needed specialists.
5. Briefly report the actual number of Skills, major categories, consultation scope, and how to call the router and individual Skills.
6. If the index conflicts with on-disk files, report the mismatch and use verified local files; do not pretend the catalog is current.
7. For the remainder of this chat, select relevant Skills using the router. This state is conversational context only and is not guaranteed to survive a fresh chat or compaction.

## Example user invocations

Codex: `$business-context-init Initialize this repository's Skill catalogue for our chat.`

Claude Code: `/business-context-init Initialize this repository's Skill catalogue for our chat.`

Fallback text for either client: `Read .agents/skills/business-context-init/SKILL.md and initialize this chat's business skill catalogue without loading all specialist Skills.`

## When to run this initializer

Run **only on explicit user request**, such as a request to initialize, refresh, or display available Skills. Do **not** make this a mandatory first step for every new chat: repository instructions already provide default Skill routing. Initialization reads a brief catalog for the **current** chat, never all specialist bodies, and does not transfer previous chat decisions or create long-term model memory.

## Isolation of new conversations

- This command **only** reads the local repository's Skill catalog and routing instructions. Never treat it as restoring previous sessions, carrying over a user's earlier preferences or decisions, or clearing client-level memory.
- During initialization, do not fetch prior chat transcripts, memory summaries, previous task notes or other repositories' histories, unless the user explicitly requests continuation of that prior work.
- Once initialized, route each question by **its own stated task**. A new portfolio question must not inherit an unrelated earlier blockchain-development preference; shared Skills are methodologies, not user positions.
- Product-specific memory or cross-session features may still exist. These repository instructions reduce inappropriate carry-over but cannot technically disable those features.

