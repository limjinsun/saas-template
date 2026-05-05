# EngineB

`EngineB` is the active template engine for this repository. It owns the domain-neutral admin shell mounted at `/v2/adminFrame` and exposes the mock bootstrap payload used by the React UI.

## Responsibilities

- serve the React admin frame entrypoint
- expose template bootstrap JSON for mock dashboard data
- keep local CoreUI components under `app/javascript/admin_frame/coreui/`

## Key Paths

- `app/controllers/engine_b/admin_frame_controller.rb`
- `app/controllers/engine_b/template_controller.rb`
- `app/javascript/admin_frame/entry.jsx`
- `config/routes.rb`

## Working Notes

- Keep this engine product-neutral until a new SaaS domain is chosen.
- Prefer replacing the template bootstrap payload over introducing speculative business models.
- Import CoreUI from local files only, never from `@coreui/react`.
