# CLAUDE.md — Business AI Skills

@AGENTS.md

Follow the shared repository instructions in `AGENTS.md` (imported above). The canonical Skills are under `.agents/skills/`; `.claude/skills/` is a locally created Windows link for native discovery.

For normal business questions, consult `business-skill-router` and read only relevant specialist files. For explicit chat initialization or a catalogue refresh, use `business-context-init`.

Manual calls (when registered by this Claude Code installation): `/business-skill-router` or `/business-context-init`. If native slash discovery fails, read `.agents/skills/<name>/SKILL.md` directly.

Do not confuse business-context initialization with `/init` used to generate or modify project instruction files. No file editing is authorized by the initializer.

## Conversations and initialization

When a user creates a new Claude Code conversation in `business-management-ai-skills`, apply the shared repository policy and `business-skill-router` without requiring `/business-context-init`. The initializer is an optional, explicit catalog overview, **not** an obligatory command before each question. Reuse a chat when its history matters; start a new chat for unrelated subjects. Skills remain local to this repository. Never claim that prior chat history, a previous initialization, or other repositories' Skills are automatically available.

## Thread Context Isolation

- Follow the **Thread Context Isolation** section of `AGENTS.md` for every new independent Claude Code conversation.
- Do not favor a chain, asset, product, tool, technique, or decision merely because it appeared in another chat in this repository. Pick specialists based on the **current** request and evidence.
- Do not import automatic memories, summaries, or prior-session notes as implicit requirements. Reuse earlier work **only on an explicit continuity request**; confirm unavailable assumptions instead of guessing.
- `/business-context-init` only reads the Skill catalog; it neither restores earlier chats nor disables client-level memory. Repository instructions are behavioral guidance, **not a technical guarantee of memory isolation**.

## Automated repository maintenance (only when requested)

The deterministic local index and audit generator is `python scripts/sync_skill_audit.py --write`, with `--check` for a read-only CI test. See `AUDIT_AUTOMATION.md`. Do **not** run it to initialize a chat. `*-context-init` remains an optional **read-only** catalog overview. Existing expert review evidence is historical and never automatically renewed after a Skill changes.
