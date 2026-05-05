# SaaS Template

A domain-neutral multi-tenant SaaS starter built on Rails 8 + React 19, with tenant-aware auth, subdomain routing, and a custom CoreUI-based admin shell.

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

## How to Use

Use this repo as the starting point for a new SaaS. Two paths:

**Option 1 — GitHub "Use this template" button** (cleanest, no history)

1. On GitHub, click **Use this template → Create a new repository**.
2. `git clone git@github.com:<your-account>/<new-product>.git && cd <new-product>`
3. Run the customization checklist below.

**Option 2 — Clone + re-point the remote**

```sh
git clone git@github.com:limjinsun/saas-template.git my-new-product
cd my-new-product
git remote set-url origin git@github.com:<your-account>/my-new-product.git
git push -u origin main
```

### Local setup

```sh
bundle install
npm install
cp .env.example .env   # then fill in DB URLs and RESEND_API_KEY
bin/rails db:create db:migrate
npm run build:admin    # build the React admin shell once
foreman start -f Procfile.dev
```

The active admin UI lives at `http://<subdomain>.lvh.me:3000/v2/adminFrame`.

## Customization Checklist

Things to swap when starting a new product on this base:

1. **Branding**
   - `public/marketing/saas-template-logo.svg`, `saas-template-icon.svg` — replace with your logo/icon (and update the `src` paths in `engines/engine_b/app/javascript/admin_frame/entry.jsx`)
   - `public/400.html` `404.html` `406-unsupported-browser.html` `422.html` — title tags + brand spans
   - `app/views/layouts/application_marketing.html.erb` — meta tags / OG tags
   - `app/views/home/index.html.erb` — landing copy and feature cards

2. **App name**
   - `package.json` → `"name"`
   - `config/database.yml` → `SAAS_TEMPLATE_DATABASE_URL_*` env variable names
   - `.env.example` → matching env variable names

3. **Email**
   - `.env` → `APP_EMAIL_FROM_NAME`, `APP_EMAIL_FROM_ADDRESS`
   - `RESEND_API_KEY` (used by `app/lib/template_http/api_clients/resend.rb` for OTP emails)

4. **Domain**
   - `.env` → `APP_CANONICAL_HOST`
   - Devise email routing in `config/initializers/devise.rb`

5. **Deploy**
   - `config/deploy.yml` (Kamal)
   - `render.yaml` (Render)
   - Set `SAAS_TEMPLATE_DATABASE_URL_STAGING` / `_PRODUCTION` in your deploy env

## Architecture

Database URLs are environment-scoped via env variables (no per-field config):

| Env         | Variable                                  |
| ----------- | ----------------------------------------- |
| development | `SAAS_TEMPLATE_DATABASE_URL_DEVELOPMENT`  |
| test        | `SAAS_TEMPLATE_DATABASE_URL_TEST`         |
| staging     | `SAAS_TEMPLATE_DATABASE_URL_STAGING`      |
| production  | `SAAS_TEMPLATE_DATABASE_URL_PRODUCTION`   |

The active admin UI is served from:
- `engines/engine_b/app/javascript/admin_frame/entry.jsx` — React shell
- `engines/engine_b/app/views/engine_b/admin_frame/index.html.erb` — mount point
- `engines/engine_b/app/controllers/engine_b/admin_frame_controller.rb` — Rails entry
- `engines/engine_b/app/controllers/engine_b/template_controller.rb` — bootstrap payload

## Building Out The Product

Use the template in this order:

1. Rename the product in template payloads and layout copy first.
2. Replace the mock `customers`, `projects`, and `activity` data exposed by `EngineB::TemplateController#bootstrap`.
3. Keep tenant and subdomain boundaries intact while introducing your own domain models.
4. Add real resources behind the admin shell one screen at a time instead of rewriting the whole UI at once.

Guardrails:
- Keep CoreUI imports local to `engines/engine_b/app/javascript/admin_frame/coreui/`.
- Keep all Tailwind utilities prefixed with `tw-` inside the admin shell.
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
