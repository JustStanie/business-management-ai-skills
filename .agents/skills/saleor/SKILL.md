---
name: saleor
description: Integrate Saleor headless e-commerce via its GraphQL API for storefronts and dashboards. Handle checkout
  flows, payment gateways, and webhook app extensions with type-safe queries.
---

# Saleor Integration

You are a Saleor integration specialist who builds headless commerce experiences on Saleor's GraphQL-first platform. You construct type-safe queries for products, checkouts, and orders, wire up payment gateways through Saleor Apps, and process asynchronous webhook events for order fulfillment and inventory updates.

## Core Philosophy

### GraphQL as the Single Interface
Saleor exposes all functionality through one GraphQL endpoint. There is no REST API. Every storefront operation, admin action, and app interaction goes through GraphQL mutations and queries. Use code generation tools like `graphql-codegen` to produce TypeScript types from Saleor's schema, ensuring compile-time safety across your entire frontend and backend.

### App-Based Extensibility
Saleor extends through Apps rather than plugins. An App is a standalone service that registers webhooks, provides custom UI in the dashboard, and handles payment or tax logic. Apps authenticate with scoped app access tokens; do not assume all provider tokens have the same JWT structure or lifetime. This keeps the core platform lean while allowing unlimited extension.

### Channel-Aware Multi-Tenancy
Saleor supports multiple channels (storefronts, regions, currencies) from a single instance. Every query that touches products, pricing, or checkout must specify a channel slug. Design your integration to pass the channel context through every layer of your application.

## Setup

### Install
```bash
npm install graphql @graphql-codegen/cli @graphql-codegen/typescript
npm install @saleor/app-sdk  # for building Saleor Apps
npm install jose  # if manually verifying detached JWS instead of App SDK middleware
```

### Environment Variables
```env
SALEOR_API_URL=https://your-store.saleor.cloud/graphql/
SALEOR_APP_TOKEN=your_app_token
SALEOR_CHANNEL_SLUG=default-channel
SALEOR_ORIGIN=https://your-store.saleor.cloud
# SALEOR_WEBHOOK_SECRET=... only for a confirmed legacy HMAC configuration
```

## Key Patterns

### 1. Fetch Products with Channel Context

```typescript
const PRODUCTS_QUERY = `
  query GetProducts($channel: String!, $first: Int!) {
    products(channel: $channel, first: $first) {
      edges {
        node {
          id
          name
          slug
          pricing { priceRange { start { gross { amount currency } } } }
          thumbnail { url alt }
          category { name }
        }
      }
    }
  }
`;

async function fetchProducts(channel: string, count: number) {
  const res = await fetch(process.env.SALEOR_API_URL!, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ query: PRODUCTS_QUERY, variables: { channel, first: count } }),
  });
  if (!res.ok) throw new Error(`Saleor HTTP ${res.status}`);
  const payload = await res.json();
  if (payload.errors?.length) throw new Error(JSON.stringify(payload.errors));
  if (!payload.data?.products) throw new Error("Missing products response");
  return payload.data.products.edges.map((e: any) => e.node);
}
```

### 2. Create and Complete a Checkout Flow

```typescript
const CHECKOUT_CREATE = `
  mutation CheckoutCreate($channel: String!, $lines: [CheckoutLineInput!]!) {
    checkoutCreate(input: { channel: $channel, lines: $lines }) {
      checkout { id token totalPrice { gross { amount currency } } }
      errors { field message code }
    }
  }
`;

const CHECKOUT_COMPLETE = `
  mutation CheckoutComplete($id: ID!) {
    checkoutComplete(id: $id) {
      order { id number status }
      errors { field message code }
    }
  }
`;

async function saleorGraphQL(query: string, variables: Record<string, unknown>) {
  const res = await fetch(process.env.SALEOR_API_URL!, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${process.env.SALEOR_APP_TOKEN}`,
    },
    body: JSON.stringify({ query, variables }),
  });
  return res.json();
}
```

### 3. Verify and Handle Webhook Payloads

For current Saleor installations, use the **official Saleor App SDK webhook-verification middleware** or validate Saleor's detached RS256 JWS signature against the trusted instance JWKS. Older HMAC-with-secret webhooks are deprecated and need a separate version-specific verification path. Do not compare a hex HMAC with `Saleor-Signature` as though all versions used HMAC.

```typescript
import { createRemoteJWKSet, flattenedVerify } from "jose";
import { NextRequest, NextResponse } from "next/server";

// Configure to a pinned, trusted Saleor instance (never from untrusted headers).
const SALEOR_ORIGIN = process.env.SALEOR_ORIGIN!;
const jwks = createRemoteJWKSet(new URL(`${SALEOR_ORIGIN}/.well-known/jwks.json`));

export async function POST(req: NextRequest) {
  const detachedJws = req.headers.get("saleor-signature") ?? "";
  const [protectedHeader, detachedPayload, signature] = detachedJws.split(".");
  if (!protectedHeader || detachedPayload !== "" || !signature) {
    return NextResponse.json({ error: "Missing or invalid signature" }, { status: 401 });
  }

  const raw = await req.text(); // Must preserve original exact bytes.
  try {
    await flattenedVerify({
      protected: protectedHeader,
      payload: new TextEncoder().encode(raw),
      signature,
    }, jwks, { algorithms: ["RS256"] });
  } catch {
    return NextResponse.json({ error: "Invalid signature" }, { status: 401 });
  }

  // Parse only after verification. Validate event type and deduplicate event IDs.
  const event = JSON.parse(raw);
  // Persist the event or safely enqueue it; implement idempotent handlers.
  return NextResponse.json({ received: true });
}
```

The example illustrates the detached-JWS verification path, not a fully deployable handler: also validate the trusted app/domain context, request size, event schema, retries and storage, and confirm the deployed Saleor version. See https://docs.saleor.io/developer/extending/webhooks/payload-signature .


## Common Patterns

### Add Shipping Address to Checkout
```typescript
const UPDATE_SHIPPING = `
  mutation CheckoutShippingUpdate($id: ID!, $address: AddressInput!) {
    checkoutShippingAddressUpdate(id: $id, shippingAddress: $address) {
      checkout { id shippingAddress { firstName lastName streetAddress1 city } }
      errors { field message }
    }
  }
`;
```

### Query Orders with Filtering
```typescript
const ORDERS_QUERY = `
  query Orders($filter: OrderFilterInput, $first: Int!) {
    orders(filter: $filter, first: $first) {
      edges { node { id number created status total { gross { amount currency } } } }
    }
  }
`;
```

### Register App Webhook
```typescript
const WEBHOOK_CREATE = `
  mutation WebhookCreate($input: WebhookCreateInput!) {
    webhookCreate(input: $input) {
      webhook { id isActive events { eventType } }
      errors { field message }
    }
  }
`;
```

## Anti-Patterns
- Omitting the channel slug in storefront queries, causing empty or incorrect pricing results
- Polling for order status instead of subscribing to webhook events
- Storing Saleor app tokens in client-side code instead of server-side environment variables
- Assuming every Saleor ID is a legacy base64-encoded type:pk; use the schema-defined ID type and do not decode IDs or hardcode representation assumptions

## When to Use
- Building a custom storefront that needs a fully open-source, GraphQL-native commerce backend
- Creating multi-channel, multi-currency storefronts from a single Saleor instance
- Developing payment or fulfillment apps that plug into the Saleor ecosystem
- Migrating from a monolithic e-commerce platform to a composable, API-driven architecture
- Implementing B2B commerce flows with custom pricing, permissions, and approval workflows

## Technical audit acceptance checks (2026-10-31)

- **Skill-specific objective:** Integrate Saleor headless e-commerce via its GraphQL API for storefronts and dashboards. Handle checkout flows, payment gateways, and webhook app extensions with type-safe queries (verify inputs, the user's intended output, and reproducible acceptance evidence).
- **Domain correctness:** Pin the platform version/schema and validate permissions, checkout/payment state transitions and webhook authentication.
- **Failure and assurance:** Test stale inventory, partial failures, duplicated events, refunds and reconciliation before production deployment.
- **External integrations:** Treat vendor-specific API capabilities and example payloads as version-dependent. Pin documentation/schema versions and validate permissions and side effects against a sandbox before production.
- **Code examples:** Examples require dependency/version pinning, dry runs, credential separation, and integration tests; Markdown formatting is not evidence of compilability or live execution.
