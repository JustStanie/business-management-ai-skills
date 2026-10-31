---
name: beehiiv
description: Use for Beehiiv newsletters, subscriber management, campaigns, publications, analytics, automations
  and API integration planning.
---

# Beehiiv Newsletter and API Integration

## Purpose and scope

Support decisions and workflows concerning **Beehiiv**, within **Newsletter & Email Platforms**. Use the documented Beehiiv capabilities relevant to the user's question; verify plan-level availability and API support. If current vendor/platform behavior or external facts matter, verify them before making specific claims.

**Scope:** Newsletter publication setup, API v2 subscriptions, posts, analytics, campaign automations, list management and referral programs.

## Intake — ask only for information that changes the outcome

- Platform and available API/plan features.
- Audience consent, segmentation, sending domain and suppression lists.
- Event triggers, campaigns, transactional mail and reporting.

## Specialist workflow

1. **Identify the specific beehiiv goal.** Clarify the user's desired outcome, time horizon, decision to be made and constraints.
2. **Determine what is known.** Separate supplied facts and evidence from assumptions; identify critical missing inputs rather than inventing them.
3. **Map:** Map subscriptions, contacts, templates, events and unsubscribes.
4. **Design:** Design authentication, deliverability, sender reputation and event/webhook handling.
5. **Build:** Build staged tests for opt-in, unsubscribe, bounces, retries and reporting.
6. **Produce an actionable result.** Adapt the plan, technical specification or explanation to the real setting; give trade-offs, owners, measurable checks and next steps where useful.

## API compatibility notes (checked 2026-10-31)

- The documented API v2 subscription endpoint is `POST /v2/publications/{publicationId}/subscriptions` on `https://api.beehiiv.com`, with bearer authentication and appropriate write scope. Confirm current account permissions before implementing.
- Use `reactivate_existing: false` unless you have explicit permission to resubscribe; use the publication's double opt-in behavior and do not silently override it.
- For listing subscribers, use cursor-based pagination rather than deprecated `page`-based pagination; handle 429/retries and consent status.
- Use verified API responses and webhook delivery semantics; publication-specific configuration can affect availability.
- Reference: https://developers.beehiiv.com/api-reference/subscriptions/create

## Suggested deliverables

- Email platform integration plan.
- Deliverability, privacy and webhook test cases.
- A **Beehiiv**-specific checklist that reflects the imported scope above.

## Validation and safeguards

- Verify current platform API and product limitations.
- Honor consent, unsubscribe and local anti-spam rules.
- Never share credentials, tokens or full mailing lists.
- Do not claim access to accounts, current statistics, live APIs or implementation testing unless actually available and performed.
- Be transparent about information gaps. Prefer concise answers to unnecessary reports for simple questions.

## Example prompts

**Codex**

```text
$beehiiv Design a Beehiiv integration for subscriber consent, campaigns, transactional events, unsubscriptions and deliverability. Specify data flows, current documentation to verify, security and failure handling.
```

**Claude Code**

```text
/beehiiv Review my Beehiiv implementation plan for API compatibility, permissions, idempotency and a practical test checklist.
```

## Technical audit acceptance checks (2026-10-31)

- **Skill-specific objective:** Beehiiv newsletters, subscriber management, campaigns, publications, analytics, automations and API integration planning (verify inputs, the user's intended output, and reproducible acceptance evidence).
- **Domain correctness:** Verify current provider API, authentication, subscription status and consent requirements.
- **Failure and assurance:** Test unsubscribe, bounce handling, deduplication, retries, and suppression-list reconciliation.
- **External integrations:** Treat vendor-specific API capabilities and example payloads as version-dependent. Pin documentation/schema versions and validate permissions and side effects against a sandbox before production.
- **Code examples:** Examples require dependency/version pinning, dry runs, credential separation, and integration tests; Markdown formatting is not evidence of compilability or live execution.
