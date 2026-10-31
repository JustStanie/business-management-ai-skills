---
name: drift
description: 'Use for drift tasks: conversational marketing, live chat, chatbots, meeting scheduling, contact management,
  REST API, webhooks, JavaScript SDK.'
---

# Drift — Customer Support Integration

You are an expert in integrating Drift for conversational support, live chat, chatbot playbooks, and meeting routing.

## Core Philosophy

### Overview

Drift (now part of Salesloft) is a conversational marketing and support platform that combines live chat, AI-powered chatbots (Playbooks), meeting scheduling, and contact enrichment. It is designed to convert website visitors into leads and route support queries to the right agents. The REST API provides access to conversations, contacts, messages, and account data. The JavaScript SDK controls the on-page chat widget behavior.

## Setup & Configuration

Authenticate with an OAuth2 access token:

```typescript
import axios, { AxiosInstance } from "axios";

function createDriftClient(accessToken: string): AxiosInstance {
  return axios.create({
    baseURL: "https://driftapi.com",
    headers: {
      Authorization: `Bearer ${accessToken}`,
      "Content-Type": "application/json",
    },
  });
}

const drift = createDriftClient(process.env.DRIFT_ACCESS_TOKEN!);

// Verify connection
async function verifyConnection(): Promise<void> {
  const response = await drift.get("/users/list");
  console.log(`Connected. ${response.data.data.length} agents found.`);
}
```

Embed the chat widget and control it via the JavaScript SDK:

```html
<script>
  !function() {
    var t = window.driftt = window.drift = window.driftt || [];
    if (!t.init) {
      t.invoked = true;
      t.methods = ["identify", "config", "track", "reset", "debug", "show",
        "ping", "page", "hide", "off", "on"];
      t.factory = function(e) {
        return function() {
          var n = Array.prototype.slice.call(arguments);
          n.unshift(e);
          t.push(n);
          return t;
        };
      };
      t.methods.forEach(function(e) { t[e] = t.factory(e); });
      t.load = function(t) {
        var e = document.createElement("script");
        e.type = "text/javascript";
        e.async = true;
        e.src = "https://js.driftt.com/include/" + t + ".js";
        var n = document.getElementsByTagName("script")[0];
        n.parentNode.insertBefore(e, n);
      };
    }
  }();
  drift.SNIPPET_VERSION = '0.3.1';
  drift.load('YOUR_DRIFT_EMBED_ID');
</script>
```

Identify logged-in users:

```typescript
declare global {
  interface Window {
    drift: {
      identify: (userId: string, attrs: Record<string, unknown>) => void;
      on: (event: string, callback: (...args: any[]) => void) => void;
      show: () => void;
      hide: () => void;
    };
  }
}

function identifyUser(userId: string, email: string, attributes: Record<string, unknown> = {}): void {
  window.drift.identify(userId, {
    email,
    ...attributes,
  });
}

// Example: pass plan and company info
identifyUser("user_12345", "jane@acme.com", {
  company: "Acme Corp",
  plan: "enterprise",
  createdAt: 1640000000,
});
```

## Core Patterns

### Send a Message in a Conversation

```typescript
interface DriftMessage {
  conversationId: number;
  body: string;
  type?: "chat" | "private_prompt";
}

async function sendMessage(params: DriftMessage): Promise<any> {
  const response = await drift.post(
    `/conversations/${params.conversationId}/messages`,
    {
      type: params.type ?? "chat",
      body: params.body,
    }
  );
  return response.data.data;
}
```

### List and Filter Conversations

```typescript
async function getConversations(statusId?: number): Promise<any[]> {
  const params: Record<string, unknown> = {};
  if (statusId !== undefined) {
    params.statusId = statusId; // 1=open, 2=closed, 3=pending
  }
  const response = await drift.get("/conversations/list", { params });
  return response.data.data;
}

// Get conversation details with messages
async function getConversationWithMessages(conversationId: number): Promise<any> {
  const [convo, messages] = await Promise.all([
    drift.get(`/conversations/${conversationId}`),
    drift.get(`/conversations/${conversationId}/messages`),
  ]);
  return {
    conversation: convo.data.data,
    messages: messages.data.data,
  };
}
```

### Manage Contacts

```typescript
interface DriftContact {
  email: string;
  attributes: Record<string, unknown>;
}

async function createOrUpdateContact(contact: DriftContact): Promise<any> {
  // Check Drift contact identity semantics for the target account/version; do not assume email deduplication is automatic
  const response = await drift.post("/contacts", {
    attributes: {
      email: contact.email,
      ...contact.attributes,
    },
  });
  return response.data.data;
}

// Retrieve a contact by email
async function findContactByEmail(email: string): Promise<any | null> {
  const response = await drift.get("/contacts", {
    params: { email },
  });
  const contacts = response.data.data;
  return contacts.length > 0 ? contacts[0] : null;
}
```

### Webhook Handler

Drift webhook events include a verification token in the `X-Verification-Token` header and/or the JSON `token` field. This is a **shared-token verification flow**, not the invented `x-drift-signature` HMAC shown in some old examples. Verify the token with a constant-time comparison against your configured secret, use HTTPS, limit payload sizes, deduplicate events and validate organization identifiers.

```typescript
import express from "express";
import crypto from "node:crypto";

function constantTimeTokenMatch(given: unknown, expected: string): boolean {
  if (typeof given !== "string" || !expected) return false;
  const a = crypto.createHash("sha256").update(given).digest();
  const b = crypto.createHash("sha256").update(expected).digest();
  return crypto.timingSafeEqual(a, b);
}

function setupDriftWebhooks(app: express.Application): void {
  app.post("/webhooks/drift", express.json({ limit: "256kb" }), (req, res) => {
    const expected = process.env.DRIFT_VERIFICATION_TOKEN ?? "";
    const headerToken = req.header("X-Verification-Token");
    const bodyToken = req.body?.token;
    const token = headerToken ?? bodyToken;
    if (!constantTimeTokenMatch(token, expected)) {
      res.sendStatus(401);
      return;
    }
    if (headerToken && bodyToken && headerToken !== bodyToken) {
      res.sendStatus(401);
      return;
    }
    const orgId = req.body?.orgId;
    if (!Number.isInteger(orgId)) {
      res.sendStatus(400);
      return;
    }
    // Validate event schema, deduplicate, and enqueue business handling.
    res.sendStatus(202);
  });
}
```

Use the documented verification token and official event catalog: https://devdocs.drift.com/docs/webhook-events-1 . Rotating this shared secret requires coordinated configuration. A verification token by itself does not provide the payload-integrity guarantees of a digital signature; use trusted HTTPS endpoints and replay/duplicate controls.


## Best Practices

- Use `drift.identify()` on every authenticated page load with up-to-date user attributes; this ensures agents see current account context in the sidebar and Playbook targeting rules evaluate correctly.
- Route conversations using Drift's Playbook targeting rules rather than building custom routing logic; Playbooks can filter by URL, contact attributes, visit count, and time on page.
- Store the Drift `conversationId` and `contactId` in your own system to correlate support interactions with internal user records and enable cross-platform reporting.

## Common Pitfalls

- The Drift JavaScript snippet must load before calling `drift.identify()`. If you call identify too early, the call is silently dropped. Use the official JS SDK readiness mechanism documented for your installed version; avoid assuming one undocumented callback name across versions.
- Drift's API rate limits are not publicly documented in detail; implement exponential backoff on `429` responses and avoid polling conversation lists more frequently than once per minute.
## Anti-Patterns

**Using the service without understanding its pricing model.** Cloud services bill differently — per request, per GB, per seat. Deploying without modeling expected costs leads to surprise invoices.

**Hardcoding configuration instead of using environment variables.** API keys, endpoints, and feature flags change between environments. Hardcoded values break deployments and leak secrets.

**Ignoring the service's rate limits and quotas.** Every external API has throughput limits. Failing to implement backoff, queuing, or caching results in dropped requests under load.

**Treating the service as always available.** External services go down. Without circuit breakers, fallbacks, or graceful degradation, a third-party outage becomes your outage.

**Coupling your architecture to a single provider's API.** Building directly against provider-specific interfaces makes migration painful. Wrap external services in thin adapter layers.

## Technical audit acceptance checks (2026-10-31)

- **Skill-specific objective:** Drift tasks: conversational marketing, live chat, chatbots, meeting scheduling, contact management, REST API, webhooks, JavaScript SDK (verify inputs, the user's intended output, and reproducible acceptance evidence).
- **Domain correctness:** Verify exact provider authentication, endpoint, webhook/event schema, quotas, and data retention for the selected deployment.
- **Failure and assurance:** Test signature/token verification, retries, duplicate delivery and PII minimization in a provider sandbox.
- **External integrations:** Treat vendor-specific API capabilities and example payloads as version-dependent. Pin documentation/schema versions and validate permissions and side effects against a sandbox before production.
- **Code examples:** Examples require dependency/version pinning, dry runs, credential separation, and integration tests; Markdown formatting is not evidence of compilability or live execution.
