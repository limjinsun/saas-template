# Template Working Notes

This repository is a generic multi-tenant SaaS template cloned from a production-style Rails app.

Current intent:
- keep the tenant/subdomain foundation
- keep the custom React admin shell
- keep local CoreUI components under `engines/engine_b/app/javascript/admin_frame/coreui/`
- keep the app usable with mock data before any business domain is chosen

Current phase:
- template extraction
- domain-neutral cleanup
- preserve launch-ready Rails structure without reintroducing domain-specific assumptions

Non-negotiable rules:
- do not modify the original source project outside this repo copy
- import CoreUI from local files, never from `@coreui/react`
- all Tailwind utility classes must use the `tw-` prefix
- do not run database migrations without explicit user confirmation
- do not force-push
- never run `git reset --hard`
- never run `rm -rf`

Active app boundary:
- `engines/engine_b` is the active product shell

Template target:
- tenant-aware Rails app
- React admin shell mounted at `/v2/adminFrame`
- mock dashboard, mock customers/projects/activity pages
- neutral branding and copy

Immediate next work:
- keep removing residual domain-specific code and files
- document how to start a new SaaS from this base
