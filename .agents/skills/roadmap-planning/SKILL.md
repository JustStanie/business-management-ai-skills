---
name: roadmap-planning
description: 'Create and maintain product roadmaps that align teams around priorities and communicate plans to stakeholders.
  Trigger keywords: roadmap, product planning, quarterly planning, OKRs, release planning, product timeline.'
---

## Purpose and scope

# Roadmap Planning

## Core Philosophy
A product roadmap is a strategic communication tool that shows how planned work
connects to product strategy and business goals. It is not a promise or a project
plan — it is a living document that reflects current thinking about priorities and
direction. The best roadmaps focus on outcomes (problems to solve) rather than
outputs (features to build), giving teams the flexibility to find the best solutions.

## Key Techniques
- **Outcome-Based Roadmapping**: Frame roadmap items as problems to solve or metrics
  to move rather than features to build. This preserves solution flexibility.
- **Now/Next/Later Framework**: Organize roadmap items by confidence level. "Now" is
  committed work in progress, "Next" is planned work with high confidence, "Later"
  is directional themes with low specificity.
- **Theme-Based Roadmapping**: Group initiatives under strategic themes that connect
  to business objectives, making the rationale for each investment visible.
- **OKR Alignment**: Link roadmap items to quarterly Objectives and Key Results to
  ensure every planned initiative has measurable success criteria.
- **Dependency Mapping**: Identify cross-team and technical dependencies that affect
  sequencing and communicate them explicitly.
- **Capacity Planning**: Match roadmap ambitions to available engineering, design,
  and research capacity to create achievable plans.

## Best Practices
- Update the roadmap at least quarterly. A roadmap that is not current is worse
  than no roadmap because it communicates false information.
- Show the roadmap at different resolutions for different audiences. Executives
  need themes; engineers need specifics.
- Include what you chose not to do and why. This prevents repeated debates about
  already-considered ideas.
- Leave buffer for unplanned work. Discovery, tech debt, and incidents always
  consume some portion of capacity.
- Make tradeoffs visible. If adding a new initiative means delaying another,
  show both sides of the decision.
- Version roadmaps and keep a history so stakeholders can see how plans evolved
  and why.

## Common Patterns
- **Dual-Track Roadmap**: Separate discovery work (research and prototyping) from
  delivery work (engineering and shipping) to ensure a healthy pipeline of
  validated ideas.
- **Portfolio Roadmap**: A single view showing roadmaps across multiple products
  or teams, highlighting dependencies and strategic alignment.
- **Rolling Quarterly Roadmap**: Plan in detail for the current quarter, directionally
  for the next quarter, and thematically for two quarters out.
- **Customer-Facing Roadmap**: A simplified, commitment-free version shared with
  customers showing directional themes without specific dates.

## Anti-Patterns
- Date-driven roadmaps where arbitrary deadlines drive scope decisions. Dates
  should be informed by estimates, not the other way around.
- Feature factories that measure success by output (features shipped) rather
  than outcome (impact achieved).
- Roadmaps that are created once and never updated, becoming fiction within weeks.
- Stakeholder-driven roadmaps where the loudest voice determines priorities
  rather than evidence and strategy.
- Overcommitting capacity by planning for 100% utilization without buffer for
  support, bugs, and discovery.
- Hiding uncertainty behind false precision. A roadmap with exact dates for work
  that has not been scoped is dishonest.

## Technical audit acceptance checks (2026-10-31)

- **Skill-specific objective:** Create and maintain product roadmaps that align teams around priorities and communicate plans to stakeholders. Trigger keywords: roadmap, product planning, quarterly planning, OKRs, release planning,... (verify inputs, the user's intended output, and reproducible acceptance evidence).
- **Domain correctness:** Differentiate discovery evidence from prioritization preferences; define observable outcome and cohort.
- **Failure and assurance:** Test assumptions with representative users, guard against selection bias and track post-launch regressions.
- **Numerical claims:** Treat thresholds, industry averages and percentages as examples unless tied to a verified source, sample, geography, customer segment and date. Recalculate with explicit numerator, denominator and units.
