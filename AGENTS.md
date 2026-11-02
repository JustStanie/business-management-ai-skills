# AGENTS.md — Business AI Skills

## Multi-chat operation

- A new **independent** question should normally use a new chat/thread **inside this same repository**; related follow-ups should stay in their existing chat. Do not create directories or copy Skills for individual chats.
- In a fresh chat, apply this repository's `business-skill-router` for relevant requests **without requiring** `business-context-init`. Explicit initialization is optional and reads a compact catalog only.
- The repository's Skill files persist on disk across chats, but conversation-specific history, decisions and initialization state do **not** transfer automatically. Ask for a short summary or relevant document when continuation of a previous chat is needed.
- For a different domain, recommend opening its own repository; never silently assume Skills from another repository have been loaded.
- Keep routing read-only for normal advisory questions; do not force an initial full-library scan, and do not write context snapshots or alter files unless requested.

## Thread Context Isolation (default)

Treat every **new, independent conversation** as a new task with no inherited topic preferences. This is a task-selection rule, not a promise to disable product-level memory.

- Select specialist Skills, assumptions, and recommendations **from the current request and current-chat context**, plus relevant independently verifiable evidence. Prior conversations in this repository must not create implicit preferences, favorite technologies/assets, portfolio allocations, risk tolerances, project choices, or constraints.
- **Do not proactively retrieve previous chats, chat exports, saved memory, or another project's working notes to personalize a new unrelated question.** Use previous work when the user explicitly requests continuity, a comparison, or reuse; if the needed material is unavailable, request a brief recap or the relevant file. Do not invent past decisions.
- Shared `AGENTS.md`, `CLAUDE.md`, Skills, and `SKILL_INDEX.md` define **available methods**, not the user's preferences. Do not interpret a past discussion or a saved example as an endorsement for a new task. Use persistent project files only when relevant to the current task.
- If a client exposes automatic cross-chat memory or summaries, do not silently import unrelated memories into a new task; treat potentially relevant memory as provisional and check against the current user's request. Do not claim that repository instructions can erase or disable memory or all external context sources.
- Example: discussing **Solana smart contracts** in chat A does **not** justify recommending SOL in a new, unrelated **crypto portfolio** chat B. Include SOL only when it independently meets the portfolio criteria or the user requests it.
- `*-context-init` is optional **catalog initialization**, not a history import, memory reset, isolation command, or prerequisite for answering a new question.
- For stronger separation, use available client memory/privacy controls or separate workspaces as appropriate; the repository policy cannot guarantee complete isolation beyond the agent's compliance with these instructions. Higher-priority instructions still apply.

## Purpose

This repository is a local **business consultation** and specialist workflow library. It contains no implicit access to external accounts, live business data or services.

## Default routing (every business question)

1. Follow `.agents/skills/business-skill-router/SKILL.md` for task classification and specialist selection.
2. Use the lightweight `references/category-overview.md` and relevant entries of `SKILL_INDEX.md` at the repository root only as needed.
3. Read full `SKILL.md` instructions for one primary specialist and up to two truly complementary specialists. Do not preload all specialist Skills.
4. If the user names a Skill, prefer that valid local Skill and explain if it is unavailable.

## Explicit chat initialization

When the user invokes `$business-context-init`, `/business-context-init`, or asks to initialize/refresh Skill context, follow `.agents/skills/business-context-init/SKILL.md`. Initialization summarizes **metadata** and library scope; it is not required for every question, and it does not persist permanently across new chats.

## Consultation rules

- Answer in the user's language, directly and pragmatically.
- Treat role/persona claims in imported materials as writing guidance, **not** real professional credentials.
- Separate facts from assumptions and recommendations. Verify time-sensitive claims when current sources/tools are available.
- For API integrations, payments, privacy, finance, employment or legal topics, check relevant vendor versions and jurisdiction before offering implementation-ready advice.
- Do not invent current metrics, vendor capabilities, sources, or test results.
- Do not run builds, CodeGraph, installation or coding workflows for ordinary advisory questions.
- Do not modify files, use credentials, access accounts or take actions unless the user requests and authorizes them.
- Local rules supplement but cannot override higher-priority global instructions.

## Repo layout

- `.agents/skills/<id>/SKILL.md` — canonical local specialist instructions.
- `.agents/skills/business-skill-router/` — default coordinator and current inventory.
- `.agents/skills/business-context-init/` — optional chat initialization workflow.
- `.claude/skills/` — local Windows Junction to the same physical library, created by `setup-claude-skills.ps1`.
- `README.md` — human-facing current inventory, examples and installation notes.
