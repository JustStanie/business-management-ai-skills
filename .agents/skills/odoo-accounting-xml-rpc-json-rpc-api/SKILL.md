---
name: odoo-accounting-xml-rpc-json-rpc-api
description: Use for Odoo accounting integrations, invoices, payments, partners, journal entries and version-specific
  migration from legacy XML-RPC/JSON-RPC to JSON-2.
---

# Odoo Accounting XML-RPC / JSON-RPC API

You are a senior developer integrating with Odoo Accounting via its XML-RPC and JSON-RPC APIs. You build integrations for partners, invoices, payments, journal entries, reconciliation, and chart of accounts management using Odoo's external API.

## Core Philosophy

### Everything Is a Model
Odoo's API is model-centric. Every entity (invoice, partner, payment) is a model accessed through generic CRUD methods: `create`, `read`, `search`, `write`, `unlink`. Learn the model names and field names — the rest is repetitive.

### Legacy XML-RPC / JSON-RPC versus JSON-2
Legacy Odoo versions expose XML-RPC and JSON-RPC endpoints, but these APIs are deprecated in Odoo 19 and later, with a version-specific removal schedule: Odoo 20 removed the legacy database (`db`) service, while common/object RPC services are scheduled for removal in Odoo 22 (hosted Online timelines differ). For new Odoo 19+ integrations, prefer the External JSON-2 API (`/json/2`) when supported by the target deployment; external API access can require the Custom plan. Do not assume legacy RPC endpoints will exist for the target version. Check the target deployment, licensing tier, and official documentation before choosing a transport.

### Odoo Version Matters
Field names and model names change between Odoo versions (including 19 and 20). Always check the specific version's documentation. `account.invoice` became `account.move` in Odoo 13+.

## Version-specific implementation notice (reviewed October 2026)

The code snippets below demonstrate **legacy RPC integrations** and are not a current recommended starting point for all Odoo versions. For Odoo 19+ consider External JSON-2 API and use the version-specific external-API documentation. All placeholder IDs (`countryId`, `revenueAccountId`, `taxIds`, `bankJournalId`, `paymentMethodLineId`, `generalJournalId`, `accruedRevenueAccountId`) must be resolved before running the examples; the snippets are illustrative, not drop-in programs. Confirm permissions, API-plan eligibility, authentication, service deprecations, atomicity, and available endpoints before writing production code.

Reference: https://www.odoo.com/documentation/20.0/developer/reference/external_api.html

## Setup

### JSON-2 request pattern for supported Odoo 19+ environments

```typescript
const response = await fetch(`${process.env.ODOO_URL}/json/2/res.partner/search_read`, {
  method: "POST",
  headers: {
    Authorization: `bearer ${process.env.ODOO_API_KEY}`,
    "Content-Type": "application/json",
    // "X-Odoo-Database": process.env.ODOO_DB!, // only for multi-database domains
  },
  body: JSON.stringify({
    domain: [["customer_rank", ">", 0]],
    fields: ["name", "email"],
    limit: 50,
  }),
});
if (!response.ok) throw new Error(`Odoo JSON-2 HTTP ${response.status}`);
const partners = await response.json();
```

JSON-2 uses **named arguments** and bearer API keys. Validate model/method availability via the instance `/doc`; cross-model operations are not automatically atomic across multiple JSON-2 calls. Verify account permissions and plan access.


### Dependencies
```bash
npm install xmlrpc axios
```

### XML-RPC Authentication
```typescript
import xmlrpc from 'xmlrpc';

const ODOO_URL = 'https://your-instance.odoo.com';
const ODOO_DB = 'your-database';
const ODOO_USER = process.env.ODOO_USER!;
const ODOO_PASSWORD = process.env.ODOO_API_KEY!; // API key or password

// Step 1: Authenticate to get user ID
async function authenticate(): Promise<number> {
  const commonClient = xmlrpc.createClient({ url: `${ODOO_URL}/xmlrpc/2/common` });

  return new Promise((resolve, reject) => {
    commonClient.methodCall(
      'authenticate',
      [ODOO_DB, ODOO_USER, ODOO_PASSWORD, {}],
      (err, uid) => {
        if (err) reject(err);
        else resolve(uid as number);
      }
    );
  });
}

// Step 2: Create model client for CRUD operations
function createModelClient() {
  return xmlrpc.createClient({ url: `${ODOO_URL}/xmlrpc/2/object` });
}

async function callOdoo(model: string, method: string, args: any[], kwargs: any = {}): Promise<any> {
  const uid = await authenticate();
  const client = createModelClient();

  return new Promise((resolve, reject) => {
    client.methodCall(
      'execute_kw',
      [ODOO_DB, uid, ODOO_PASSWORD, model, method, args, kwargs],
      (err, result) => {
        if (err) reject(err);
        else resolve(result);
      }
    );
  });
}
```

### JSON-RPC Alternative
```typescript
import axios from 'axios';

async function jsonRpcCall(service: string, method: string, args: any[]) {
  const response = await axios.post(`${ODOO_URL}/jsonrpc`, {
    jsonrpc: '2.0',
    method: 'call',
    params: {
      service,
      method,
      args,
    },
    id: Date.now(),
  });

  if (response.data.error) {
    throw new Error(response.data.error.data.message);
  }
  return response.data.result;
}

// Authenticate via JSON-RPC
async function jsonRpcAuth(): Promise<number> {
  return jsonRpcCall('common', 'authenticate', [ODOO_DB, ODOO_USER, ODOO_PASSWORD, {}]);
}

// Generic model call
async function jsonRpcModel(model: string, method: string, args: any[], kwargs: any = {}) {
  const uid = await jsonRpcAuth();
  return jsonRpcCall('object', 'execute_kw', [
    ODOO_DB, uid, ODOO_PASSWORD, model, method, args, kwargs,
  ]);
}
```

## Key Techniques

### 1. Managing Partners (Customers/Vendors)
```typescript
async function createPartner() {
  const partnerId = await callOdoo('res.partner', 'create', [[
    {
      name: 'Acme Corporation',
      email: 'billing@acme.com',
      phone: '+1-555-0100',
      street: '123 Main Street',
      city: 'San Francisco',
      zip: '94105',
      country_id: countryId, // Resolve country ID from the target database; do not hardcode
      customer_rank: 1, // Marks as customer
      supplier_rank: 0,
      is_company: true,
      vat: 'US123456789',
    },
  ]]);
  return partnerId;
}

async function searchPartners(name: string) {
  const ids = await callOdoo('res.partner', 'search', [
    [['name', 'ilike', name], ['customer_rank', '>', 0]],
  ], { limit: 50 });

  const partners = await callOdoo('res.partner', 'read', [ids], {
    fields: ['name', 'email', 'phone', 'credit', 'debit'],
  });
  return partners;
}
```

### 2. Creating Invoices (account.move)
```typescript
async function createInvoice(partnerId: number) {
  // In Odoo 13+, invoices are account.move records
  const invoiceId = await callOdoo('account.move', 'create', [[
    {
      move_type: 'out_invoice', // out_invoice=customer, in_invoice=vendor
      partner_id: partnerId,
      invoice_date: '2026-03-25',
      invoice_date_due: '2026-04-25',
      ref: 'PO-2026-042',
      invoice_line_ids: [
        [0, 0, { // [0, 0, vals] = create new line
          name: 'Consulting services — March 2026',
          quantity: 20,
          price_unit: 150.00,
          account_id: revenueAccountId, // Resolve for company and chart of accounts
          tax_ids: [[6, 0, taxIds]], // Use company-specific tax records
        }],
        [0, 0, {
          name: 'Software license',
          quantity: 1,
          price_unit: 500.00,
          account_id: 42,
          tax_ids: [[6, 0, [1]]],
        }],
      ],
    },
  ]]);

  // Post the invoice (move from draft to posted)
  await callOdoo('account.move', 'action_post', [[invoiceId]]);

  return invoiceId;
}
```

### 3. Recording Payments
```typescript
async function registerPayment(invoiceId: number) {
  // Use the payment register wizard
  const paymentCtx = {
    active_model: 'account.move',
    active_ids: [invoiceId],
  };

  const wizardId = await callOdoo('account.payment.register', 'create', [[
    {
      payment_date: '2026-03-25',
      amount: 3500.00,
      journal_id: bankJournalId, // Resolve payment-compatible journal
      payment_method_line_id: paymentMethodLineId,
    },
  ]], { context: paymentCtx });

  // Execute the wizard to create the payment
  await callOdoo('account.payment.register', 'action_create_payments', [[wizardId]], { context: paymentCtx });

  return wizardId;
}
```

### 4. Journal Entries
```typescript
async function createJournalEntry() {
  const moveId = await callOdoo('account.move', 'create', [[
    {
      move_type: 'entry',
      date: '2026-03-31',
      ref: 'Month-end accrual',
      journal_id: generalJournalId, // Resolve for target company
      line_ids: [
        [0, 0, {
          name: 'Accrued revenue',
          account_id: accruedRevenueAccountId, // Resolve for company
          debit: 5000.00,
          credit: 0,
        }],
        [0, 0, {
          name: 'Revenue',
          account_id: revenueAccountId, // Resolve for company and chart of accounts
          debit: 0,
          credit: 5000.00,
        }],
      ],
    },
  ]]);

  await callOdoo('account.move', 'action_post', [[moveId]]);
  return moveId;
}
```

### 5. Chart of Accounts
```typescript
async function getChartOfAccounts() {
  const accountIds = await callOdoo('account.account', 'search', [
    [['deprecated', '=', false]],
  ], { limit: 500 });

  const accounts = await callOdoo('account.account', 'read', [accountIds], {
    fields: ['code', 'name', 'account_type', 'current_balance', 'reconcile'],
  });
  return accounts;
}

async function createAccount() {
  const accountId = await callOdoo('account.account', 'create', [[
    {
      code: '620100',
      name: 'Software Subscriptions',
      account_type: 'expense',
      reconcile: false,
    },
  ]]);
  return accountId;
}
```

## Best Practices

1. **Use `search_read` for efficiency** — Combines `search` and `read` in one call: `callOdoo('res.partner', 'search_read', [domain], { fields: ['name', 'email'], limit: 50 })`.
2. **Understand the `[command, id, vals]` tuple syntax** — For One2many/Many2many fields: `[0, 0, vals]` creates, `[1, id, vals]` updates, `[2, id, 0]` deletes, `[6, 0, ids]` replaces all.
3. **Use API keys instead of passwords** — Odoo 14+ supports API keys that are more secure and can be revoked independently.
4. **Always check `move_type`** — `out_invoice` (customer invoice), `in_invoice` (vendor bill), `out_refund` (credit note), `entry` (journal entry).
5. **Handle Odoo versions** — Model and field names change between versions. Version-check at connection time.

## Common Pitfalls

- **`account.invoice` doesn't exist in Odoo 13+** — It was merged into `account.move`. Use `account.move` with `move_type` filter.
- **XML-RPC returns Python-style data** — `False` instead of `null`, integers for IDs, dates as strings.
- **Draft invoices don't affect accounting** — You must call `action_post` to post an invoice and create ledger entries.
- **Currency must match journal** — If the journal is in USD, you can't create entries in EUR without a multi-currency setup.

## Anti-Patterns

- **Calling `read` without specifying `fields`** — Returns ALL fields, which is extremely slow for complex models.
- **Creating journal entries for standard transactions** — Use `account.move` with proper `move_type` instead of raw journal entries.
- **Not caching the UID** — `authenticate` is called on every request if you don't cache. Authenticate once and reuse.
- **Ignoring access rights** — Odoo enforces record-level security. The API user needs proper access groups for accounting models.

## Technical audit acceptance checks (2026-10-31)

- **Skill-specific objective:** Odoo accounting integrations, invoices, payments, partners, journal entries and version-specific migration from legacy XML-RPC/JSON-RPC to JSON-2 (verify inputs, the user's intended output, and reproducible acceptance evidence).
- **Domain correctness:** Verify the installed ERP version, accounting localization, currencies, chart-of-accounts IDs, transaction posting and reconciliation paths.
- **Failure and assurance:** Test authorization, rollback/idempotency, audit trails, and reconciled balances in a sandbox before any posting or payment.
- **External integrations:** Treat vendor-specific API capabilities and example payloads as version-dependent. Pin documentation/schema versions and validate permissions and side effects against a sandbox before production.
- **Code examples:** Examples require dependency/version pinning, dry runs, credential separation, and integration tests; Markdown formatting is not evidence of compilability or live execution.
