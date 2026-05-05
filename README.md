# SaaS Template

This repo is a domain-neutral multi-tenant SaaS starter extracted from an existing Rails codebase.

What it keeps:
- tenant-aware app structure
- subdomain-ready Rails setup
- custom React admin shell at `/v2/adminFrame`
- local CoreUI component library in `engines/engine_b/app/javascript/admin_frame/coreui/`
- mock dashboard and list views suitable for early product shaping

What it does not assume:
- no fixed business vertical
- no required industry-specific workflow
- no final product branding

## Start

Install dependencies and run the app with your usual Rails workflow. For the admin shell bundle:

```sh
npm run build:admin
```

Database defaults are intentionally separate from the original project:

- development: `saas_template_development`
- test: `saas_template_test`
- production/staging: `SAAS_TEMPLATE_DATABASE_URL`

The active admin UI is served from:

- `engines/engine_b/app/javascript/admin_frame/entry.jsx`
- `engines/engine_b/app/views/engine_b/admin_frame/index.html.erb`
- `engines/engine_b/app/controllers/engine_b/admin_frame_controller.rb`

## Starting A New SaaS From This Base

Use the template in this order:

1. Rename the product in the template payloads and layout copy first.
2. Replace the mock `customers`, `projects`, and `activity` data exposed by `EngineB::TemplateController#bootstrap`.
3. Keep tenant and subdomain boundaries intact while introducing your own domain models.
4. Add real resources behind the admin shell one screen at a time instead of rewriting the whole UI at once.

Recommended first files to change:

- `engines/engine_b/app/controllers/engine_b/template_controller.rb`
- `engines/engine_b/app/javascript/admin_frame/entry.jsx`
- `engines/engine_b/config/routes.rb`
- `app/views/layouts/application.html.erb`
- `config/database.yml`

Guardrails for template extraction:

- Keep CoreUI imports local to `engines/engine_b/app/javascript/admin_frame/coreui/`.
- Keep all Tailwind utilities prefixed with `tw-`.
- Do not run migrations until the new domain schema is intentional.
- Treat `engines/engine_b` as the active product boundary.

## Template Direction

The current template shell exposes generic mock sections:
- Dashboard
- Customers
- Projects
- Activity
- Settings

The active engine routes expose only the template shell plus template bootstrap data.
