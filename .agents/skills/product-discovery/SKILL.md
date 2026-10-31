---
name: product-discovery
description: 'Use for product discovery tasks: rapidly validate product ideas and reduce risk before committing
  engineering resources. Trigger keywords: product discovery, validation, prototyping, hypothesis testing, lean
  product, experiment, MVP, assumption testing.'
---

# Product Discovery

## Core Philosophy
Product discovery is the process of reducing four key risks before building:
value risk (will customers want it?), usability risk (can they use it?), feasibility
risk (can we build it?), and business viability risk (does it work for the business?).
Discovery separates deciding what to build from building it, ensuring that
engineering effort is invested in validated ideas rather than untested assumptions.
The cheapest way to learn is before writing code.

## Key Techniques
- **Assumption Mapping**: List every assumption underlying a product idea, rank
  them by risk and importance, and design experiments to test the most critical
  ones first.
- **Rapid Prototyping**: Build lightweight prototypes (paper, Figma, coded
  prototypes) that test specific hypotheses without full engineering investment.
- **Fake Door Tests**: Place a feature entry point in the product that measures
  interest (clicks) before building the feature behind it.
- **Concierge MVP**: Deliver the proposed value manually to a small number of
  customers to validate demand before automating with technology.
- **Customer Problem Interviews**: Structured conversations focused on understanding
  the customer's problem and current workarounds, conducted before proposing
  any solution.
- **Sprint-Based Discovery**: Time-boxed discovery cycles (1-2 weeks) that produce
  evidence for or against proceeding with an initiative.

## Best Practices
- Frame discovery around risks, not features. The question is not "should we build
  X?" but "what do we need to learn before deciding?"
- Set clear success criteria for each experiment before running it. Decide in
  advance what evidence would change your mind.
- Involve engineering in discovery from the start. Feasibility insight shapes
  which solutions are worth testing.
- Run multiple small experiments rather than one large one. Each experiment
  should answer a single focused question.
- Accept that most ideas will not survive discovery. A high kill rate is a sign
  of effective discovery, not failure.
- Time-box discovery to prevent analysis paralysis. Perfect evidence does not
  exist; sufficient evidence does.

## Common Patterns
- **Dual-Track Agile**: Run discovery work in parallel with delivery work so
  there is always a pipeline of validated ideas ready for engineering.
- **Opportunity Solution Tree**: Map desired outcomes to opportunities (user needs)
  to solutions to experiments, creating a visual logic chain for product decisions.
- **Design Sprint**: A structured five-day process for rapidly prototyping and
  testing ideas with users, popularized by Google Ventures.
- **Wizard of Oz**: Present what appears to be a working product to users while
  actually performing the back-end work manually, testing the interface and
  value proposition before building the technology.

## Anti-Patterns
- Skipping discovery and going straight to building because the team is "confident"
  in the idea. Confidence without evidence is the most common source of waste.
- Discovery theater — going through the motions without genuine openness to
  learning that the idea is wrong.
- Over-investing in discovery for low-risk ideas. Not every feature needs
  extensive validation; reserve deep discovery for high-stakes bets.
- Testing solutions without validating the problem first. A beautiful solution
  to a problem nobody has is still a waste.
- Treating discovery as a one-time phase rather than a continuous practice
  integrated into the team's weekly rhythm.
- Ignoring qualitative signals because they are not statistically significant.
  Five users struggling with the same task is a strong signal.

## Technical audit acceptance checks (2026-10-31)

- **Skill-specific objective:** Product discovery tasks: rapidly validate product ideas and reduce risk before committing engineering resources. Trigger keywords: product discovery, validation, prototyping, hypothesis testing, lean... (verify inputs, the user's intended output, and reproducible acceptance evidence).
- **Domain correctness:** Differentiate discovery evidence from prioritization preferences; define observable outcome and cohort.
- **Failure and assurance:** Test assumptions with representative users, guard against selection bias and track post-launch regressions.
- **Claim validity:** Do not treat anecdotal experience, invented credentials or generic best practices as empirical validation for this specific case.
