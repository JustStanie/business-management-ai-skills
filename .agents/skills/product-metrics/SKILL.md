---
name: product-metrics
description: 'Use for product metrics tasks: define and track metrics that measure product health, user engagement,
  and business impact. Trigger keywords: product metrics, KPIs, analytics, engagement metrics, retention, conversion,
  funnel, north star metric.'
---

# Product Metrics

## Core Philosophy
Product metrics transform subjective opinions about product performance into
objective evidence. The right metrics create a shared understanding of whether the
product is succeeding and where to invest next. Metrics should drive decisions,
not just decorate dashboards. Every metric tracked should answer a specific
question that influences a specific action.

## Key Techniques
- **North Star Metric**: Identify the single metric that best captures the core
  value your product delivers to customers. All other metrics should either lead
  to or result from this metric.
- **Pirate Metrics (AARRR)**: Track Acquisition, Activation, Retention, Referral,
  and Revenue as a framework covering the full customer lifecycle.
- **Cohort Analysis**: Group users by signup date or behavior and track their
  metrics over time to distinguish improvements from mix effects.
- **Funnel Analysis**: Map the steps users take toward key outcomes and measure
  conversion rates at each step to identify drop-off points.
- **Leading vs. Lagging Indicators**: Track leading indicators (engagement,
  feature adoption) that predict lagging outcomes (retention, revenue).
- **Segmented Metrics**: Break aggregate metrics down by user segment (plan type,
  geography, use case) to reveal hidden patterns and opportunities.

## Best Practices
- Define success metrics before building features, not after. Metrics that are
  chosen after launch are susceptible to cherry-picking.
- Limit the number of metrics tracked actively. Three to five key metrics per
  team are sufficient; more creates diffusion of focus.
- Pair every efficiency metric with a quality counter-metric. Faster support
  response time means nothing if resolution quality drops.
- Set targets based on benchmarks, historical trends, and strategic goals rather
  than arbitrary round numbers.
- Instrument comprehensively but report selectively. Capture granular event data
  but surface only actionable insights.
- Review metrics weekly with the team and monthly with stakeholders.

## Common Patterns
- **Input Metrics → Output Metrics**: Track controllable inputs (features shipped,
  experiments run) that drive desired outputs (retention, revenue).
- **Health Scorecard**: A single-page view of key product health indicators
  updated weekly with trend arrows and color coding.
- **Experiment-Driven Metrics**: Use A/B tests to establish causal relationships
  between product changes and metric movements.
- **Customer Health Score**: Composite metric combining engagement, satisfaction,
  and usage patterns to predict churn risk.

## Anti-Patterns
- Vanity metrics that look good but do not inform decisions (total signups,
  page views, app downloads without engagement context).
- Measuring everything and acting on nothing. Dashboards without decisions are
  decoration.
- Goodhart's Law — when a metric becomes a target, it ceases to be a good metric.
  People optimize for the measurement rather than the underlying goal.
- Comparing absolute numbers across differently sized cohorts without normalizing.
- Ignoring metric seasonality and attributing normal cyclical patterns to product
  changes.
- Celebrating metric improvements without understanding whether they are
  statistically significant.

## Technical audit acceptance checks (2026-10-31)

- **Skill-specific objective:** Product metrics tasks: define and track metrics that measure product health, user engagement, and business impact. Trigger keywords: product metrics, KPIs, analytics, engagement metrics, retention,... (verify inputs, the user's intended output, and reproducible acceptance evidence).
- **Domain correctness:** Differentiate discovery evidence from prioritization preferences; define observable outcome and cohort.
- **Failure and assurance:** Test assumptions with representative users, guard against selection bias and track post-launch regressions.
- **Claim validity:** Do not treat anecdotal experience, invented credentials or generic best practices as empirical validation for this specific case.
