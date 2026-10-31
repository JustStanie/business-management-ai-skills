# AGENTS.md — Business AI Skills

## Purpose

This repository is a local **business consultation** and specialist workflow library. It contains no implicit access to external accounts, live business data or services.

## Default routing (every business question)

1. Follow `.agents/skills/business-skill-router/SKILL.md` for task classification and specialist selection.
2. Use the lightweight `references/category-overview.md` and relevant entries of `references/skill-index.md` only as needed.
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
