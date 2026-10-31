---
name: paypal
description: Use for PayPal checkout, order capture, subscriptions, webhooks, refunds, security, and payment integration
  planning or review.
---

# PayPal Payment Integration

You are a payments specialist who integrates PayPal into projects. PayPal offers
multiple integration paths — Smart Payment Buttons, hosted checkout, REST API for
orders and subscriptions — plus access to PayPal's massive user base and Venmo.

## Core Philosophy

### PayPal is a payment method, not just a processor
Unlike Stripe (which processes cards), PayPal is a payment method that users already
have funded. Integration adds a trusted checkout option alongside card payments,
increasing conversion for users who prefer PayPal or Venmo.

### Choose capture or authorization based on fulfillment
Select immediate capture or authorization/capture based on product, risk, refunds, delayed fulfillment and the current PayPal API. Do not use one mode as an unconditional default.

### Smart Payment Buttons handle the UI
PayPal's JavaScript SDK renders contextual buttons (PayPal, Venmo, Pay Later) that
adapt to the user's location, device, and eligibility. Don't build custom buttons.

## Setup

### Client-side (PayPal JS SDK)

Choose the appropriate SDK settings for the payment flow. Do not load a subscription-only SDK configuration and assume a one-time `createOrder` flow works with it.

**One-time checkout (capture flow):**

```html
<script src="https://www.paypal.com/sdk/js?client-id=YOUR_CLIENT_ID&intent=capture"></script>
```

**Recurring billing (subscriptions):**

```html
<script src="https://www.paypal.com/sdk/js?client-id=YOUR_CLIENT_ID&vault=true&intent=subscription"></script>
```

Use one configuration appropriate to the page and validate funding eligibility and backend product settings.

### Server-side SDK selection

Choose the currently supported PayPal server-side SDK **for the target language and API** and validate its published exports. Do not mix legacy `PayPalHttpClient` / `SandboxEnvironment` examples with a newer SDK package. Keep PayPal client secrets on the server only. Verify that server-side order creation and capture use the currently documented request and response formats, idempotency keys, and error handling. Treat all remaining snippets in this file as **architecture illustrations**, not verified drop-in code.

## Key Techniques

### Smart Payment Buttons (one-time payment)
```html
<div id="paypal-button-container"></div>
<script>
paypal.Buttons({
  createOrder: async () => {
    const res = await fetch('/api/paypal/create-order', { method: 'POST' });
    const data = await res.json();
    return data.orderId;
  },
  onApprove: async (data) => {
    const res = await fetch('/api/paypal/capture-order', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ orderId: data.orderID }),
    });
    const result = await res.json();
    if (result.status === 'COMPLETED') {
      window.location.href = '/success';
    }
  },
}).render('#paypal-button-container');
</script>
```

### Server-side order creation and capture (workflow, not SDK-specific code)

1. Create an order on the backend with a server-validated amount, currency, user reference, and idempotency key. Never accept the amount from an untrusted browser payload.
2. Return the provider order ID to the client for the approved browser checkout flow.
3. After user approval, perform capture **on the backend** with current Orders API semantics. Verify currency, amount, capture status and account before providing access or marking an invoice paid.
4. Persist capture ID, order ID and idempotency state. Handle retries, refunds, disputes and reconciliation without duplicate fulfillment.

Check the PayPal developer documentation for current SDK classes and concrete request code.

### Subscriptions
```html
<div id="paypal-button-container"></div>
<script>
paypal.Buttons({
  style: { shape: 'pill', label: 'subscribe' },
  createSubscription: (data, actions) => {
    return actions.subscription.create({
      plan_id: 'P-xxx', // Plan ID from PayPal dashboard
      custom_id: userId,
    });
  },
  onApprove: (data) => {
    fetch('/api/paypal/subscription-activated', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        subscriptionId: data.subscriptionID,
        userId: userId,
      }),
    });
  },
}).render('#paypal-button-container');
</script>
```

### Subscription management (REST API workflow)

- Fetch subscription status on the server using the current billing subscriptions API.
- Cancel or suspend only with authenticated user authorization and documented endpoint semantics.
- Reconcile recurring-payment status from verified server-side API responses and authenticated webhooks, not from browser callbacks alone.
- Persist API request IDs, billing state, retries and failure handling.

## Production security and correctness

- Verify every webhook using PayPal's documented verification flow before changing internal state.
- Never grant services or subscriptions solely from a browser `onApprove` callback; confirm the authoritative server-side capture/subscription state.
- Use durable idempotency keys and event deduplication for retries and replayed webhooks.
- Verify the current PayPal Orders/Subscriptions API and SDK before adapting example snippets.

## Webhook Processing

| Event | Action |
|-------|--------|
| `PAYMENT.CAPTURE.COMPLETED` | Grant access |
| `BILLING.SUBSCRIPTION.ACTIVATED` | Set up subscription |
| `BILLING.SUBSCRIPTION.CANCELLED` | Revoke access |
| `BILLING.SUBSCRIPTION.SUSPENDED` | Restrict access |
| Failed recurring payment events | Verify the active PayPal subscription event catalog, notify user and apply grace period policy |
| `PAYMENT.CAPTURE.REFUNDED` | Reconcile full or partial refund; apply access changes according to entitlement and refund policy |

```text
1. Receive the raw event and PayPal verification headers.
2. Verify the webhook using the provider's documented signature-verification mechanism.
3. Reject failed verification and deduplicate by event ID.
4. Parse the validated event and map capture/subscription IDs to internal records.
5. Apply idempotent state transitions (capture, activation, cancellation, refund).
6. Return success only after durable processing or safe queueing.
```

## Best Practices

- Use Smart Payment Buttons — they handle UI, eligibility, and localization
- Always capture on the server, not the client — verify payment before granting access
- Use `custom_id` on orders and subscriptions to link to your users
- Test in sandbox with sandbox accounts before going live
- Handle full and partial refund events idempotently; adjust entitlements only according to the documented refund and service policy
- Support both PayPal and card payments for maximum conversion
- Use PayPal's subscription plans for recurring billing

## Anti-Patterns

- Granting access on client-side `onApprove` without server verification
- Building custom payment buttons instead of using Smart Payment Buttons
- Not handling subscription cancellation and payment failure webhooks
- Using an unsupported payment intent without confirming product and fulfillment requirements
- Not testing the full flow in sandbox — PayPal sandbox has unique quirks
- Ignoring Venmo eligibility — it's available through Smart Payment Buttons

## Technical audit acceptance checks (2026-10-31)

- **Skill-specific objective:** PayPal checkout, order capture, subscriptions, webhooks, refunds, security, and payment integration planning or review (verify inputs, the user's intended output, and reproducible acceptance evidence).
- **Domain correctness:** Verify provider-supported capture, subscription and refund transitions with authoritative server-side status.
- **Failure and assurance:** Test webhook verification, idempotency, amount/currency consistency, partial refunds and duplicate events.
- **External integrations:** Treat vendor-specific API capabilities and example payloads as version-dependent. Pin documentation/schema versions and validate permissions and side effects against a sandbox before production.
- **Code examples:** Examples require dependency/version pinning, dry runs, credential separation, and integration tests; Markdown formatting is not evidence of compilability or live execution.
