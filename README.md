# Business AI Skills

## Automated Skill catalog and audit status

<!-- AUTO-SKILL-SUMMARY:START -->
**Live inventory:** 117 Skills = 115 specialist + 2 support; **14 categories**.

The up-to-date category/Skill catalog is [`SKILL_INDEX.md`](SKILL_INDEX.md). The automatically synchronized audit status is [`TECHNICAL_AUDIT.md`](TECHNICAL_AUDIT.md); machine-readable checks are [`AUDIT_VALIDATION_RESULTS.json`](AUDIT_VALIDATION_RESULTS.json) and [`audit-register.json`](audit-register.json).

**Historical review status:** 115 unchanged since prior static review; 0 changed and pending reassessment; 0 new/unreviewed.

To refresh this catalog and audit reports, run `python scripts/sync_skill_audit.py --write` manually after editing Skills. No GitHub Actions or automatic commits are configured. This does not imply a new expert review.
<!-- AUTO-SKILL-SUMMARY:END -->

## Local audit maintenance — manual only

`SKILL_INDEX.md`, `audit-register.json`, `AUDIT_VALIDATION_RESULTS.json` and `TECHNICAL_AUDIT.md` are now **generated, not manually maintained**. The generator also refreshes the inventory summary at the top of this README. For manual maintenance, caveats and review status definitions, see [`AUDIT_AUTOMATION.md`](AUDIT_AUTOMATION.md).

```powershell
python .\scripts\sync_skill_audit.py --write
python .\scripts\sync_skill_audit.py --check
python -m unittest discover -s tests -p "test_*.py" -v
```

No GitHub Actions are configured: nothing runs on push or pull request, and no automatic commits are created. The local audit generator runs **only when explicitly invoked**. **Structural validation is not a fresh technical expert review.** New/changed methodologies require a separate substantive assessment.



> Local business strategy, marketing, sales, product, e-commerce, customer success and operations Skills for **Codex** and **Claude Code**.

**117 Skills total:** 115 specialist Skills + `business-skill-router` + `business-context-init`. **14 active categories.**

**Skill catalog:** [`SKILL_INDEX.md`](SKILL_INDEX.md) at the repository root is the compact inventory used for skill discovery and optional chat initialization. The detailed category overview remains at `.agents/skills/business-skill-router/references/category-overview.md`. These files describe available methods, not preferences or history from previous chats.

## Technical audit and validation

- [`TECHNICAL_AUDIT.md`](TECHNICAL_AUDIT.md) — previous content audit restored and reconciled to the current **115 specialist Skills**.
- [`audit-register.json`](audit-register.json) — structured per-Skill review entries for the current inventory.
- [`AUDIT_VALIDATION_RESULTS.json`](AUDIT_VALIDATION_RESULTS.json) — current structural validation and audit provenance.

The review is **not** an assurance that every API call, financial rule or vendor integration has been production-tested. No content from deleted Skills is silently restored.

## Working with multiple chats and local Skills

**Recommended rule: one repository = one specialist knowledge library; one chat = one independent topic or project.**

### Keep independent chats independent

**A new chat should not inherit your preferences or decisions from an unrelated previous chat.** The agent chooses Skills and makes recommendations from the **current question**, the current chat and relevant evidence. Sharing the same repository only means the same specialist methods are available; it does not make a past topic a preference.

**Example (Crypto):** if chat A is about developing Solana smart contracts and chat B is about constructing a crypto portfolio, the agent should **not** promote SOL merely because you discussed Solana in chat A. SOL may be considered only if it independently fits the portfolio criteria or you request it.

If you **want** to continue an earlier discussion in a new chat, explicitly say so and provide its summary or files (or authorize the agent to retrieve relevant prior work when supported). Do not assume earlier decisions are present. `*-context-init` is **optional** and only maps available Skills; it **does not import earlier chats or clear memory**.

> **Limit:** this policy controls how the repo instructs the agent to behave; it cannot disable built-in cross-chat memory, global instructions, or other context sources provided by Codex/Claude. For strict separation, check the client's memory/privacy controls and workspace boundaries.

| Your situation | What to do | Is context initialization required? |
|---|---|---|
| New, unrelated question within business, marketing, sales, product management and operations | Open **business-management-ai-skills** in Codex Desktop or Claude Code and start a **new chat/thread**. Ask your question normally. | **No.** Repository instructions already direct the agent to the coordinator. |
| Continue an earlier discussion on the same problem | Return to the **existing chat** to retain its history and decisions. | No. |
| Want a quick overview of available Skills, or have just changed the library | In that chat, explicitly invoke the **context initializer**. | Optional, useful on demand. |
| Want to force a particular specialist | Invoke `$skill-name` (Codex) or `/skill-name` (Claude Code), if the client discovers that Skill. | No. |
| Need a different domain | Open that domain's **separate repository** and start a chat there. | No. Other repositories' Skills are not automatically included. |

### Start a new topic

**Codex Desktop:** open the `'business-management-ai-skills'` repository as a project, choose **New Thread / New Chat**, then ask your question. You do **not** need to clone the repository again or create a new folder for each discussion.

**Claude Code:** open a new session from the repository root (assuming the `claude` CLI is installed):

```powershell
cd C:\Code\Projects\SKILLS\business-management-ai-skills
claude
```

Within the active session, use `/clear` for a fresh conversation only if supported by your installed version, or exit and start `claude` again. Reuse an existing session when previous decisions are relevant.

### How the assistant picks Skills

1. The project `AGENTS.md` (Codex) or `CLAUDE.md` (Claude Code) directs the agent to the default `business-skill-router`.
2. The coordinator identifies the topic, consults available Skill metadata, and reads only the relevant `SKILL.md` file(s).
3. You receive one coherent answer. Full instructions for all Skills are **not** loaded into every new conversation.

**Run `business-context-init` only when you want to initialize or refresh the catalog explicitly.**

| Agent | Optional catalog initialization | Explicit coordinator |
|---|---|---|
| Codex Desktop | `$business-context-init` | `$business-skill-router` |
| Claude Code | `/business-context-init` | `/business-skill-router` |

If the command is not discovered, ask: `Read .agents/skills/business-context-init/SKILL.md and provide a brief overview of the local skill catalog without loading all specialists.`

**Important:** initialization is not model training or permanent memory. A new chat has separate conversation history. If you need to continue specific decisions from another chat, provide a concise summary or relevant files. Repository files and Skills remain available in new sessions, subject to your agent version, file access, and global instruction priority.

## Start here — initialize Skill context (optional)

This is an **optional, on-demand command for the current chat**, not a global installation or AI training step. It reads a compact description of the library, then only loads specialist instructions when you ask a specific question.

| Agent | Initialize Skill catalogue | Ask the default coordinator |
|---|---|---|
| **Codex** | `$business-context-init` | `$business-skill-router` |
| **Claude Code** | `/business-context-init` | `/business-skill-router` |

**Copy-paste initialization prompts:**

Codex:
```text
$business-context-init Initialize the local Skills for this chat. Summarize available categories, then route my next questions to relevant specialists without loading everything at once.
```

Claude Code:
```text
/business-context-init Initialize the local Skills for this chat. Summarize available categories, then route my next questions to relevant specialists without loading everything at once.
```

**Manual fallback (if your client does not discover the skill):**
```text
Read .agents/skills/business-context-init/SKILL.md and initialize this chat using the local skill catalogue. Do not read all specialist SKILL.md files.
```

> **Important:** no command can permanently preload these files into the model. A fresh chat does not require initialization; ordinary questions work without it because the router is referenced in the project instructions. Codex `/init` is a different command for creating project guidance and is not this library initializer.

## Repository setup (Windows 11 / PowerShell)

```powershell
cd C:\Code\Projects\SKILLS
git clone https://github.com/JustStanie/business-management-ai-skills.git
cd business-management-ai-skills
powershell -NoProfile -ExecutionPolicy Bypass -File .\setup-claude-skills.ps1
```

The setup script creates a local Windows Junction from `.claude/skills/` to `.agents/skills/`, preserving a single physical library. The Junction is not stored in Git; rerun setup after cloning on a different computer.

**Confirm the local Claude link:**

```powershell
Get-Item .\.claude\skills | Format-List FullName,LinkType,Target
```

After setup, start a new Claude Code session and check skill discovery. Availability of slash-invocable Skills depends on your installed version.

## How to use any Skill

You can ask an ordinary question and let the router choose. To request a specialist explicitly, use `$skill-name` in Codex or `/skill-name` in Claude Code when detected.

```text
$marketing-analytics Audit our acquisition data, distinguish attribution from incrementality, and recommend three measurement improvements.
/marketing-analytics Evaluate our CAC and channel reporting, identify misleading metrics, and propose a reliable dashboard.
```

For a multi-domain task:
```text
$business-skill-router Diagnose low activation, weak pricing and high churn in our SaaS product. Select the specialists and give a prioritized action plan.
```

## Current Skills by category

Categories expand on click. Once expanded, each Skill shows its purpose, practical capabilities and two ready-to-use prompts. Names below are generated from Skills **actually present** in this repository; deleted Skills are not listed.

<details>
<summary><strong>Accounting Platforms & APIs (1 Skills)</strong> — Accounting platform data, invoices, reconciliation and third-party API integrations.</summary>

### Accounting Platforms & APIs

#### `odoo-accounting-xml-rpc-json-rpc-api` — Odoo Accounting Xml Rpc Json Rpc Api

**Purpose:** Use for Odoo accounting integrations, invoices, payments, partners, journal entries and version-specific migration from legacy XML-RPC/JSON-RPC to JSON-2.

**What you can do:**
- Map the accounting data model and reconcile object ownership. Then design a staged integration: credentials, read-only discovery, write operations, reconciliation and recovery. Apply these to **Odoo.
- Integration design with mapping and dependencies; API validation and reconciliation test matrix.

**Codex prompt:**
```text
$odoo-accounting-xml-rpc-json-rpc-api Plan an Odoo 20 accounting integration using current JSON-2 capabilities; identify how to migrate legacy XML-RPC calls.
```

**Claude Code prompt:**
```text
/odoo-accounting-xml-rpc-json-rpc-api Review our Odoo RPC integration risks, version compatibility, reconciliation and idempotency.
```

</details>

<details>
<summary><strong>Strategy & Consulting (12 Skills)</strong> — Business diagnostics, strategic positioning and organizational decisions.</summary>

### Strategy & Consulting

#### `adversarial-problem-solving` — Adversarial Problem Solving

**Purpose:** Apply structured adversarial analysis to generate, critique, fix, validate, and consolidate solutions for complex problems. Forces deep analysis of failure modes, edge cases, and unintended consequences before committing.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Adversarial Problem Solving**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$adversarial-problem-solving Use Adversarial Problem Solving to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/adversarial-problem-solving Challenge our current Adversarial Problem Solving approach and recommend measurable changes with assumptions and decision criteria.
```

#### `brand-strategy` — Brand Strategy

**Purpose:** Use for brand strategy tasks: lead a full brand strategy engagement — from brand audit and identity architecture to rebranding execution for established tech companies.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Brand Strategy**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$brand-strategy Use Brand Strategy to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/brand-strategy Challenge our current Brand Strategy approach and recommend measurable changes with assumptions and decision criteria.
```

#### `change-management` — Change Management

**Purpose:** Use for change management tasks: lead organizational change management — guiding companies through rebrands, restructures, mergers, technology transitions, and cultural transformations.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Change Management**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$change-management Use Change Management to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/change-management Challenge our current Change Management approach and recommend measurable changes with assumptions and decision criteria.
```

#### `communications-pr` — Communications Pr

**Purpose:** Use for communications pr tasks: craft corporate communications and PR strategies — narrative development, media relations, thought leadership, crisis communications, and stakeholder messaging for technology companies.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Communications Pr**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$communications-pr Use Communications Pr to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/communications-pr Challenge our current Communications Pr approach and recommend measurable changes with assumptions and decision criteria.
```

#### `customer-experience` — Customer Experience

**Purpose:** Design and optimize customer experiences — journey mapping, experience auditing, retention strategy, and customer-centric growth for technology companies.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Customer Experience**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$customer-experience Use Customer Experience to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/customer-experience Challenge our current Customer Experience approach and recommend measurable changes with assumptions and decision criteria.
```

#### `data-analytics-strategy` — Data Analytics Strategy

**Purpose:** Design data and analytics strategies — KPI frameworks, measurement systems, data-driven decision making, and analytics capability building for technology companies.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Data Analytics Strategy**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$data-analytics-strategy Use Data Analytics Strategy to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/data-analytics-strategy Challenge our current Data Analytics Strategy approach and recommend measurable changes with assumptions and decision criteria.
```

#### `digital-transformation` — Digital Transformation

**Purpose:** Guide digital transformation initiatives for established companies — technology modernization, process digitization, organizational capability building, and strategic technology adoption.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Digital Transformation**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$digital-transformation Use Digital Transformation to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/digital-transformation Challenge our current Digital Transformation approach and recommend measurable changes with assumptions and decision criteria.
```

#### `document-management` — Document Management

**Purpose:** Use for document management tasks: organize, structure, and manage documents and files for maximum retrievability and team collaboration.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Document Management**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$document-management Use Document Management to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/document-management Challenge our current Document Management approach and recommend measurable changes with assumptions and decision criteria.
```

#### `financial-strategy` — Financial Strategy

**Purpose:** Build financial models, analyze unit economics, design pricing strategies, and create investor-ready financial plans for technology companies.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Financial Strategy**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$financial-strategy Use Financial Strategy to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/financial-strategy Challenge our current Financial Strategy approach and recommend measurable changes with assumptions and decision criteria.
```

#### `go-to-market` — Go To Market

**Purpose:** Design and execute go-to-market strategies — launch planning, pricing, channel strategy, sales motions, and growth models for tech products and companies.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Go to Market**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$go-to-market Use Go to Market to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/go-to-market Challenge our current Go to Market approach and recommend measurable changes with assumptions and decision criteria.
```

#### `management-consulting` — Management Consulting

**Purpose:** Apply top-tier management consulting frameworks to business strategy — competitive analysis, growth strategy, operational excellence, and strategic planning.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Management Consulting**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$management-consulting Use Management Consulting to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/management-consulting Challenge our current Management Consulting approach and recommend measurable changes with assumptions and decision criteria.
```

#### `market-positioning` — Market Positioning

**Purpose:** Develop competitive market positioning strategies for tech companies operating in saturated markets — finding whitespace, creating differentiation, and building defensible positions.

**What you can do:**
- Frame the problem and distinguish symptoms from underlying causes. Then generate at least two credible alternatives and explicit decision criteria. Apply these to **Market Positioning**.
- Decision brief with alternatives and a recommendation; Milestone plan with owners, KPIs and validation checks.

**Codex prompt:**
```text
$market-positioning Use Market Positioning to analyze a B2B software company facing slowing growth. Frame options, risks, evidence and a 90-day action plan.
```

**Claude Code prompt:**
```text
/market-positioning Challenge our current Market Positioning approach and recommend measurable changes with assumptions and decision criteria.
```

</details>

<details>
<summary><strong>Customer Success (10 Skills)</strong> — Customer retention, onboarding, expansion and account health.</summary>

### Customer Success

#### `churn-prevention` — Churn Prevention

**Purpose:** Use this skill when identifying at-risk customers, designing save plays, timing interventions, conducting churn root cause analysis, running churn post-mortems, or distinguishing between involuntary and voluntary churn.

**What you can do:**
- Define the customer outcome and measurable success milestone. Then segment accounts by need and choose tailored engagement plays. Apply these to **Churn Prevention**.
- Customer success playbook and outreach timeline; Retention/health metrics with action thresholds.

**Codex prompt:**
```text
$churn-prevention Build a Churn Prevention playbook for a SaaS company with 120 active accounts. Include leading signals, milestones and owners.
```

**Claude Code prompt:**
```text
/churn-prevention Audit our Churn Prevention workflow and propose interventions we can validate against churn and adoption metrics.
```

#### `cs-operations` — Cs Operations

**Purpose:** Use this skill when designing CS team structures, managing book of business assignments, determining CSM-to-account ratios, building tech-touch and high-touch segmentation models, selecting CS tools and platforms, or building CS metrics and reporting frameworks.

**What you can do:**
- Define the customer outcome and measurable success milestone. Then segment accounts by need and choose tailored engagement plays. Apply these to **Cs Operations**.
- Customer success playbook and outreach timeline; Retention/health metrics with action thresholds.

**Codex prompt:**
```text
$cs-operations Build a Cs Operations playbook for a SaaS company with 120 active accounts. Include leading signals, milestones and owners.
```

**Claude Code prompt:**
```text
/cs-operations Audit our Cs Operations workflow and propose interventions we can validate against churn and adoption metrics.
```

#### `customer-advocacy` — Customer Advocacy

**Purpose:** Use this skill when building customer advocacy programs, soliciting case studies and references, driving reviews and testimonials, running NPS programs, establishing customer advisory boards, or identifying and nurturing internal champions.

**What you can do:**
- Define the customer outcome and measurable success milestone. Then segment accounts by need and choose tailored engagement plays. Apply these to **Customer Advocacy**.
- Customer success playbook and outreach timeline; Retention/health metrics with action thresholds.

**Codex prompt:**
```text
$customer-advocacy Build a Customer Advocacy playbook for a SaaS company with 120 active accounts. Include leading signals, milestones and owners.
```

**Claude Code prompt:**
```text
/customer-advocacy Audit our Customer Advocacy workflow and propose interventions we can validate against churn and adoption metrics.
```

#### `customer-feedback-loops` — Customer Feedback Loops

**Purpose:** Use this skill when designing feedback collection systems, implementing NPS/CSAT/CES surveys, building processes to route customer feedback to product teams, closing the loop with customers on their feedback, or establishing voice of customer programs.

**What you can do:**
- Define the customer outcome and measurable success milestone. Then segment accounts by need and choose tailored engagement plays. Apply these to **Customer Feedback Loops**.
- Customer success playbook and outreach timeline; Retention/health metrics with action thresholds.

**Codex prompt:**
```text
$customer-feedback-loops Build a Customer Feedback Loops playbook for a SaaS company with 120 active accounts. Include leading signals, milestones and owners.
```

**Claude Code prompt:**
```text
/customer-feedback-loops Audit our Customer Feedback Loops workflow and propose interventions we can validate against churn and adoption metrics.
```

#### `customer-onboarding` — Customer Onboarding

**Purpose:** Use this skill when designing or improving customer onboarding programs, defining time-to-first-value milestones, planning kickoff calls, building implementation timelines, or deciding between self-serve and high-touch onboarding models.

**What you can do:**
- Define the customer outcome and measurable success milestone. Then segment accounts by need and choose tailored engagement plays. Apply these to **Customer Onboarding**.
- Customer success playbook and outreach timeline; Retention/health metrics with action thresholds.

**Codex prompt:**
```text
$customer-onboarding Build a Customer Onboarding playbook for a SaaS company with 120 active accounts. Include leading signals, milestones and owners.
```

**Claude Code prompt:**
```text
/customer-onboarding Audit our Customer Onboarding workflow and propose interventions we can validate against churn and adoption metrics.
```

#### `escalation-management` — Escalation Management

**Purpose:** Use this skill when handling customer escalations, defining severity levels and escalation paths, engaging executive sponsors during crises, applying de-escalation techniques, or planning post-escalation recovery.

**What you can do:**
- Define the customer outcome and measurable success milestone. Then segment accounts by need and choose tailored engagement plays. Apply these to **Escalation Management**.
- Customer success playbook and outreach timeline; Retention/health metrics with action thresholds.

**Codex prompt:**
```text
$escalation-management Build a Escalation Management playbook for a SaaS company with 120 active accounts. Include leading signals, milestones and owners.
```

**Claude Code prompt:**
```text
/escalation-management Audit our Escalation Management workflow and propose interventions we can validate against churn and adoption metrics.
```

#### `expansion-revenue` — Expansion Revenue

**Purpose:** Use this skill when developing upsell and cross-sell strategies, building expansion playbooks, identifying expansion signals in customer behavior, timing the expansion ask, positioning CSMs as revenue drivers, or executing land-and-expand motions.

**What you can do:**
- Define the customer outcome and measurable success milestone. Then segment accounts by need and choose tailored engagement plays. Apply these to **Expansion Revenue**.
- Customer success playbook and outreach timeline; Retention/health metrics with action thresholds.

**Codex prompt:**
```text
$expansion-revenue Build a Expansion Revenue playbook for a SaaS company with 120 active accounts. Include leading signals, milestones and owners.
```

**Claude Code prompt:**
```text
/expansion-revenue Audit our Expansion Revenue workflow and propose interventions we can validate against churn and adoption metrics.
```

#### `health-scoring` — Health Scoring

**Purpose:** Use this skill when building or refining customer health score models, selecting leading indicators for churn or expansion, designing weighted scoring systems, implementing red/yellow/green frameworks, or building predictive churn models.

**What you can do:**
- Define the customer outcome and measurable success milestone. Then segment accounts by need and choose tailored engagement plays. Apply these to **Health Scoring**.
- Customer success playbook and outreach timeline; Retention/health metrics with action thresholds.

**Codex prompt:**
```text
$health-scoring Build a Health Scoring playbook for a SaaS company with 120 active accounts. Include leading signals, milestones and owners.
```

**Claude Code prompt:**
```text
/health-scoring Audit our Health Scoring workflow and propose interventions we can validate against churn and adoption metrics.
```

#### `qbr-business-reviews` — Qbr Business Reviews

**Purpose:** Use this skill when planning or conducting quarterly business reviews, building QBR templates and decks, presenting success metrics to customers, facilitating strategic planning conversations, or engaging executive stakeholders in review meetings.

**What you can do:**
- Define the customer outcome and measurable success milestone. Then segment accounts by need and choose tailored engagement plays. Apply these to **Qbr Business Reviews**.
- Customer success playbook and outreach timeline; Retention/health metrics with action thresholds.

**Codex prompt:**
```text
$qbr-business-reviews Build a Qbr Business Reviews playbook for a SaaS company with 120 active accounts. Include leading signals, milestones and owners.
```

**Claude Code prompt:**
```text
/qbr-business-reviews Audit our Qbr Business Reviews workflow and propose interventions we can validate against churn and adoption metrics.
```

#### `renewal-management` — Renewal Management

**Purpose:** Use this skill when managing renewal processes, defining renewal timelines and touchpoints, negotiating multi-year deals, handling pricing conversations at renewal, building renewal forecasting models, or designing auto-renewal strategies.

**What you can do:**
- Define the customer outcome and measurable success milestone. Then segment accounts by need and choose tailored engagement plays. Apply these to **Renewal Management**.
- Customer success playbook and outreach timeline; Retention/health metrics with action thresholds.

**Codex prompt:**
```text
$renewal-management Build a Renewal Management playbook for a SaaS company with 120 active accounts. Include leading signals, milestones and owners.
```

**Claude Code prompt:**
```text
/renewal-management Audit our Renewal Management workflow and propose interventions we can validate against churn and adoption metrics.
```

</details>

<details>
<summary><strong>E-commerce Business Models (8 Skills)</strong> — Marketplace operations, fulfillment, conversion and customer economics.</summary>

### E-commerce Business Models

#### `conversion-rate-optimization` — Conversion Rate Optimization

**Purpose:** Use for e-commerce conversion-rate optimization, A/B testing, customer journey audits, friction reduction and measurement.

**What you can do:**
- Diagnose unit economics and customer journey before selecting tactics. Then prioritize levers by impact, confidence, effort and operational risk. Apply these to **Conversion Rate Optimization**.
- E-commerce operating playbook; Margin and conversion experiment plan.

**Codex prompt:**
```text
$conversion-rate-optimization Improve Conversion Rate Optimization for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/conversion-rate-optimization Review our Conversion Rate Optimization approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `customer-retention-for-ecommerce` — Customer Retention For Ecommerce

**Purpose:** Use for e-commerce retention, repeat-purchase analysis, lifecycle journeys, loyalty design and customer cohort improvements.

**What you can do:**
- Diagnose unit economics and customer journey before selecting tactics. Then prioritize levers by impact, confidence, effort and operational risk. Apply these to **Customer Retention For Ecommerce**.
- E-commerce operating playbook; Margin and conversion experiment plan.

**Codex prompt:**
```text
$customer-retention-for-ecommerce Improve Customer Retention For Ecommerce for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/customer-retention-for-ecommerce Review our Customer Retention For Ecommerce approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `dropshipping-operations` — Dropshipping Operations

**Purpose:** Use for dropshipping supplier operations, sourcing reliability, margins, shipping quality, refunds and fulfillment processes.

**What you can do:**
- Diagnose unit economics and customer journey before selecting tactics. Then prioritize levers by impact, confidence, effort and operational risk. Apply these to **Dropshipping Operations**.
- E-commerce operating playbook; Margin and conversion experiment plan.

**Codex prompt:**
```text
$dropshipping-operations Improve Dropshipping Operations for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/dropshipping-operations Review our Dropshipping Operations approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `email-marketing-for-ecommerce` — Email Marketing For Ecommerce

**Purpose:** Use for e-commerce email lifecycle strategy, segmentation, automations, deliverability, consent and campaign measurement.

**What you can do:**
- Diagnose unit economics and customer journey before selecting tactics. Then prioritize levers by impact, confidence, effort and operational risk. Apply these to **Email Marketing For Ecommerce**.
- E-commerce operating playbook; Margin and conversion experiment plan.

**Codex prompt:**
```text
$email-marketing-for-ecommerce Improve Email Marketing For Ecommerce for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/email-marketing-for-ecommerce Review our Email Marketing For Ecommerce approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `marketplace-selling` — Marketplace Selling

**Purpose:** Use for selling across marketplaces, listing optimization, channel-specific economics, fulfillment and compliance.

**What you can do:**
- Diagnose unit economics and customer journey before selecting tactics. Then prioritize levers by impact, confidence, effort and operational risk. Apply these to **Marketplace Selling**.
- E-commerce operating playbook; Margin and conversion experiment plan.

**Codex prompt:**
```text
$marketplace-selling Improve Marketplace Selling for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/marketplace-selling Review our Marketplace Selling approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `pricing-strategy` — Pricing Strategy

**Purpose:** Use for e-commerce pricing architecture, cost floors, willingness-to-pay, discount design, bundles and price experiments.

**What you can do:**
- Diagnose unit economics and customer journey before selecting tactics. Then prioritize levers by impact, confidence, effort and operational risk. Apply these to **Pricing Strategy**.
- E-commerce operating playbook; Margin and conversion experiment plan.

**Codex prompt:**
```text
$pricing-strategy Improve Pricing Strategy for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/pricing-strategy Review our Pricing Strategy approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `print-on-demand-business` — Print On Demand Business

**Purpose:** Use for print-on-demand product validation, supplier selection, merchandising, unit economics and store operations.

**What you can do:**
- Diagnose unit economics and customer journey before selecting tactics. Then prioritize levers by impact, confidence, effort and operational risk. Apply these to **Print On Demand Business**.
- E-commerce operating playbook; Margin and conversion experiment plan.

**Codex prompt:**
```text
$print-on-demand-business Improve Print On Demand Business for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/print-on-demand-business Review our Print On Demand Business approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `social-commerce` — Social Commerce

**Purpose:** Use for social commerce storefronts, live selling, influencer content, attribution, product selection and channel performance.

**What you can do:**
- Diagnose unit economics and customer journey before selecting tactics. Then prioritize levers by impact, confidence, effort and operational risk. Apply these to **Social Commerce**.
- E-commerce operating playbook; Margin and conversion experiment plan.

**Codex prompt:**
```text
$social-commerce Improve Social Commerce for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/social-commerce Review our Social Commerce approach and deliver a practical checklist, metrics and an experiment for the next month.
```

</details>

<details>
<summary><strong>E-commerce Services & APIs (1 Skills)</strong> — Shopping platforms, subscription commerce and vendor integrations.</summary>

### E-commerce Services & APIs

#### `saleor` — Saleor

**Purpose:** Integrate Saleor headless e-commerce via its GraphQL API for storefronts and dashboards. Handle checkout flows, payment gateways, and webhook app extensions with type-safe queries.

**What you can do:**
- Map end-to-end commerce data and checkout ownership. Then design authentication, product synchronization, order events and idempotent webhooks. Apply these to **Saleor**.
- Commerce integration specification; Checkout, refund and fulfillment QA checklist.

**Codex prompt:**
```text
$saleor Design a Saleor integration for catalog synchronization, checkout, order status, refunds and fulfillment. Specify data flows, current documentation to verify, security and failure handling.
```

**Claude Code prompt:**
```text
/saleor Review my Saleor implementation plan for API compatibility, permissions, idempotency and a practical test checklist.
```

</details>

<details>
<summary><strong>E-commerce Optimization (10 Skills)</strong> — Store economics, merchandising, conversion and logistics.</summary>

### E-commerce Optimization

#### `ecommerce-analytics` — Ecommerce Analytics

**Purpose:** Use when users need help with e-commerce analytics, including attribution modeling, ROAS calculation, customer acquisition metrics, cohort analysis, merchandising performance, and inventory analytics.

**What you can do:**
- Map the customer journey and diagnose its largest losses. Then identify merchandising, pricing, fulfillment or retention opportunities. Apply these to **Ecommerce Analytics**.
- Store optimization plan; Metrics and test backlog with owners.

**Codex prompt:**
```text
$ecommerce-analytics Improve Ecommerce Analytics for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/ecommerce-analytics Review our Ecommerce Analytics approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `ecommerce-conversion` — Ecommerce Conversion

**Purpose:** Use when users need help improving e-commerce conversion rates, reducing cart abandonment, optimizing checkout flows, or increasing revenue per visitor.

**What you can do:**
- Map the customer journey and diagnose its largest losses. Then identify merchandising, pricing, fulfillment or retention opportunities. Apply these to **Ecommerce Conversion**.
- Store optimization plan; Metrics and test backlog with owners.

**Codex prompt:**
```text
$ecommerce-conversion Improve Ecommerce Conversion for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/ecommerce-conversion Review our Ecommerce Conversion approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `ecommerce-pricing` — Ecommerce Pricing

**Purpose:** Use when users need help with e-commerce pricing strategy, including competitive pricing, dynamic pricing, psychological pricing tactics, promotional strategy, margin management, and MAP policy enforcement.

**What you can do:**
- Map the customer journey and diagnose its largest losses. Then identify merchandising, pricing, fulfillment or retention opportunities. Apply these to **Ecommerce Pricing**.
- Store optimization plan; Metrics and test backlog with owners.

**Codex prompt:**
```text
$ecommerce-pricing Improve Ecommerce Pricing for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/ecommerce-pricing Review our Ecommerce Pricing approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `fulfillment` — Fulfillment

**Purpose:** Use when users need help with order fulfillment operations, including shipping strategy, packaging design, returns management, international shipping, last-mile delivery, and warehouse operations.

**What you can do:**
- Map the customer journey and diagnose its largest losses. Then identify merchandising, pricing, fulfillment or retention opportunities. Apply these to **Fulfillment**.
- Store optimization plan; Metrics and test backlog with owners.

**Codex prompt:**
```text
$fulfillment Improve Fulfillment for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/fulfillment Review our Fulfillment approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `marketplace-strategy` — Marketplace Strategy

**Purpose:** Use when users need help selling on marketplaces like Amazon, Etsy, Walmart, or eBay. Covers listing optimization, Buy Box strategy, marketplace advertising (PPC), review management, multi-channel selling, pricing strategy, and account health.

**What you can do:**
- Map the customer journey and diagnose its largest losses. Then identify merchandising, pricing, fulfillment or retention opportunities. Apply these to **Marketplace Strategy**.
- Store optimization plan; Metrics and test backlog with owners.

**Codex prompt:**
```text
$marketplace-strategy Improve Marketplace Strategy for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/marketplace-strategy Review our Marketplace Strategy approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `merchandising` — Merchandising

**Purpose:** Use when users need help with digital merchandising, including product categorization, on-site search optimization, product recommendations, personalization, seasonal planning, cross-selling, and bundling strategies.

**What you can do:**
- Map the customer journey and diagnose its largest losses. Then identify merchandising, pricing, fulfillment or retention opportunities. Apply these to **Merchandising**.
- Store optimization plan; Metrics and test backlog with owners.

**Codex prompt:**
```text
$merchandising Improve Merchandising for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/merchandising Review our Merchandising approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `product-photography` — Product Photography

**Purpose:** Use when users need help with e-commerce product photography, including studio and lifestyle shoots, lighting setups, camera angles, product video, 360-degree views, user-generated content strategy, and Amazon A+ content imagery.

**What you can do:**
- Map the customer journey and diagnose its largest losses. Then identify merchandising, pricing, fulfillment or retention opportunities. Apply these to **Product Photography**.
- Store optimization plan; Metrics and test backlog with owners.

**Codex prompt:**
```text
$product-photography Improve Product Photography for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/product-photography Review our Product Photography approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `retention-loyalty` — Retention Loyalty

**Purpose:** Use when users need help with customer retention, loyalty programs, subscription models, re-engagement campaigns, or increasing customer lifetime value.

**What you can do:**
- Map the customer journey and diagnose its largest losses. Then identify merchandising, pricing, fulfillment or retention opportunities. Apply these to **Retention Loyalty**.
- Store optimization plan; Metrics and test backlog with owners.

**Codex prompt:**
```text
$retention-loyalty Improve Retention Loyalty for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/retention-loyalty Review our Retention Loyalty approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `storefront-design` — Storefront Design

**Purpose:** Use when users need help designing or improving an e-commerce storefront, including Shopify, WooCommerce, or custom platforms. Covers product page layouts, collection pages, navigation architecture, trust signals, mobile commerce optimization, and homepage design.

**What you can do:**
- Map the customer journey and diagnose its largest losses. Then identify merchandising, pricing, fulfillment or retention opportunities. Apply these to **Storefront Design**.
- Store optimization plan; Metrics and test backlog with owners.

**Codex prompt:**
```text
$storefront-design Improve Storefront Design for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/storefront-design Review our Storefront Design approach and deliver a practical checklist, metrics and an experiment for the next month.
```

#### `supply-chain` — Supply Chain

**Purpose:** Use when users need help with e-commerce supply chain management, including sourcing products, managing inventory, selecting fulfillment partners, demand forecasting, and supplier relationships.

**What you can do:**
- Map the customer journey and diagnose its largest losses. Then identify merchandising, pricing, fulfillment or retention opportunities. Apply these to **Supply Chain**.
- Store optimization plan; Metrics and test backlog with owners.

**Codex prompt:**
```text
$supply-chain Improve Supply Chain for an online store with low margins and high returns. Prioritize tests and estimate economics from stated assumptions.
```

**Claude Code prompt:**
```text
/supply-chain Review our Supply Chain approach and deliver a practical checklist, metrics and an experiment for the next month.
```

</details>

<details>
<summary><strong>Marketing & Growth (13 Skills)</strong> — Acquisition, content, brand positioning, SEO and campaign analytics.</summary>

### Marketing & Growth

#### `brand-marketing` — Brand Marketing

**Purpose:** Use when users need help with brand marketing, including brand awareness campaigns, brand building strategy, positioning execution, sponsorship evaluation, PR integration, brand equity measurement, or creative campaign development.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **Brand Marketing**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$brand-marketing Design a Brand Marketing campaign for a new B2B SaaS product. Specify audience, positioning, distribution and measurable hypotheses.
```

**Claude Code prompt:**
```text
/brand-marketing Audit our Brand Marketing results and propose three experiments with success metrics and realistic constraints.
```

#### `content-marketing` — Content Marketing

**Purpose:** Use when users need help with content marketing strategy, including content pillars, editorial calendar planning, content distribution, repurposing workflows, measurement, content-market fit, or content operations.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **Content Marketing**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$content-marketing Design a Content Marketing campaign for a new B2B SaaS product. Specify audience, positioning, distribution and measurable hypotheses.
```

**Claude Code prompt:**
```text
/content-marketing Audit our Content Marketing results and propose three experiments with success metrics and realistic constraints.
```

#### `content-repurposing` — Content Repurposing

**Purpose:** Use for content repurposing tasks: transform existing content into multiple formats and platforms to maximize reach and ROI from every piece created.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **Content Repurposing**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$content-repurposing Design a Content Repurposing campaign for a new B2B SaaS product. Specify audience, positioning, distribution and measurable hypotheses.
```

**Claude Code prompt:**
```text
/content-repurposing Audit our Content Repurposing results and propose three experiments with success metrics and realistic constraints.
```

#### `conversion-optimization` — Conversion Optimization

**Purpose:** Use when users need help with conversion rate optimization (CRO), including funnel analysis, A/B testing, landing page optimization, form design, checkout flow optimization, heatmap analysis, or user behavior analysis.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **Conversion Optimization**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$conversion-optimization Design a Conversion Optimization campaign for a new B2B SaaS product. Specify audience, positioning, distribution and measurable hypotheses.
```

**Claude Code prompt:**
```text
/conversion-optimization Audit our Conversion Optimization results and propose three experiments with success metrics and realistic constraints.
```

#### `email-marketing` — Email Marketing

**Purpose:** Use when users need help with email marketing strategy, including list building, segmentation, automation workflows, deliverability optimization, A/B testing, lifecycle marketing, newsletter strategy, or email performance metrics.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **Email Marketing**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$email-marketing Design a Email Marketing campaign for a new B2B SaaS product. Specify audience, positioning, distribution and measurable hypotheses.
```

**Claude Code prompt:**
```text
/email-marketing Audit our Email Marketing results and propose three experiments with success metrics and realistic constraints.
```

#### `event-marketing` — Event Marketing

**Purpose:** Use when users need help with event marketing, including conferences, webinars, workshops, virtual events, sponsorship activations, lead capture strategies, event ROI measurement, or event content creation.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **Event Marketing**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$event-marketing Design a Event Marketing campaign for a new B2B SaaS product. Specify audience, positioning, distribution and measurable hypotheses.
```

**Claude Code prompt:**
```text
/event-marketing Audit our Event Marketing results and propose three experiments with success metrics and realistic constraints.
```

#### `geo-content-optimizer` — Geo Content Optimizer

**Purpose:** Improve useful, trustworthy content for conventional search and AI-assisted discovery without promising citations, rankings, or special AI SEO tricks.

**What you can do:**
- Audit content originality, technical SEO, source accuracy and structured-data eligibility without inventing citation rules.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$geo-content-optimizer Audit our technical article for Google Search and AI-assisted discovery; identify content gaps, unsupported claims and measurable improvements.
```

**Claude Code prompt:**
```text
/geo-content-optimizer Review our article citations, structured data and indexing; suggest ethical improvements without promising AI rankings.
```

#### `influencer-strategy` — Influencer Strategy

**Purpose:** Use when users need help with influencer marketing, including influencer identification and vetting, outreach strategies, partnership structures, compensation models, campaign measurement, micro vs macro influencer decisions, or B2B influencer programs.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **Influencer Strategy**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$influencer-strategy Design a Influencer Strategy campaign for a new B2B SaaS product. Specify audience, positioning, distribution and measurable hypotheses.
```

**Claude Code prompt:**
```text
/influencer-strategy Audit our Influencer Strategy results and propose three experiments with success metrics and realistic constraints.
```

#### `marketing-analytics` — Marketing Analytics

**Purpose:** Use for marketing measurement, attribution, incrementality experiments, channel performance, CAC, cohorts and reporting dashboards.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **Marketing Analytics**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$marketing-analytics Define reliable CAC, incrementality, cohort and attribution measurement for our B2B SaaS marketing spend.
```

**Claude Code prompt:**
```text
/marketing-analytics Audit our campaign attribution dashboard and propose a measurement improvement plan.
```

#### `paid-acquisition` — Paid Acquisition

**Purpose:** Use when users need help with paid marketing channels including Google Ads, Meta Ads, LinkedIn Ads, TikTok Ads, or programmatic display.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **Paid Acquisition**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$paid-acquisition Design a Paid Acquisition campaign for a new B2B SaaS product. Specify audience, positioning, distribution and measurable hypotheses.
```

**Claude Code prompt:**
```text
/paid-acquisition Audit our Paid Acquisition results and propose three experiments with success metrics and realistic constraints.
```

#### `pricing-psychology` — Pricing Psychology

**Purpose:** Design pricing that converts using cognitive biases and proven psychological principles. Covers charm pricing, anchoring, decoys, bundling, scarcity, framing, social proof, and tiered architecture.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **Pricing Psychology**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$pricing-psychology Design a Pricing Psychology campaign for a new B2B SaaS product. Specify audience, positioning, distribution and measurable hypotheses.
```

**Claude Code prompt:**
```text
/pricing-psychology Audit our Pricing Psychology results and propose three experiments with success metrics and realistic constraints.
```

#### `seo` — Seo

**Purpose:** Use for technical SEO, keyword research, site architecture, crawlability, indexation and organic-search strategy.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **SEO**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$seo Audit our technical SEO, information architecture and indexing issues. Prioritize fixes by effort and impact.
```

**Claude Code prompt:**
```text
/seo Create a keyword clustering and internal linking plan for a SaaS documentation site.
```

#### `social-media-strategy` — Social Media Strategy

**Purpose:** Use when users need help with social media strategy, including platform selection, content strategy, community management, paid social integration, analytics, posting cadence, or crisis management.

**What you can do:**
- Define audience segments and a testable value proposition. Then select channels, messages, distribution and a measurement plan. Apply these to **Social Media Strategy**.
- A prioritized content-quality improvement plan with Search Console measurements and uncertainty notes.

**Codex prompt:**
```text
$social-media-strategy Design a Social Media Strategy campaign for a new B2B SaaS product. Specify audience, positioning, distribution and measurable hypotheses.
```

**Claude Code prompt:**
```text
/social-media-strategy Audit our Social Media Strategy results and propose three experiments with success metrics and realistic constraints.
```

</details>

<details>
<summary><strong>Newsletter & Email Platforms (2 Skills)</strong> — Email campaigns, list management and messaging APIs.</summary>

### Newsletter & Email Platforms

#### `beehiiv` — Beehiiv

**Purpose:** Use for Beehiiv newsletters, subscriber management, campaigns, publications, analytics, automations and API integration planning.

**What you can do:**
- Map subscriptions, contacts, templates, events and unsubscribes. Then design authentication, deliverability, sender reputation and event/webhook handling. Apply these to **Beehiiv**.
- Email platform integration plan; Deliverability, privacy and webhook test cases.

**Codex prompt:**
```text
$beehiiv Design a Beehiiv integration for subscriber consent, campaigns, transactional events, unsubscriptions and deliverability. Specify data flows, current documentation to verify, security and failure handling.
```

**Claude Code prompt:**
```text
/beehiiv Review my Beehiiv implementation plan for API compatibility, permissions, idempotency and a practical test checklist.
```

#### `loops` — Loops

**Purpose:** Use for loops tasks: email for SaaS, transactional + marketing, contacts, events, loops (automations), API sends, webhooks.

**What you can do:**
- Map subscriptions, contacts, templates, events and unsubscribes. Then design authentication, deliverability, sender reputation and event/webhook handling. Apply these to **Loops**.
- Email platform integration plan; Deliverability, privacy and webhook test cases.

**Codex prompt:**
```text
$loops Design a Loops integration for subscriber consent, campaigns, transactional events, unsubscriptions and deliverability. Specify data flows, current documentation to verify, security and failure handling.
```

**Claude Code prompt:**
```text
/loops Review my Loops implementation plan for API compatibility, permissions, idempotency and a practical test checklist.
```

</details>

<details>
<summary><strong>Payment Services & APIs (1 Skills)</strong> — Payment processors, checkout, recurring billing and payment operations.</summary>

### Payment Services & APIs

#### `paypal` — Paypal

**Purpose:** Use for PayPal checkout, order capture, subscriptions, webhooks, refunds, security, and payment integration planning or review.

**What you can do:**
- Map payment state machine and merchant/customer responsibilities. Then design secure checkout and idempotent server-side event processing. Apply these to **Paypal**.
- Payment architecture and integration checklist; Failure, webhook and reconciliation test plan.

**Codex prompt:**
```text
$paypal Design secure PayPal checkout and webhook handling with idempotency and server-side capture verification.
```

**Claude Code prompt:**
```text
/paypal Review our PayPal subscription activation process and risks of trusting client callbacks.
```

</details>

<details>
<summary><strong>Pricing & Monetization (8 Skills)</strong> — Offer packaging, subscription economics and price experiments.</summary>

### Pricing & Monetization

#### `competitive-pricing` — Competitive Pricing

**Purpose:** Use for competitive pricing tasks: you build systematic competitor price monitoring, deve.

**What you can do:**
- Map buyer willingness to pay and value metrics. Then model margin, elasticity scenarios, guardrails and segmentation. Apply these to **Competitive Pricing**.
- Pricing options with assumptions and trade-offs; Financial sensitivity table and experiment brief.

**Codex prompt:**
```text
$competitive-pricing Compare Competitive Pricing options for a subscription business with 60% gross margin and growing churn. Include risks and scenarios.
```

**Claude Code prompt:**
```text
/competitive-pricing Critique our Competitive Pricing proposal using customer value, willingness to pay, margin and experiment design.
```

#### `enterprise-pricing` — Enterprise Pricing

**Purpose:** Use for enterprise pricing tasks: you build pricing governance systems that protect ma.

**What you can do:**
- Map buyer willingness to pay and value metrics. Then model margin, elasticity scenarios, guardrails and segmentation. Apply these to **Enterprise Pricing**.
- Pricing options with assumptions and trade-offs; Financial sensitivity table and experiment brief.

**Codex prompt:**
```text
$enterprise-pricing Compare Enterprise Pricing options for a subscription business with 60% gross margin and growing churn. Include risks and scenarios.
```

**Claude Code prompt:**
```text
/enterprise-pricing Critique our Enterprise Pricing proposal using customer value, willingness to pay, margin and experiment design.
```

#### `monetization-models` — Monetization Models

**Purpose:** Use for monetization models tasks: you evaluate and design transaction-based, subscription, marketplace, licensing, advertisi.

**What you can do:**
- Map buyer willingness to pay and value metrics. Then model margin, elasticity scenarios, guardrails and segmentation. Apply these to **Monetization Models**.
- Pricing options with assumptions and trade-offs; Financial sensitivity table and experiment brief.

**Codex prompt:**
```text
$monetization-models Compare Monetization Models options for a subscription business with 60% gross margin and growing churn. Include risks and scenarios.
```

**Claude Code prompt:**
```text
/monetization-models Critique our Monetization Models proposal using customer value, willingness to pay, margin and experiment design.
```

#### `price-increase-strategy` — Price Increase Strategy

**Purpose:** Use for price increase strategy tasks: you build communication strategies, migration paths, and cu.

**What you can do:**
- Map buyer willingness to pay and value metrics. Then model margin, elasticity scenarios, guardrails and segmentation. Apply these to **Price Increase Strategy**.
- Pricing options with assumptions and trade-offs; Financial sensitivity table and experiment brief.

**Codex prompt:**
```text
$price-increase-strategy Compare Price Increase Strategy options for a subscription business with 60% gross margin and growing churn. Include risks and scenarios.
```

**Claude Code prompt:**
```text
/price-increase-strategy Critique our Price Increase Strategy proposal using customer value, willingness to pay, margin and experiment design.
```

#### `price-optimization` — Price Optimization

**Purpose:** Use for price optimization tasks: you build price elasticity models, design pricing experim.

**What you can do:**
- Map buyer willingness to pay and value metrics. Then model margin, elasticity scenarios, guardrails and segmentation. Apply these to **Price Optimization**.
- Pricing options with assumptions and trade-offs; Financial sensitivity table and experiment brief.

**Codex prompt:**
```text
$price-optimization Compare Price Optimization options for a subscription business with 60% gross margin and growing churn. Include risks and scenarios.
```

**Claude Code prompt:**
```text
/price-optimization Critique our Price Optimization proposal using customer value, willingness to pay, margin and experiment design.
```

#### `pricing-psychology-pricing-strategy` — Pricing Psychology Pricing Strategy

**Purpose:** Use for pricing psychology pricing strategy tasks: you design price architectures that leverage cognitive biases eth.

**What you can do:**
- Map buyer willingness to pay and value metrics. Then model margin, elasticity scenarios, guardrails and segmentation. Apply these to **Pricing Psychology**.
- Pricing options with assumptions and trade-offs; Financial sensitivity table and experiment brief.

**Codex prompt:**
```text
$pricing-psychology-pricing-strategy Compare Pricing Psychology options for a subscription business with 60% gross margin and growing churn. Include risks and scenarios.
```

**Claude Code prompt:**
```text
/pricing-psychology-pricing-strategy Critique our Pricing Psychology proposal using customer value, willingness to pay, margin and experiment design.
```

#### `subscription-pricing` — Subscription Pricing

**Purpose:** Use for subscription pricing tasks: you build tiered pricing structures, usage-b.

**What you can do:**
- Map buyer willingness to pay and value metrics. Then model margin, elasticity scenarios, guardrails and segmentation. Apply these to **Subscription Pricing**.
- Pricing options with assumptions and trade-offs; Financial sensitivity table and experiment brief.

**Codex prompt:**
```text
$subscription-pricing Compare Subscription Pricing options for a subscription business with 60% gross margin and growing churn. Include risks and scenarios.
```

**Claude Code prompt:**
```text
/subscription-pricing Critique our Subscription Pricing proposal using customer value, willingness to pay, margin and experiment design.
```

#### `value-based-pricing` — Value Based Pricing

**Purpose:** Use for value based pricing tasks: you replace cost-plus guesswork with rigorous value qu.

**What you can do:**
- Map buyer willingness to pay and value metrics. Then model margin, elasticity scenarios, guardrails and segmentation. Apply these to **Value-Based Pricing**.
- Pricing options with assumptions and trade-offs; Financial sensitivity table and experiment brief.

**Codex prompt:**
```text
$value-based-pricing Compare Value-Based Pricing options for a subscription business with 60% gross margin and growing churn. Include risks and scenarios.
```

**Claude Code prompt:**
```text
/value-based-pricing Critique our Value-Based Pricing proposal using customer value, willingness to pay, margin and experiment design.
```

</details>

<details>
<summary><strong>Product Management (10 Skills)</strong> — Customer research, prioritization, roadmaps and launches.</summary>

### Product Management

#### `competitive-analysis` — Competitive Analysis

**Purpose:** Use for competitive analysis tasks: systematically analyze competitors to inform product strategy, positioning, and differentiation.

**What you can do:**
- Frame the opportunity in terms of user outcomes. Then compare alternatives with explicit prioritization criteria. Apply these to **Competitive Analysis**.
- Product decision memo and prioritized backlog; Discovery experiment or release launch plan.

**Codex prompt:**
```text
$competitive-analysis Apply Competitive Analysis to a B2B product with a small team and conflicting feature requests. Produce a prioritized plan.
```

**Claude Code prompt:**
```text
/competitive-analysis Review our Competitive Analysis decisions and define an outcome metric, evidence gaps and a low-cost validation experiment.
```

#### `feature-prioritization` — Feature Prioritization

**Purpose:** Use for feature prioritization tasks: systematically evaluate and rank product features and initiatives to maximize impact. Trigger keywords: prioritization, RICE, ICE, MoSCoW, feature scoring, impact vs effort, priority framework, backlog ranking.

**What you can do:**
- Frame the opportunity in terms of user outcomes. Then compare alternatives with explicit prioritization criteria. Apply these to **Feature Prioritization**.
- Product decision memo and prioritized backlog; Discovery experiment or release launch plan.

**Codex prompt:**
```text
$feature-prioritization Apply Feature Prioritization to a B2B product with a small team and conflicting feature requests. Produce a prioritized plan.
```

**Claude Code prompt:**
```text
/feature-prioritization Review our Feature Prioritization decisions and define an outcome metric, evidence gaps and a low-cost validation experiment.
```

#### `pricing-strategy-product-management` — Pricing Strategy Product Management

**Purpose:** Design pricing models that capture value, drive adoption, and support business goals. Trigger keywords: pricing, pricing strategy, monetization, freemium, subscription, tiered pricing, willingness to pay, value-based pricing.

**What you can do:**
- Frame the opportunity in terms of user outcomes. Then compare alternatives with explicit prioritization criteria. Apply these to **Pricing Strategy**.
- Product decision memo and prioritized backlog; Discovery experiment or release launch plan.

**Codex prompt:**
```text
$pricing-strategy-product-management Apply Pricing Strategy to a B2B product with a small team and conflicting feature requests. Produce a prioritized plan.
```

**Claude Code prompt:**
```text
/pricing-strategy-product-management Review our Pricing Strategy decisions and define an outcome metric, evidence gaps and a low-cost validation experiment.
```

#### `product-discovery` — Product Discovery

**Purpose:** Use for product discovery tasks: rapidly validate product ideas and reduce risk before committing engineering resources. Trigger keywords: product discovery, validation, prototyping, hypothesis testing, lean product, experiment, MVP, assumption testing.

**What you can do:**
- Frame the opportunity in terms of user outcomes. Then compare alternatives with explicit prioritization criteria. Apply these to **Product Discovery**.
- Product decision memo and prioritized backlog; Discovery experiment or release launch plan.

**Codex prompt:**
```text
$product-discovery Apply Product Discovery to a B2B product with a small team and conflicting feature requests. Produce a prioritized plan.
```

**Claude Code prompt:**
```text
/product-discovery Review our Product Discovery decisions and define an outcome metric, evidence gaps and a low-cost validation experiment.
```

#### `product-launch` — Product Launch

**Purpose:** Plan and execute product launches that drive awareness, adoption, and business results. Trigger keywords: product launch, go-to-market, GTM, launch plan, release management, beta, general availability.

**What you can do:**
- Frame the opportunity in terms of user outcomes. Then compare alternatives with explicit prioritization criteria. Apply these to **Product Launch**.
- Product decision memo and prioritized backlog; Discovery experiment or release launch plan.

**Codex prompt:**
```text
$product-launch Apply Product Launch to a B2B product with a small team and conflicting feature requests. Produce a prioritized plan.
```

**Claude Code prompt:**
```text
/product-launch Review our Product Launch decisions and define an outcome metric, evidence gaps and a low-cost validation experiment.
```

#### `product-metrics` — Product Metrics

**Purpose:** Use for product metrics tasks: define and track metrics that measure product health, user engagement, and business impact. Trigger keywords: product metrics, KPIs, analytics, engagement metrics, retention, conversion, funnel, north star metric.

**What you can do:**
- Frame the opportunity in terms of user outcomes. Then compare alternatives with explicit prioritization criteria. Apply these to **Product Metrics**.
- Product decision memo and prioritized backlog; Discovery experiment or release launch plan.

**Codex prompt:**
```text
$product-metrics Apply Product Metrics to a B2B product with a small team and conflicting feature requests. Produce a prioritized plan.
```

**Claude Code prompt:**
```text
/product-metrics Review our Product Metrics decisions and define an outcome metric, evidence gaps and a low-cost validation experiment.
```

#### `product-strategy` — Product Strategy

**Purpose:** Use for product vision, differentiation, customer jobs-to-be-done, strategic choices, market opportunities and product direction.

**What you can do:**
- Frame the opportunity in terms of user outcomes. Then compare alternatives with explicit prioritization criteria. Apply these to **Product Strategy**.
- Product decision memo and prioritized backlog; Discovery experiment or release launch plan.

**Codex prompt:**
```text
$product-strategy Apply Product Strategy to a B2B product with a small team and conflicting feature requests. Produce a prioritized plan.
```

**Claude Code prompt:**
```text
/product-strategy Review our Product Strategy decisions and define an outcome metric, evidence gaps and a low-cost validation experiment.
```

#### `roadmap-planning` — Roadmap Planning

**Purpose:** Create and maintain product roadmaps that align teams around priorities and communicate plans to stakeholders. Trigger keywords: roadmap, product planning, quarterly planning, OKRs, release planning, product timeline.

**What you can do:**
- Frame the opportunity in terms of user outcomes. Then compare alternatives with explicit prioritization criteria. Apply these to **Roadmap Planning**.
- Product decision memo and prioritized backlog; Discovery experiment or release launch plan.

**Codex prompt:**
```text
$roadmap-planning Apply Roadmap Planning to a B2B product with a small team and conflicting feature requests. Produce a prioritized plan.
```

**Claude Code prompt:**
```text
/roadmap-planning Review our Roadmap Planning decisions and define an outcome metric, evidence gaps and a low-cost validation experiment.
```

#### `stakeholder-management-product-management` — Stakeholder Management Product Management

**Purpose:** Use for product-management stakeholder mapping, executive alignment, cross-functional decisions, buy-in and trade-off communication.

**What you can do:**
- Assess stakeholder management product management using a practical workflow.
- Prepare an actionable plan, key assumptions and validation steps.

**Codex prompt:**
```text
$stakeholder-management-product-management Analyze the situation, outline a practical approach and validate key assumptions.
```

**Claude Code prompt:**
```text
/stakeholder-management-product-management Review our current approach, identify risks and recommend next steps.
```

#### `user-research` — User Research

**Purpose:** Use for user research tasks: conduct qualitative and quantitative research to understand user needs, behaviors, and pain points. Trigger keywords: user research, user interviews, usability testing, surveys, customer discovery, persona, user insights.

**What you can do:**
- Frame the opportunity in terms of user outcomes. Then compare alternatives with explicit prioritization criteria. Apply these to **User Research**.
- Product decision memo and prioritized backlog; Discovery experiment or release launch plan.

**Codex prompt:**
```text
$user-research Apply User Research to a B2B product with a small team and conflicting feature requests. Produce a prioritized plan.
```

**Claude Code prompt:**
```text
/user-research Review our User Research decisions and define an outcome metric, evidence gaps and a low-cost validation experiment.
```

</details>

<details>
<summary><strong>Project & Productivity Management (16 Skills)</strong> — Plans, estimation, delivery flow, team collaboration and personal productivity.</summary>

### Project & Productivity Management

#### `adhd-planning` — Adhd Planning

**Purpose:** Use for ADHD-friendly task planning, prioritization, realistic routines and accessible productivity strategies; avoid making diagnoses.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Adhd Planning**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$adhd-planning Use Adhd Planning to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/adhd-planning Review our Adhd Planning workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `agile-scrum` — Agile Scrum

**Purpose:** Use this skill when asked about Scrum methodology, agile frameworks, sprint ceremonies, or team process design.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Agile Scrum**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$agile-scrum Use Agile Scrum to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/agile-scrum Review our Agile Scrum workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `calendar-optimization` — Calendar Optimization

**Purpose:** Design and manage calendars for maximum productivity, work-life balance, and schedule resilience.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Calendar Optimization**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$calendar-optimization Use Calendar Optimization to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/calendar-optimization Review our Calendar Optimization workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `execution-discipline` — Execution Discipline

**Purpose:** Use for execution discipline tasks: structured execution framework balancing initiative with safety. Covers the observe-parse-plan-commit-act-verify-update-stop loop, trust calibration, approval gates, error resilience, and preference learning.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Execution Discipline**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$execution-discipline Use Execution Discipline to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/execution-discipline Review our Execution Discipline workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `kanban` — Kanban

**Purpose:** Use this skill when asked about Kanban boards, work-in-progress limits, flow optimization, or continuous delivery workflows.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Kanban**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$kanban Use Kanban to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/kanban Review our Kanban workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `morning-routine` — Morning Routine

**Purpose:** Build and optimize a powerful morning routine with habit stacking, timing strategies, and consistency principles that compound over time.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Morning Routine**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$morning-routine Use Morning Routine to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/morning-routine Review our Morning Routine workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `neurodivergent-productivity` — Neurodivergent Productivity

**Purpose:** Use for neurodivergent productivity tasks: adapt productivity systems for ADHD, autism, and other neurodivergent thinking styles with strategies that work with the brain rather than against it.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Neurodivergent Productivity**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$neurodivergent-productivity Use Neurodivergent Productivity to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/neurodivergent-productivity Review our Neurodivergent Productivity workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `project-estimation` — Project Estimation

**Purpose:** Use this skill when asked about software estimation, project sizing, forecasting delivery dates, or dealing with estimation pressure.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Project Estimation**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$project-estimation Use Project Estimation to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/project-estimation Review our Project Estimation workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `project-recovery` — Project Recovery

**Purpose:** Use this skill when asked about rescuing failing projects, triaging troubled deliveries, performing honest assessments, or deciding whether to continue or kill a project.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Project Recovery**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$project-recovery Use Project Recovery to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/project-recovery Review our Project Recovery workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `retrospectives` — Retrospectives

**Purpose:** Use this skill when asked about running retrospectives, retro formats, improving team process, or fostering continuous improvement.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Retrospectives**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$retrospectives Use Retrospectives to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/retrospectives Review our Retrospectives workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `risk-management` — Risk Management

**Purpose:** Use this skill when asked about identifying, assessing, or mitigating project risks. Trigger keywords include risk, risk register, mitigation, contingency plan, probability, impact, risk matrix, risk assessment, risk appetite, and risk monitoring.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Risk Management**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$risk-management Use Risk Management to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/risk-management Review our Risk Management workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `scope-management` — Scope Management

**Purpose:** Use this skill when asked about managing project scope, preventing feature creep, handling change requests, or prioritizing features.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Scope Management**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$scope-management Use Scope Management to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/scope-management Review our Scope Management workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `sprint-planning` — Sprint Planning

**Purpose:** Use this skill when asked about sprint planning sessions, capacity planning, story splitting, or estimation techniques.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Sprint Planning**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$sprint-planning Use Sprint Planning to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/sprint-planning Review our Sprint Planning workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `stakeholder-management-project-management` — Stakeholder Management Project Management

**Purpose:** Use for project-delivery stakeholder engagement, communication plans, escalation routes and expectation management.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Stakeholder Management**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$stakeholder-management-project-management Use Stakeholder Management to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/stakeholder-management-project-management Review our Stakeholder Management workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `team-velocity` — Team Velocity

**Purpose:** Use this skill when asked about measuring team velocity, burndown charts, burnup charts, flow metrics, capacity planning, or sustainable pace.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Team Velocity**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$team-velocity Use Team Velocity to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/team-velocity Review our Team Velocity workflow and identify bottlenecks, early-warning signals and next actions.
```

#### `time-management` — Time Management

**Purpose:** Use for time management tasks: master time management techniques including time blocking, prioritization frameworks, energy management, and deep work scheduling.

**What you can do:**
- Decompose the objective into outcomes, deliverables and owners. Then sequence work with dependency, uncertainty and capacity constraints. Apply these to **Time Management**.
- Prioritized action plan and milestone tracking; Risk register and communication cadence.

**Codex prompt:**
```text
$time-management Use Time Management to improve delivery of a six-week cross-functional project with uncertain scope. Provide an actionable plan.
```

**Claude Code prompt:**
```text
/time-management Review our Time Management workflow and identify bottlenecks, early-warning signals and next actions.
```

</details>

<details>
<summary><strong>Sales & Revenue Operations (10 Skills)</strong> — Prospecting, account management, enterprise sales and pipeline processes.</summary>

### Sales & Revenue Operations

#### `account-management` — Account Management

**Purpose:** Use for account management tasks: trigger this skill when the user needs help with strategic account management, customer retention, or account growth.

**What you can do:**
- Identify buyer goals and evidence of fit. Then build a clear discovery, qualification and follow-up plan. Apply these to **Account Management**.
- Sales playbook and discovery questions; Pipeline KPIs and account action plan.

**Codex prompt:**
```text
$account-management Design a Account Management playbook for B2B SaaS selling to mid-market accounts. Include discovery questions and KPIs.
```

**Claude Code prompt:**
```text
/account-management Audit our Account Management approach and suggest an ethical, measurable experiment for the sales team.
```

#### `crm-strategy` — Crm Strategy

**Purpose:** Use for crm strategy tasks: trigger this skill when the user needs help with CRM strategy, implementation, or optimization.

**What you can do:**
- Identify buyer goals and evidence of fit. Then build a clear discovery, qualification and follow-up plan. Apply these to **Crm Strategy**.
- Sales playbook and discovery questions; Pipeline KPIs and account action plan.

**Codex prompt:**
```text
$crm-strategy Design a Crm Strategy playbook for B2B SaaS selling to mid-market accounts. Include discovery questions and KPIs.
```

**Claude Code prompt:**
```text
/crm-strategy Audit our Crm Strategy approach and suggest an ethical, measurable experiment for the sales team.
```

#### `enterprise-sales` — Enterprise Sales

**Purpose:** Use for enterprise sales tasks: trigger this skill when the user needs help with complex B2B enterprise sales cycles.

**What you can do:**
- Identify buyer goals and evidence of fit. Then build a clear discovery, qualification and follow-up plan. Apply these to **Enterprise Sales**.
- Sales playbook and discovery questions; Pipeline KPIs and account action plan.

**Codex prompt:**
```text
$enterprise-sales Design a Enterprise Sales playbook for B2B SaaS selling to mid-market accounts. Include discovery questions and KPIs.
```

**Claude Code prompt:**
```text
/enterprise-sales Audit our Enterprise Sales approach and suggest an ethical, measurable experiment for the sales team.
```

#### `negotiation` — Negotiation

**Purpose:** Use for negotiation tasks: trigger this skill when the user needs help with sales negotiation, pricing defense, or contract terms.

**What you can do:**
- Identify buyer goals and evidence of fit. Then build a clear discovery, qualification and follow-up plan. Apply these to **Negotiation**.
- Sales playbook and discovery questions; Pipeline KPIs and account action plan.

**Codex prompt:**
```text
$negotiation Design a Negotiation playbook for B2B SaaS selling to mid-market accounts. Include discovery questions and KPIs.
```

**Claude Code prompt:**
```text
/negotiation Audit our Negotiation approach and suggest an ethical, measurable experiment for the sales team.
```

#### `proposal-writing` — Proposal Writing

**Purpose:** Use for proposal writing tasks: trigger this skill when the user needs help writing sales proposals, RFP responses, statements of work, or pricing presentations.

**What you can do:**
- Identify buyer goals and evidence of fit. Then build a clear discovery, qualification and follow-up plan. Apply these to **Proposal Writing**.
- Sales playbook and discovery questions; Pipeline KPIs and account action plan.

**Codex prompt:**
```text
$proposal-writing Design a Proposal Writing playbook for B2B SaaS selling to mid-market accounts. Include discovery questions and KPIs.
```

**Claude Code prompt:**
```text
/proposal-writing Audit our Proposal Writing approach and suggest an ethical, measurable experiment for the sales team.
```

#### `prospecting` — Prospecting

**Purpose:** Use for prospecting tasks: trigger this skill when the user needs help with outbound prospecting, lead generation, or building pipeline through proactive outreach.

**What you can do:**
- Identify buyer goals and evidence of fit. Then build a clear discovery, qualification and follow-up plan. Apply these to **Prospecting**.
- Sales playbook and discovery questions; Pipeline KPIs and account action plan.

**Codex prompt:**
```text
$prospecting Design a Prospecting playbook for B2B SaaS selling to mid-market accounts. Include discovery questions and KPIs.
```

**Claude Code prompt:**
```text
/prospecting Audit our Prospecting approach and suggest an ethical, measurable experiment for the sales team.
```

#### `sales-enablement` — Sales Enablement

**Purpose:** Use for sales enablement tasks: trigger this skill when the user needs help with sales enablement, training, or competitive intelligence.

**What you can do:**
- Identify buyer goals and evidence of fit. Then build a clear discovery, qualification and follow-up plan. Apply these to **Sales Enablement**.
- Sales playbook and discovery questions; Pipeline KPIs and account action plan.

**Codex prompt:**
```text
$sales-enablement Design a Sales Enablement playbook for B2B SaaS selling to mid-market accounts. Include discovery questions and KPIs.
```

**Claude Code prompt:**
```text
/sales-enablement Audit our Sales Enablement approach and suggest an ethical, measurable experiment for the sales team.
```

#### `sales-leadership` — Sales Leadership

**Purpose:** Use for sales leadership tasks: trigger this skill when the user needs help with sales team leadership and management.

**What you can do:**
- Identify buyer goals and evidence of fit. Then build a clear discovery, qualification and follow-up plan. Apply these to **Sales Leadership**.
- Sales playbook and discovery questions; Pipeline KPIs and account action plan.

**Codex prompt:**
```text
$sales-leadership Design a Sales Leadership playbook for B2B SaaS selling to mid-market accounts. Include discovery questions and KPIs.
```

**Claude Code prompt:**
```text
/sales-leadership Audit our Sales Leadership approach and suggest an ethical, measurable experiment for the sales team.
```

#### `sales-ops` — Sales Ops

**Purpose:** Use for sales ops tasks: trigger this skill when the user needs help with sales operations, CRM management, pipeline analytics, or sales infrastructure.

**What you can do:**
- Identify buyer goals and evidence of fit. Then build a clear discovery, qualification and follow-up plan. Apply these to **Sales Ops**.
- Sales playbook and discovery questions; Pipeline KPIs and account action plan.

**Codex prompt:**
```text
$sales-ops Design a Sales Ops playbook for B2B SaaS selling to mid-market accounts. Include discovery questions and KPIs.
```

**Claude Code prompt:**
```text
/sales-ops Audit our Sales Ops approach and suggest an ethical, measurable experiment for the sales team.
```

#### `solution-selling` — Solution Selling

**Purpose:** Use for solution selling tasks: trigger this skill when the user needs help with consultative or solution selling approaches. Covers discovery methodology, needs analysis, value selling, ROI quantification, demo customization, and proof of concept design.

**What you can do:**
- Identify buyer goals and evidence of fit. Then build a clear discovery, qualification and follow-up plan. Apply these to **Solution Selling**.
- Sales playbook and discovery questions; Pipeline KPIs and account action plan.

**Codex prompt:**
```text
$solution-selling Design a Solution Selling playbook for B2B SaaS selling to mid-market accounts. Include discovery questions and KPIs.
```

**Claude Code prompt:**
```text
/solution-selling Audit our Solution Selling approach and suggest an ethical, measurable experiment for the sales team.
```

</details>

<details>
<summary><strong>Startups & Founders (13 Skills)</strong> — Early-stage validation, hiring, fundraising and company operations.</summary>

### Startups & Founders

#### `customer-onboarding-startup` — Customer Onboarding Startup

**Purpose:** Design and execute customer onboarding flows that drive activation and retention. Covers activation metrics, journey mapping, friction reduction, email sequences, and measuring onboarding success.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Customer Onboarding**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$customer-onboarding-startup Apply Customer Onboarding to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/customer-onboarding-startup Challenge our Customer Onboarding assumptions and design a cheap test with clear pass/fail criteria.
```

#### `founder-coach` — Founder Coach

**Purpose:** Use for founder coach tasks: startup mindset coach that helps founders upgrade their thinking patterns, detect anti-patterns, apply mental models like PMF levels and the 4Ps framework, and build accountability through weekly challenges.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Founder Coach**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$founder-coach Apply Founder Coach to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/founder-coach Challenge our Founder Coach assumptions and design a cheap test with clear pass/fail criteria.
```

#### `founder-sales` — Founder Sales

**Purpose:** Use for founder sales tasks: close the first customers as a founder — outbound prospecting, discovery calls, demo strategy, objection handling, and closing without a sales team.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Founder Sales**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$founder-sales Apply Founder Sales to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/founder-sales Challenge our Founder Sales assumptions and design a cheap test with clear pass/fail criteria.
```

#### `growth-hacking` — Growth Hacking

**Purpose:** Use for growth hacking tasks: drive early-stage growth with creative, resource-efficient tactics — viral loops, referral mechanics, content-led growth, community building, and scrappy acquisition channels.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Growth Hacking**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$growth-hacking Apply Growth Hacking to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/growth-hacking Challenge our Growth Hacking assumptions and design a cheap test with clear pass/fail criteria.
```

#### `hiring` — Hiring

**Purpose:** Build the founding team — early-stage hiring, compensation design, culture building, and organizational decisions for startups from 1 to 50 people.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Hiring**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$hiring Apply Hiring to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/hiring Challenge our Hiring assumptions and design a cheap test with clear pass/fail criteria.
```

#### `lean-operations` — Lean Operations

**Purpose:** Use for lean operations tasks: run lean startup operations — burn rate management, resource allocation, tool selection, process design, and doing more with less.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Lean Operations**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$lean-operations Apply Lean Operations to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/lean-operations Challenge our Lean Operations assumptions and design a cheap test with clear pass/fail criteria.
```

#### `legal-incorporation` — Legal Incorporation

**Purpose:** Use for legal incorporation tasks: navigate startup legal fundamentals — incorporation, equity structure, co-founder agreements, IP protection, fundraising documents, and compliance.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Legal Incorporation**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$legal-incorporation Apply Legal Incorporation to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/legal-incorporation Challenge our Legal Incorporation assumptions and design a cheap test with clear pass/fail criteria.
```

#### `mvp-development` — Mvp Development

**Purpose:** Build minimum viable products fast — ruthless scoping, rapid prototyping, and shipping the smallest thing that tests the riskiest assumption.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Mvp Development**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$mvp-development Apply Mvp Development to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/mvp-development Challenge our Mvp Development assumptions and design a cheap test with clear pass/fail criteria.
```

#### `open-source-strategy` — Open Source Strategy

**Purpose:** Build and manage successful open source projects or contribute effectively to existing ones.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Open Source Strategy**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$open-source-strategy Apply Open Source Strategy to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/open-source-strategy Challenge our Open Source Strategy assumptions and design a cheap test with clear pass/fail criteria.
```

#### `pitch-deck` — Pitch Deck

**Purpose:** Use for pitch deck tasks: craft compelling pitch decks and fundraising materials that get meetings, close rounds, and tell a startup's story with clarity and conviction.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Pitch Deck**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$pitch-deck Apply Pitch Deck to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/pitch-deck Challenge our Pitch Deck assumptions and design a cheap test with clear pass/fail criteria.
```

#### `product-market-fit` — Product Market Fit

**Purpose:** Use for product market fit tasks: find and validate product-market fit — customer discovery, hypothesis testing, iteration strategy, and the signals that tell you when you've found it.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Product Market Fit**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$product-market-fit Apply Product Market Fit to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/product-market-fit Challenge our Product Market Fit assumptions and design a cheap test with clear pass/fail criteria.
```

#### `product-strategy-startup` — Product Strategy Startup

**Purpose:** Use for product strategy startup tasks: define and execute product strategy for startups — roadmap prioritization, feature scoping, saying no, competitive feature decisions, and building products that win in the market.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Product Strategy**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$product-strategy-startup Apply Product Strategy to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/product-strategy-startup Challenge our Product Strategy assumptions and design a cheap test with clear pass/fail criteria.
```

#### `startup-metrics` — Startup Metrics

**Purpose:** Use for startup metrics tasks: track the metrics that matter at each startup stage — from pre-PMF signals through growth-stage unit economics and investor-ready dashboards.

**What you can do:**
- Map the riskiest hypothesis and customer evidence. Then choose small, reversible experiments with cost and decision thresholds. Apply these to **Startup Metrics**.
- Lean validation roadmap and founders action plan; Investor/customer narrative with evidence gaps.

**Codex prompt:**
```text
$startup-metrics Apply Startup Metrics to a bootstrapped startup before product-market fit. Propose a lean 30-day action plan.
```

**Claude Code prompt:**
```text
/startup-metrics Challenge our Startup Metrics assumptions and design a cheap test with clear pass/fail criteria.
```

</details>

## Source note

<sub><i>Unprocessed source descriptions were obtained from [SkillDB](https://skilldb.dev/). The Skills in this repository have been adapted and reviewed; they are not necessarily verbatim copies of upstream materials.</i></sub>

## Verification and limits

- Skill names, YAML metadata, actual presence, category assignments and the index are validated at build time.
- Vendor APIs and third-party integrations may change. Verify versions, official documentation, credentials and product permissions before implementation.
- The initializer creates working awareness in the **current conversation**, not permanently trained knowledge or an automatically maintained memory.
