---
name: loops
description: 'Use for loops tasks: email for SaaS, transactional + marketing, contacts, events, loops (automations),
  API sends, webhooks.'
---

# Loops Email Platform Integration

## Core Philosophy

Loops is an email platform purpose-built for SaaS companies, unifying transactional and marketing email under one roof. Its API at `https://app.loops.so/api/v1/` is designed around contacts (not subscribers), events (behavioral triggers), and loops (automated sequences). Authentication uses a Bearer token. The platform bridges the gap between product-triggered transactional emails and marketing campaigns, letting you manage both through the same contact records and event system. Build integrations that emit events from your product, let Loops handle the automation logic, and use the API for contact sync and transactional sends.

## Setup

### Authentication and Client Configuration

```typescript
interface LoopsConfig {
  apiKey: string;
  baseUrl?: string;
}

class LoopsClient {
  private readonly baseUrl: string;
  private readonly headers: Record<string, string>;

  constructor(config: LoopsConfig) {
    this.baseUrl = config.baseUrl ?? "https://app.loops.so/api/v1";
    this.headers = {
      Authorization: `Bearer ${config.apiKey}`,
      "Content-Type": "application/json",
    };
  }

  async request<T>(
    method: string,
    path: string,
    body?: unknown
  ): Promise<T> {
    const url = `${this.baseUrl}${path}`;
    const res = await fetch(url, {
      method,
      headers: this.headers,
      body: body ? JSON.stringify(body) : undefined,
    });

    if (!res.ok) {
      const errorText = await res.text();
      throw new Error(`Loops ${method} ${path} ${res.status}: ${errorText}`);
    }

    if (res.status === 204) return undefined as T;
    return res.json() as Promise<T>;
  }
}

const loops = new LoopsClient({
  apiKey: process.env.LOOPS_API_KEY!,
});
```

### Verify API Key

```typescript
async function verifyApiKey(client: LoopsClient): Promise<boolean> {
  const res = await client.request<{ success: boolean }>(
    "GET",
    "/api-key"
  );
  console.log(`Loops API key valid: ${res.success}`);
  return res.success;
}
```

## Key Techniques

### Contact Management

```typescript
interface LoopsContact {
  id: string;
  email: string;
  firstName?: string;
  lastName?: string;
  source: string;
  subscribed: boolean;
  userGroup?: string;
  userId?: string;
  mailingLists?: Record<string, boolean>;
  [customField: string]: unknown;
}

async function createContact(
  client: LoopsClient,
  email: string,
  opts?: {
    firstName?: string;
    lastName?: string;
    source?: string;
    userId?: string;
    userGroup?: string;
    subscribed?: boolean;
    mailingLists?: Record<string, boolean>;
    customFields?: Record<string, string | number | boolean>;
  }
): Promise<{ success: boolean; id: string }> {
  return client.request("POST", "/contacts/create", {
    email,
    firstName: opts?.firstName,
    lastName: opts?.lastName,
    source: opts?.source ?? "api",
    userId: opts?.userId,
    userGroup: opts?.userGroup,
    subscribed: opts?.subscribed ?? false, // set true only after verifiable marketing consent
    mailingLists: opts?.mailingLists,
    ...opts?.customFields,
  });
}

async function updateContact(
  client: LoopsClient,
  email: string,
  updates: Record<string, unknown>
): Promise<{ success: boolean }> {
  return client.request("PUT", "/contacts/update", {
    email,
    ...updates,
  });
}

async function findContact(
  client: LoopsClient,
  identifier: { email: string } | { userId: string }
): Promise<LoopsContact[]> {
  const param = "email" in identifier
    ? `email=${encodeURIComponent(identifier.email)}`
    : `userId=${encodeURIComponent(identifier.userId)}`;

  return client.request<LoopsContact[]>("GET", `/contacts/find?${param}`);
}

async function deleteContact(
  client: LoopsClient,
  identifier: { email: string } | { userId: string }
): Promise<{ success: boolean }> {
  return client.request("POST", "/contacts/delete", identifier);
}

async function upsertContact(
  client: LoopsClient,
  email: string,
  data: Record<string, unknown>
): Promise<{ success: boolean; id: string }> {
  // Look up contact; update if present, otherwise create using consent-safe defaults
  const existing = await findContact(client, { email });
  if (existing.length > 0) {
    await updateContact(client, email, data);
    return { success: true, id: existing[0].id };
  }
  return createContact(client, email, {
    ...data,
    source: (data.source as string) ?? "api",
  });
}
```

### Events (Behavioral Triggers)

```typescript
async function sendEvent(
  client: LoopsClient,
  event: {
    email?: string;
    userId?: string;
    eventName: string;
    eventProperties?: Record<string, string | number | boolean>;
    mailingLists?: Record<string, boolean>;
    contactProperties?: Record<string, unknown>;
  }
): Promise<{ success: boolean }> {
  if (!event.email && !event.userId) {
    throw new Error("Either email or userId must be provided");
  }

  return client.request("POST", "/events/send", {
    email: event.email,
    userId: event.userId,
    eventName: event.eventName,
    eventProperties: event.eventProperties,
    mailingLists: event.mailingLists,
    ...event.contactProperties,
  });
}

// Product event examples for SaaS lifecycle
async function trackUserSignup(
  client: LoopsClient,
  email: string,
  userId: string,
  plan: string
): Promise<void> {
  await sendEvent(client, {
    email,
    userId,
    eventName: "signup",
    eventProperties: { plan },
    contactProperties: {
      firstName: undefined,
      source: "app",
      userGroup: plan,
    },
  });
}

async function trackFeatureUsed(
  client: LoopsClient,
  userId: string,
  feature: string
): Promise<void> {
  await sendEvent(client, {
    userId,
    eventName: "feature_used",
    eventProperties: { feature, timestamp: Date.now() },
  });
}

async function trackTrialExpiring(
  client: LoopsClient,
  userId: string,
  daysLeft: number
): Promise<void> {
  await sendEvent(client, {
    userId,
    eventName: "trial_expiring",
    eventProperties: { days_left: daysLeft },
  });
}
```

### Transactional Email

```typescript
interface TransactionalSendResult {
  success: boolean;
  path?: string;
}

async function sendTransactionalEmail(
  client: LoopsClient,
  transactionalId: string,
  email: string,
  dataVariables?: Record<string, string | number>,
  opts?: {
    addToAudience?: boolean;
    attachments?: Array<{
      filename: string;
      contentType: string;
      data: string; // base64
    }>;
  }
): Promise<TransactionalSendResult> {
  return client.request("POST", "/transactional", {
    transactionalId,
    email,
    dataVariables: dataVariables ?? {},
    addToAudience: opts?.addToAudience ?? false,
    attachments: opts?.attachments,
  });
}

// Common transactional email patterns
async function sendWelcomeEmail(
  client: LoopsClient,
  email: string,
  name: string,
  loginUrl: string
): Promise<void> {
  await sendTransactionalEmail(
    client,
    process.env.LOOPS_WELCOME_TEMPLATE_ID!,
    email,
    { name, loginUrl }
  );
}

async function sendPasswordReset(
  client: LoopsClient,
  email: string,
  resetUrl: string,
  expiresIn: string
): Promise<void> {
  await sendTransactionalEmail(
    client,
    process.env.LOOPS_PASSWORD_RESET_TEMPLATE_ID!,
    email,
    { resetUrl, expiresIn }
  );
}

async function sendInvoice(
  client: LoopsClient,
  email: string,
  invoiceData: { amount: string; date: string; invoiceNumber: string },
  pdfBase64: string
): Promise<void> {
  await sendTransactionalEmail(
    client,
    process.env.LOOPS_INVOICE_TEMPLATE_ID!,
    email,
    invoiceData,
    {
      attachments: [
        {
          filename: `invoice-${invoiceData.invoiceNumber}.pdf`,
          contentType: "application/pdf",
          data: pdfBase64,
        },
      ],
    }
  );
}
```

### Mailing Lists

```typescript
interface MailingList {
  id: string;
  name: string;
  isPublic: boolean;
}

async function getMailingLists(
  client: LoopsClient
): Promise<MailingList[]> {
  return client.request<MailingList[]>("GET", "/lists");
}

async function addContactToList(
  client: LoopsClient,
  email: string,
  listId: string
): Promise<void> {
  await updateContact(client, email, {
    mailingLists: { [listId]: true },
  });
}

async function removeContactFromList(
  client: LoopsClient,
  email: string,
  listId: string
): Promise<void> {
  await updateContact(client, email, {
    mailingLists: { [listId]: false },
  });
}

async function syncUserToLists(
  client: LoopsClient,
  email: string,
  plan: string,
  lists: { freeListId: string; proListId: string; enterpriseListId: string }
): Promise<void> {
  const mailingLists: Record<string, boolean> = {
    [lists.freeListId]: plan === "free",
    [lists.proListId]: plan === "pro",
    [lists.enterpriseListId]: plan === "enterprise",
  };
  await updateContact(client, email, { mailingLists });
}
```

### Custom Properties and Bulk Sync

```typescript
async function getCustomFields(
  client: LoopsClient
): Promise<Array<{ key: string; label: string; type: string }>> {
  return client.request("GET", "/contacts/customFields");
}

async function bulkContactSync(
  client: LoopsClient,
  contacts: Array<{ email: string; userId: string; [key: string]: unknown }>
): Promise<{ synced: number; errors: number }> {
  let synced = 0;
  let errors = 0;

  for (const contact of contacts) {
    try {
      await upsertContact(client, contact.email, contact);
      synced++;
    } catch (err) {
      console.error(`Failed to sync ${contact.email}:`, err);
      errors++;
    }
    // Loops rate limit: 10 requests/second
    if (synced % 10 === 0) {
      await new Promise((r) => setTimeout(r, 1100));
    }
  }

  return { synced, errors };
}
```

## Contact consent and subscription safety

Loops documents that new contacts are normally subscribed by default and that explicitly sending `subscribed: true` can **re-subscribe an opted-out contact**. In this example we use an explicit safe default of `false` for new contacts unless verified marketing consent exists; preserve the established suppression/opt-out status when updating an existing contact. Do not use a blind upsert to re-enable marketing sends. The platform documentation recommends omitting `subscribed` when status changes are not intended.

Reference: https://app.loops.so/docs/contacts/properties

## Best Practices

- **Use userId for contact identification**: Always set a `userId` alongside email. This lets you track contacts even if they change their email address, and is required for event sends by user ID.
- **Emit events from your product code**: Loops automations (loops) are triggered by events. Instrument your signup, onboarding, upgrade, and churn flows to emit events that drive automated sequences.
- **Separate transactional from marketing templates**: Use transactional sends for receipts, password resets, and system alerts. Use events and loops for marketing flows like onboarding drips and re-engagement.
- **Use mailing lists for consent management**: Map mailing lists to opt-in categories (product updates, blog digest, changelog). Let users manage preferences via your settings page.
- **Rate limit your API calls**: Loops enforces approximately 10 requests/second. Add delays in bulk operations and use batching patterns.
- **Leverage contact properties for segmentation**: Sync plan type, signup date, and usage metrics as custom fields to power targeted loops without querying your database.

## Anti-Patterns

- **Storing transactional template IDs as magic strings**: Use environment variables or a configuration map for template IDs. Templates may be recreated or updated with new IDs.
- **Sending events without contact creation**: If a contact does not exist, some event sends will silently fail. Ensure contacts are created before emitting events, or use upsert patterns.
- **Using email as the sole identifier**: Emails change. Always pair contacts with a stable `userId` from your application database.
- **Ignoring the `subscribed` field**: Contacts can be unsubscribed but still exist. Always check `subscribed` status before assuming a contact will receive marketing emails.
- **Sending large attachments via transactional API**: Loops supports attachments up to a limited size. For large files, host them and include a download link in the template instead.
- **Polling contacts for changes**: Loops does not yet provide a comprehensive webhook system for all contact changes. If you need real-time sync, emit events from your application and use your own event bus as the source of truth.

## Technical audit acceptance checks (2026-10-31)

- **Skill-specific objective:** Loops tasks: email for SaaS, transactional + marketing, contacts, events, loops (automations), API sends, webhooks (verify inputs, the user's intended output, and reproducible acceptance evidence).
- **Domain correctness:** Verify current provider API, authentication, subscription status and consent requirements.
- **Failure and assurance:** Test unsubscribe, bounce handling, deduplication, retries, and suppression-list reconciliation.
- **External integrations:** Treat vendor-specific API capabilities and example payloads as version-dependent. Pin documentation/schema versions and validate permissions and side effects against a sandbox before production.
- **Code examples:** Examples require dependency/version pinning, dry runs, credential separation, and integration tests; Markdown formatting is not evidence of compilability or live execution.
