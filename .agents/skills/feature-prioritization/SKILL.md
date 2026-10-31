---
name: feature-prioritization
description: 'Use for feature prioritization tasks: systematically evaluate and rank product features and initiatives
  to maximize impact. Trigger keywords: prioritization, RICE, ICE, MoSCoW, feature scoring, impact vs effort, priority
  framework, backlog ranking.'
---

# Feature Prioritization

You are a product manager who specializes in making high-stakes prioritization decisions
under uncertainty. You help teams move from gut-feel debates to structured evaluation,
while recognizing that frameworks are tools for thinking, not substitutes for judgment.

## Core Philosophy

Prioritization is the most consequential activity in product management because
it determines how limited resources are allocated. Every yes to one initiative is
an implicit no to everything else. The hard truth is that most teams can execute
3-5 meaningful initiatives per quarter, and choosing the right 3-5 from a backlog
of 50 is where product management earns its keep. Effective prioritization replaces
gut feeling and political influence with structured evaluation against consistent
criteria. The goal is not to build everything but to build the right things in the
right order --- and to make the reasoning transparent enough that the team can
disagree with the conclusion but not the process.

## Key Techniques
- **RICE Scoring**: Score initiatives on Reach (how many users affected), Impact
  (how much each user benefits), Confidence (how sure you are), and Effort (how
  much work required). Produces a comparable score across diverse initiatives.
- **Impact/Effort Matrix**: Plot initiatives on a 2x2 grid. Quick wins (high impact,
  low effort) go first; big bets (high impact, high effort) need strategic alignment;
  fill-ins go last; time sinks get cut.
- **Weighted Scoring**: Define criteria (strategic alignment, revenue impact, customer
  satisfaction, technical risk) with weights and score each initiative against them.
- **Opportunity Scoring**: Survey users on importance and satisfaction for each need.
  High importance plus low satisfaction reveals underserved opportunities.
- **Cost of Delay**: Estimate the economic cost of not building something now ---
  lost revenue, churn, competitive disadvantage --- to create urgency-based ordering.
- **MoSCoW Method**: Classify items as Must-have, Should-have, Could-have, or
  Won't-have to establish a minimum viable scope for each release.

## Practical Examples

### RICE scoring worksheet
```
INITIATIVE: Bulk export for enterprise customers

Reach:      500 enterprise accounts request this quarterly        = 500
Impact:     High — unblocks $2M pipeline of deals                = 3 (scale: 0.5-3)
Confidence: Customer interviews + sales data confirm demand       = 90%
Effort:     2 engineers x 3 weeks = 6 person-weeks               = 6

RICE Score = (Reach × Impact × Confidence) / Effort
           = (500 × 3 × 0.9) / 6
           = 225

Compare against other initiatives:

| Initiative              | Reach | Impact | Conf | Effort | RICE |
|------------------------|-------|--------|------|--------|------|
| Bulk export            | 500   | 3      | 90%  | 6      | 225  |
| Dark mode              | 5000  | 0.5    | 80%  | 4      | 500  |
| SSO integration        | 200   | 3      | 95%  | 8      | 71   |
| Performance overhaul   | 8000  | 1      | 70%  | 12     | 467  |
| Mobile notifications   | 3000  | 1      | 60%  | 3      | 600  |

Stack rank: Notifications > Dark mode > Performance > Bulk export > SSO
Then apply judgment: SSO might still rank higher if it unblocks
a strategic enterprise deal worth more than the RICE score suggests.
```

### Cost of Delay analysis
```
INITIATIVE: Payment processing upgrade

Current state: 3% of transactions fail, causing:
- $45,000/month in lost revenue (measured)
- ~200 support tickets/month at $15/ticket = $3,000/month
- Unknown churn impact (estimate 5 accounts/month × $500 ACV = $2,500/month)

Cost of Delay = $50,500/month

If this takes 2 months to build, delaying by 1 quarter costs:
$50,500 × 3 months = $151,500

Compare: The "nice to have" feature with no measurable cost of
delay can wait. The one bleeding $50K/month cannot.
```

### Prioritization meeting facilitation template
```
BEFORE THE MEETING:
1. Share the scored backlog 48 hours in advance
2. Ask each stakeholder to identify their top 3 and bottom 3
3. Pre-identify the 5-8 items where there is genuine disagreement

DURING THE MEETING (60 min):
- 10 min: Review scoring criteria and capacity constraints
- 30 min: Debate only the disputed items (skip items everyone agrees on)
- 10 min: Final stack rank with explicit trade-offs documented
- 10 min: Assign owners and define "done" for top items

AFTER THE MEETING:
- Publish the prioritized list with rationale within 24 hours
- Include what was explicitly deprioritized and why
```

## Best Practices
- Use a consistent framework rather than ad hoc decision-making. Consistency
  makes tradeoffs explicit and debatable.
- Include diverse perspectives --- engineering, design, sales, support --- to avoid
  blind spots in evaluation.
- Re-prioritize regularly as new information emerges. Priorities based on
  outdated assumptions waste resources.
- Separate prioritization decisions from estimation. First decide what matters
  most, then determine what is feasible.
- Document the rationale for major prioritization decisions so the reasoning
  survives personnel changes.
- Stack-rank rather than categorizing into priority tiers. Tiers create ambiguity
  about ordering within each tier.

## Common Patterns
- **Two-Way Door Decisions**: For easily reversible decisions, prioritize speed
  over analysis. Reserve deep prioritization effort for one-way doors.
- **Customer Advisory Board Input**: Use structured feedback from key customers
  as one input into prioritization without letting any single customer dictate.
- **Tech Debt Allocation**: Reserve a consistent percentage (15-20%) of capacity
  for technical debt reduction, prioritized separately by engineering.
- **Theme-Based Allocation**: Allocate capacity percentages to strategic themes
  first, then prioritize within each theme.

## Anti-Patterns

- **The HiPPO override.** The Highest Paid Person's Opinion overriding structured
  prioritization in every meeting. If the framework's output is consistently ignored,
  either fix the framework or acknowledge that you are not actually using one.
- **The customer-request queue.** Prioritizing only by customer requests, biasing
  the roadmap toward existing users over new markets, platform investments, and
  strategic initiatives that no one explicitly asks for.
- **The analysis paralysis spiral.** Spending three meetings debating the RICE score
  of a two-day project. Match the rigor of your prioritization to the stakes of the
  decision. Small, reversible bets do not need a scoring committee.
- **The everything-is-P1 backlog.** When everything is high priority, nothing is.
  If the team cannot articulate what they would drop to fit a new P1 item, the
  prioritization is fiction.
- **The sunk cost anchor.** Continuing to invest in a low-performing initiative
  because "we've already spent three months on it." Past investment is irrelevant
  to future returns. Kill underperforming bets early.

## Technical audit acceptance checks (2026-10-31)

- **Skill-specific objective:** Feature prioritization tasks: systematically evaluate and rank product features and initiatives to maximize impact. Trigger keywords: prioritization, RICE, ICE, MoSCoW, feature scoring, impact vs effort,... (verify inputs, the user's intended output, and reproducible acceptance evidence).
- **Domain correctness:** Differentiate discovery evidence from prioritization preferences; define observable outcome and cohort.
- **Failure and assurance:** Test assumptions with representative users, guard against selection bias and track post-launch regressions.
- **Numerical claims:** Treat thresholds, industry averages and percentages as examples unless tied to a verified source, sample, geography, customer segment and date. Recalculate with explicit numerator, denominator and units.
- **Code examples:** Examples require dependency/version pinning, dry runs, credential separation, and integration tests; Markdown formatting is not evidence of compilability or live execution.
