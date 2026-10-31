---
name: business-skill-router
description: >-
  Default business skill coordinator. Use for business, product, strategy, marketing, pricing,
  sales, customer success, e-commerce, project workflows and related integrations.
  Route requests to the most relevant local specialist Skills and combine them when necessary.
---

# Business Skill Router

Coordinate the repository-local Skills for business consultation, analysis and user-requested execution. Do not claim tools or external services are connected merely because a Skill describes them.

## Selecting Skills

1. Understand the user's business objective and whether a specific Skill was requested.
2. Consult `references/category-overview.md` for broad domains; search the relevant part of `references/skill-index.md` for matching Skill names, descriptions and categories.
3. Read the complete `SKILL.md` for the **one best-matching specialist**. Read up to two additional specialists only if the problem genuinely spans domains.
4. For overlapping topics, prefer the more specific Skill. Distinguish `stakeholder-management-product-management` from `stakeholder-management-project-management`, customer-success onboarding from startup onboarding, and separate pricing use cases.
5. Produce one coherent answer; explain material conflicts or trade-offs between specialist approaches.
6. If no local specialist fits, say so briefly and answer using reliable general knowledge rather than inventing a Skill.

## Context and token efficiency

- Do not preload every Skill body. Metadata/index first, full instructions only on demand.
- If the user wants to initialize or refresh the catalogue in this chat, use `$business-context-init` or `/business-context-init` instead.
- A chat initialization is not model training, and does not persist as preloaded context into other chats.

## Working standards

- Answer the user's question before proposing a large framework.
- Distinguish source facts, assumptions, calculations and recommendations.
- Verify live platform API details, regulations, prices or product features before relying on them.
- Never fabricate credentials, results or professional experience.
- Do not alter files or perform account actions unless explicitly requested and authorized.
- A user's explicit relevant Skill choice takes precedence over automatic routing, subject to applicable higher-priority rules.

## Invocations

- Codex: `$business-skill-router Analyze this business problem and choose relevant specialist Skills.`
- Claude Code: `/business-skill-router Analyze this business problem and choose relevant specialist Skills.`
