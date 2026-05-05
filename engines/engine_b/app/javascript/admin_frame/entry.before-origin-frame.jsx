import React, { startTransition, useDeferredValue, useEffect, useMemo, useState } from 'react';
import { createRoot } from 'react-dom/client';
import './coreui/coreui.css';
import {
  CAvatar,
  CBadge,
  CBreadcrumb,
  CBreadcrumbItem,
  CButton,
  CCard,
  CCardBody,
  CCardHeader,
  CCol,
  CContainer,
  CDropdown,
  CDropdownDivider,
  CDropdownItem,
  CDropdownMenu,
  CDropdownToggle,
  CFooter,
  CFormInput,
  CHeader,
  CHeaderBrand,
  CHeaderNav,
  CHeaderToggler,
  CInputGroup,
  CInputGroupText,
  CNavItem,
  CProgress,
  CProgressBar,
  CRow,
  CSidebar,
  CSidebarBrand,
  CSidebarFooter,
  CSidebarHeader,
  CSidebarNav,
  CSidebarToggler,
  CTable,
  CTableBody,
  CTableDataCell,
  CTableHead,
  CTableHeaderCell,
  CTableRow,
} from './coreui';
import CIcon from '@coreui/icons-react';
import {
  cilBell,
  cilFolderOpen,
  cilHistory,
  cilMenu,
  cilPeople,
  cilSearch,
  cilSettings,
  cilSpeedometer,
  cilUser,
} from '@coreui/icons';

const customStyles = document.createElement('style');
customStyles.textContent = `
  :root {
    --ui-font: 'Sora', sans-serif;
    --ui-num-font: 'Oxanium', sans-serif;
    --app-ink: #132235;
    --app-text: #26364a;
    --app-accent: #173f62;
    --app-accent-hover: #12334f;
    --app-accent-active: #0e273d;
    --app-accent-light: #2f6897;
    --app-accent-bright: #5e98c7;
    --app-accent-rgb: 23, 63, 98;
    --app-stone: #627487;
    --app-stone-light: #8c9daf;
    --app-stone-ring: #bcc6d2;
    --app-border: #cbd7e2;
    --app-border-light: #d4dee8;
    --app-bg: #f8fafc;
    --app-bg-body: #eef3f8;
    --app-bg-header: #f4f8fb;
    --app-th-color: #718397;
  }

  body, .sidebar, .header, .card, .table, .btn, .badge, .nav-link, .breadcrumb, .form-control, .form-select, .dropdown-menu {
    font-family: var(--ui-font);
  }

  .wrapper {
    width: 100%;
    padding-inline: var(--cui-sidebar-occupy-start, 0) var(--cui-sidebar-occupy-end, 0);
    will-change: auto;
    transition: padding .15s;
  }

  .header > .container-fluid, .sidebar-header { min-height: calc(4rem + 1px); }
  .header > .container-fluid + .container-fluid { min-height: 3rem; }
  .sidebar-brand-full { margin-left: 3px; }
  .sidebar-toggler { margin-inline-start: auto; }
  .sidebar-narrow .sidebar-toggler,
  .sidebar-narrow-unfoldable:not(:hover) .sidebar-toggler { margin-inline-end: auto; }
  .footer { min-height: calc(3rem + 1px); }

  @media (min-width: 992px) {
    .sidebar:not(.hide):not(.sidebar-narrow):not(.sidebar-narrow-unfoldable):not(.sidebar-overlaid):not(.sidebar-end) ~ * {
      --cui-sidebar-occupy-start: 15rem !important;
    }
  }

  :root {
    --cui-body-bg: var(--app-bg);
    --cui-tertiary-bg: var(--app-bg-body);
    --cui-secondary-bg: #e4ecf4;
    --cui-border-color: var(--app-border);
    --cui-card-bg: #ffffff;
    --cui-body-color: var(--app-text);
    --cui-secondary-color: var(--app-stone);
    --cui-tertiary-color: var(--app-stone-light);
    --cui-primary: var(--app-accent);
    --cui-primary-rgb: var(--app-accent-rgb);
  }

  .form-control::placeholder { color: var(--app-stone-ring) !important; opacity: 1; }
  .tw-text-slate-800 { color: var(--app-ink) !important; }
  .tw-text-slate-700 { color: var(--app-text) !important; }
  .tw-text-slate-600 { color: var(--app-stone) !important; }
  .tw-text-slate-500 { color: var(--app-stone-light) !important; }
  .tw-text-slate-400 { color: var(--app-stone-ring) !important; }
  .tw-bg-slate-100 { background-color: rgba(var(--app-accent-rgb), 0.08) !important; }
  .tw-bg-slate-50 { background-color: var(--app-bg) !important; }
  .tw-border-stone-200, .tw-border-slate-200 { border-color: var(--app-border) !important; }

  body {
    background-color: var(--app-bg-body);
    color: var(--app-text);
  }

  .sidebar {
    --cui-sidebar-width: 15rem;
    --cui-sidebar-bg: var(--app-bg);
    --cui-sidebar-border-color: var(--app-border);
    --cui-sidebar-nav-link-color: var(--app-stone);
    --cui-sidebar-nav-link-active-bg: rgba(var(--app-accent-rgb), 0.1);
    --cui-sidebar-nav-link-active-color: var(--app-accent);
    --cui-sidebar-nav-link-hover-bg: rgba(var(--app-accent-rgb), 0.06);
    --cui-sidebar-nav-link-hover-color: var(--app-ink);
    --cui-sidebar-nav-title-color: var(--app-stone-light);
    --cui-sidebar-toggler-bg: rgba(0, 0, 0, 0.03);
    --cui-sidebar-toggler-hover-bg: rgba(0, 0, 0, 0.06);
    --cui-sidebar-brand-color: var(--app-ink);
    --cui-sidebar-nav-link-icon-color: var(--app-stone-light);
    --cui-sidebar-nav-link-active-icon-color: var(--app-accent);
  }

  .sidebar .nav-link.active {
    background: rgba(var(--app-accent-rgb), 0.1) !important;
    color: var(--app-accent) !important;
  }

  .sidebar .nav-link { padding: 0.5rem 1rem; font-size: 13.5px; }
  .sidebar-narrow .nav-link,
  .sidebar-narrow-unfoldable:not(:hover) .nav-link { padding-left: 0.425rem; }
  .sidebar .nav-icon { color: var(--app-stone-light); }
  .sidebar .nav-link.active .nav-icon { color: var(--app-accent) !important; }
  .sidebar-header {
    background: var(--app-bg);
    border-bottom-color: var(--app-border);
  }
  .sidebar-footer { background: var(--app-bg); }

  .header {
    background: var(--app-bg-header);
    border-bottom-color: var(--app-border-light);
  }

  .card {
    border-color: var(--app-border);
    box-shadow: none;
  }

  .table {
    --cui-table-bg: transparent;
    --cui-table-border-color: var(--app-border);
    --cui-table-hover-bg: rgba(var(--app-accent-rgb), 0.04);
    --cui-table-striped-bg: rgba(var(--app-accent-rgb), 0.02);
    color: var(--app-text);
  }

  .table thead th {
    color: var(--app-th-color);
    font-size: 11px;
    border-bottom-color: var(--app-border-light);
  }

  .num { font-family: var(--ui-num-font); font-variant-numeric: tabular-nums; }

  a, .nav-link, .breadcrumb-item a, .page-link { color: var(--app-stone); }
  a:hover, .nav-link:hover, .breadcrumb-item a:hover { color: var(--app-ink); }
  .nav-link.active { color: var(--app-ink) !important; }

  .breadcrumb {
    --cui-breadcrumb-divider-color: var(--app-stone-ring);
    --cui-breadcrumb-active-color: var(--app-stone-light);
  }

  .btn-primary {
    --cui-btn-bg: var(--app-accent);
    --cui-btn-border-color: var(--app-accent);
    --cui-btn-hover-bg: var(--app-accent-hover);
    --cui-btn-hover-border-color: var(--app-accent-hover);
    --cui-btn-active-bg: var(--app-accent-active);
    --cui-btn-active-border-color: var(--app-accent-active);
  }

  .btn-outline-primary {
    --cui-btn-color: var(--app-accent);
    --cui-btn-border-color: var(--app-accent);
    --cui-btn-hover-bg: var(--app-accent);
    --cui-btn-hover-border-color: var(--app-accent);
  }

  .form-control {
    --cui-input-bg: #ffffff;
    --cui-input-border-color: var(--app-border-light);
    border-color: var(--app-border-light);
  }

  .form-control:focus {
    border-color: var(--app-accent-light);
    box-shadow: 0 0 0 0.25rem rgba(var(--app-accent-rgb), 0.15);
  }

  .template-hero {
    background:
      linear-gradient(135deg, rgba(23, 63, 98, 0.94), rgba(47, 104, 151, 0.94));
    color: #f7fbff;
    overflow: hidden;
    position: relative;
  }

  .template-hero::after {
    content: '';
    position: absolute;
    inset: auto -8% -35% auto;
    width: 18rem;
    height: 18rem;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.05);
  }

  .template-kpi {
    border: 1px solid var(--app-border);
    border-radius: 0.5rem;
    background: #ffffff;
  }

  .template-chip {
    border: 1px solid rgba(255, 255, 255, 0.14);
    background: rgba(255, 255, 255, 0.08);
    color: #f7fbff;
  }

  .template-note {
    border: 1px solid var(--app-border);
    background: var(--app-bg);
  }

  .badge.bg-success { background-color: #5a8f6b !important; }
  .badge.bg-danger { background-color: #b5564e !important; }
  .badge.bg-warning { background-color: #c49a4a !important; color: #fff !important; }

  .avatar.bg-success { background-color: #5a8f6b !important; }
  .avatar.bg-danger { background-color: #b5564e !important; }
  .avatar.bg-warning { background-color: #c49a4a !important; }
  .avatar.bg-info { background-color: var(--app-accent-bright) !important; }

  .tooltip-inner { max-width: 360px; text-align: left; }
  .tooltip { pointer-events: none; }

  .nav-item.dropdown { list-style: none; }

  .num { font-family: var(--ui-num-font); font-variant-numeric: tabular-nums; font-weight: 400 !important; }

  .header.tw-shadow-sm {
    box-shadow: 0 2px 8px rgba(15, 29, 47, 0.08) !important;
  }

  @keyframes deal-card-flash {
    0%, 100% { border-color: var(--app-border-light); }
    50% { border-color: var(--app-accent); background: rgba(23, 63, 98, 0.06); box-shadow: 0 0 8px rgba(23, 63, 98, 0.35); }
  }

  .deal-card-new { animation: deal-card-flash 1.2s ease-in-out 3; }
`;
document.head.appendChild(customStyles);

const currency = (value) =>
  '$' + Number(value).toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 });

const STATUS_COLORS = {
  Healthy: { background: '#ecfdf5', color: '#0f766e', border: '#8bd4c3' },
  AtRisk: { background: '#fff7ed', color: '#c2410c', border: '#f6b37a' },
  Draft: { background: '#f1f5f9', color: '#475569', border: '#bcc7d3' },
  Live: { background: '#eff6ff', color: '#1d4ed8', border: '#a9c2f2' },
  Planned: { background: '#f8fafc', color: '#64748b', border: '#ced7e1' },
};

const statusBadge = (status) => {
  const tone = STATUS_COLORS[status] || STATUS_COLORS.Planned;
  return (
    <CBadge
      style={{ backgroundColor: tone.background, color: tone.color, border: `1px solid ${tone.border}` }}
      shape="rounded-pill"
    >
      {status}
    </CBadge>
  );
};

const FALLBACK_BOOTSTRAP = {
  brand: { name: 'SaaS Template', tagline: 'Multi-tenant shell' },
  metrics: [
    { label: 'Active workspaces', value: '24', meta: '+3 this month' },
    { label: 'MRR tracked', value: '$48K', meta: 'Mock portfolio number' },
    { label: 'Onboarding completion', value: '81%', meta: 'Across all accounts' },
    { label: 'Automation coverage', value: '12 flows', meta: 'Placeholder ops metric' },
  ],
  customers: [
    { name: 'Northstar Ops', owner: 'Avery Kim', plan: 'Growth', health: 'Healthy', arr: 12400 },
    { name: 'Signal Peak', owner: 'Drew Patel', plan: 'Starter', health: 'Draft', arr: 2400 },
    { name: 'Tern Studio', owner: 'Lena Brooks', plan: 'Scale', health: 'Healthy', arr: 18900 },
    { name: 'Field Current', owner: 'Mason Reed', plan: 'Growth', health: 'AtRisk', arr: 8600 },
    { name: 'Blue Mesa', owner: 'Noah Park', plan: 'Starter', health: 'Live', arr: 3200 },
  ],
  projects: [
    { code: 'PRJ-101', name: 'Tenant onboarding flow', owner: 'Avery Kim', stage: 'Live', progress: 88 },
    { code: 'PRJ-108', name: 'Usage insights dashboard', owner: 'Lena Brooks', stage: 'Healthy', progress: 73 },
    { code: 'PRJ-114', name: 'Workspace settings redesign', owner: 'Drew Patel', stage: 'Draft', progress: 34 },
    { code: 'PRJ-120', name: 'Email automation pack', owner: 'Mason Reed', stage: 'Planned', progress: 16 },
  ],
  activity: [
    { when: '2 min ago', actor: 'System', action: 'Provisioned workspace', target: 'Northstar Ops' },
    { when: '18 min ago', actor: 'Avery Kim', action: 'Updated onboarding checklist', target: 'PRJ-101' },
    { when: '1 hour ago', actor: 'Lena Brooks', action: 'Invited teammate', target: 'Tern Studio' },
    { when: '3 hours ago', actor: 'Automation bot', action: 'Published usage snapshot', target: 'Blue Mesa' },
    { when: 'Yesterday', actor: 'Drew Patel', action: 'Created workspace template', target: 'Signal Peak' },
  ],
  launch_checklist: [
    { label: 'Tenant setup', value: 92 },
    { label: 'Admin shell branding', value: 68 },
    { label: 'Mock CRUD patterns', value: 74 },
    { label: 'Integration placeholder', value: 31 },
  ],
  notes: [
    'Keep tenant-aware auth and subdomain scoping. Bring your own domain models later.',
    'The admin shell stays generic on purpose: dashboard, customers, projects, activity, settings.',
    'Replace template bootstrap payloads with real resources when the business direction is chosen.',
  ],
  settings: {
    default_plan: 'Growth',
    region: 'US-East',
    timezone: 'UTC',
  },
};

const NAV_ITEMS = [
  { id: 'dashboard', label: 'Dashboard', icon: cilSpeedometer },
  { id: 'customers', label: 'Customers', icon: cilPeople },
  { id: 'projects', label: 'Projects', icon: cilFolderOpen },
  { id: 'activity', label: 'Activity', icon: cilHistory },
  { id: 'settings', label: 'Settings', icon: cilSettings },
];

const TemplateHero = ({ brand, metrics }) => (
  <CCard className="template-hero tw-border-0">
    <CCardBody className="tw-p-4 tw-p-lg-5">
      <div className="tw-flex tw-flex-col tw-gap-4 tw-gap-lg-0 tw-justify-between tw-flex-lg-row tw-align-lg-center">
        <div className="tw-max-w-2xl">
          <div className="tw-inline-flex tw-items-center tw-gap-2 tw-rounded-full tw-px-3 tw-py-1 template-chip tw-text-xs tw-font-semibold">
            <span>{brand.tagline}</span>
          </div>
          <h1 className="tw-mt-3 tw-text-3xl tw-font-semibold tw-tracking-tight">{brand.name}</h1>
          <p className="tw-mt-3 tw-text-sm tw-leading-6 tw-text-slate-200">
            A domain-neutral multi-tenant admin shell built on Rails, React, and local CoreUI components.
          </p>
        </div>
        <div className="tw-grid tw-grid-cols-2 tw-gap-3 tw-min-w-[280px]">
          {metrics.slice(0, 4).map((metric) => (
            <div key={metric.label} className="tw-rounded-xl tw-border tw-border-white/15 tw-bg-white/10 tw-p-3">
              <div className="tw-text-[11px] tw-uppercase tw-tracking-[0.08em] tw-text-slate-200">{metric.label}</div>
              <div className="num tw-mt-1 tw-text-2xl tw-font-semibold">{metric.value}</div>
              <div className="tw-mt-1 tw-text-xs tw-text-slate-200">{metric.meta}</div>
            </div>
          ))}
        </div>
      </div>
    </CCardBody>
  </CCard>
);

const DashboardView = ({ bootstrap }) => (
  <div className="tw-d-flex tw-flex-column tw-gap-4">
    <TemplateHero brand={bootstrap.brand} metrics={bootstrap.metrics} />
    <CRow className="g-4">
      {bootstrap.metrics.map((metric) => (
        <CCol key={metric.label} md={6} xl={3}>
          <CCard className="template-kpi tw-h-full">
            <CCardBody>
              <div className="tw-text-xs tw-uppercase tw-tracking-[0.08em] tw-text-slate-500">{metric.label}</div>
              <div className="num tw-mt-2 tw-text-3xl tw-font-semibold tw-text-slate-800">{metric.value}</div>
              <div className="tw-mt-2 tw-text-sm tw-text-slate-500">{metric.meta}</div>
            </CCardBody>
          </CCard>
        </CCol>
      ))}
    </CRow>
    <CRow className="g-4">
      <CCol xl={7}>
        <CCard className="tw-h-full">
          <CCardHeader className="tw-bg-white tw-font-semibold">Launch Checklist</CCardHeader>
          <CCardBody className="tw-d-flex tw-flex-column tw-gap-3">
            {bootstrap.launch_checklist.map(({ label, value }) => (
              <div key={label}>
                <div className="tw-mb-2 tw-flex tw-items-center tw-justify-between tw-text-sm">
                  <span>{label}</span>
                  <span className="num tw-text-slate-500">{value}%</span>
                </div>
                <CProgress thin>
                  <CProgressBar value={value} />
                </CProgress>
              </div>
            ))}
          </CCardBody>
        </CCard>
      </CCol>
      <CCol xl={5}>
        <CCard className="tw-h-full">
          <CCardHeader className="tw-bg-white tw-font-semibold">Template Notes</CCardHeader>
          <CCardBody className="tw-d-flex tw-flex-column tw-gap-3">
            {bootstrap.notes.map((note) => (
              <div key={note} className="template-note tw-rounded-xl tw-p-3 tw-text-sm tw-text-slate-600">{note}</div>
            ))}
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  </div>
);

const CustomersView = ({ customers, query }) => {
  const deferredQuery = useDeferredValue(query.trim().toLowerCase());
  const rows = useMemo(() => {
    return customers.filter((customer) => {
      if (!deferredQuery) return true;
      return [customer.name, customer.owner, customer.plan, customer.health].join(' ').toLowerCase().includes(deferredQuery);
    });
  }, [customers, deferredQuery]);

  return (
    <CCard>
      <CCardHeader className="tw-bg-white tw-d-flex tw-justify-between tw-align-items-center">
        <span className="tw-font-semibold">Customers</span>
        <span className="tw-text-sm tw-text-slate-500">{rows.length} mock accounts</span>
      </CCardHeader>
      <CCardBody>
        <CTable hover responsive>
          <CTableHead>
            <CTableRow>
              <CTableHeaderCell>Account</CTableHeaderCell>
              <CTableHeaderCell>Owner</CTableHeaderCell>
              <CTableHeaderCell>Plan</CTableHeaderCell>
              <CTableHeaderCell>Health</CTableHeaderCell>
              <CTableHeaderCell className="tw-text-end">ARR</CTableHeaderCell>
            </CTableRow>
          </CTableHead>
          <CTableBody>
            {rows.map((customer) => (
              <CTableRow key={customer.name}>
                <CTableDataCell><div className="tw-font-medium tw-text-slate-800">{customer.name}</div></CTableDataCell>
                <CTableDataCell>{customer.owner}</CTableDataCell>
                <CTableDataCell>{customer.plan}</CTableDataCell>
                <CTableDataCell>{statusBadge(customer.health)}</CTableDataCell>
                <CTableDataCell className="num tw-text-end">{currency(customer.arr)}</CTableDataCell>
              </CTableRow>
            ))}
          </CTableBody>
        </CTable>
      </CCardBody>
    </CCard>
  );
};

const ProjectsView = ({ projects }) => (
  <CCard>
    <CCardHeader className="tw-bg-white tw-font-semibold">Projects</CCardHeader>
    <CCardBody>
      <div className="tw-d-flex tw-flex-column tw-gap-3">
        {projects.map((project) => (
          <div key={project.code} className="tw-rounded-xl tw-border tw-border-slate-200 tw-bg-slate-50 tw-p-3">
            <div className="tw-flex tw-flex-col tw-gap-3 tw-flex-lg-row tw-justify-between">
              <div>
                <div className="tw-text-xs tw-font-semibold tw-uppercase tw-tracking-[0.08em] tw-text-slate-500">{project.code}</div>
                <div className="tw-mt-1 tw-text-lg tw-font-semibold tw-text-slate-800">{project.name}</div>
                <div className="tw-mt-1 tw-text-sm tw-text-slate-500">Owner: {project.owner}</div>
              </div>
              <div className="tw-flex tw-flex-column tw-items-start tw-items-lg-end tw-gap-2">
                {statusBadge(project.stage)}
                <div className="num tw-text-sm tw-text-slate-500">{project.progress}% complete</div>
              </div>
            </div>
            <div className="tw-mt-3">
              <CProgress thin>
                <CProgressBar value={project.progress} />
              </CProgress>
            </div>
          </div>
        ))}
      </div>
    </CCardBody>
  </CCard>
);

const ActivityView = ({ activity }) => (
  <CCard>
    <CCardHeader className="tw-bg-white tw-font-semibold">Recent Activity</CCardHeader>
    <CCardBody>
      <div className="tw-d-flex tw-flex-column tw-gap-3">
        {activity.map((item) => (
          <div key={`${item.when}-${item.actor}-${item.target}`} className="tw-flex tw-gap-3 tw-rounded-xl tw-border tw-border-slate-200 tw-bg-white tw-p-3">
            <div className="tw-mt-1">
              <CAvatar color="primary" textColor="white" size="md">{item.actor.slice(0, 1)}</CAvatar>
            </div>
            <div className="tw-flex-1">
              <div className="tw-text-sm tw-text-slate-800">
                <span className="tw-font-semibold">{item.actor}</span> {item.action.toLowerCase()} <span className="tw-font-semibold">{item.target}</span>
              </div>
              <div className="tw-mt-1 tw-text-xs tw-uppercase tw-tracking-[0.08em] tw-text-slate-500">{item.when}</div>
            </div>
          </div>
        ))}
      </div>
    </CCardBody>
  </CCard>
);

const SettingsView = ({ bootstrap }) => (
  <CRow className="g-4">
    <CCol lg={6}>
      <CCard className="tw-h-full">
        <CCardHeader className="tw-bg-white tw-font-semibold">Workspace Defaults</CCardHeader>
        <CCardBody className="tw-d-flex tw-flex-column tw-gap-3 tw-text-sm tw-text-slate-600">
          <div className="template-note tw-rounded-xl tw-p-3">
            Tenant-aware auth, subdomain handling, and admin navigation are already present. Replace these placeholders with your real settings later.
          </div>
          <div className="tw-flex tw-justify-between"><span>Default plan</span><span className="tw-font-semibold tw-text-slate-800">{bootstrap.settings.default_plan}</span></div>
          <div className="tw-flex tw-justify-between"><span>Region</span><span className="tw-font-semibold tw-text-slate-800">{bootstrap.settings.region}</span></div>
          <div className="tw-flex tw-justify-between"><span>Timezone</span><span className="tw-font-semibold tw-text-slate-800">{bootstrap.settings.timezone}</span></div>
        </CCardBody>
      </CCard>
    </CCol>
    <CCol lg={6}>
      <CCard className="tw-h-full">
        <CCardHeader className="tw-bg-white tw-font-semibold">Developer Notes</CCardHeader>
        <CCardBody className="tw-d-flex tw-flex-column tw-gap-3 tw-text-sm tw-text-slate-600">
          <div className="template-note tw-rounded-xl tw-p-3">
            Keep using local CoreUI exports under `admin_frame/coreui`. The admin shell should stay framework-consistent.
          </div>
          <div className="template-note tw-rounded-xl tw-p-3">
            Add real domain models only after deciding what business this app serves.
          </div>
        </CCardBody>
      </CCard>
    </CCol>
  </CRow>
);

const App = () => {
  const mount = document.getElementById('admin-frame-root');
  const props = mount ? JSON.parse(mount.dataset.props || '{}') : {};
  const [sidebarShow, setSidebarShow] = useState(true);
  const [sidebarUnfoldable, setSidebarUnfoldable] = useState(false);
  const [page, setPage] = useState('dashboard');
  const [query, setQuery] = useState('');
  const [bootstrap, setBootstrap] = useState(FALLBACK_BOOTSTRAP);
  const [loadError, setLoadError] = useState('');

  const pageTitle = NAV_ITEMS.find((item) => item.id === page)?.label || 'Dashboard';
  const userInitials = props.currentUser?.initials || 'ST';

  useEffect(() => {
    let cancelled = false;

    const loadBootstrap = async () => {
      if (!props.bootstrapUrl) return;

      try {
        const response = await fetch(props.bootstrapUrl, {
          headers: { Accept: 'application/json' },
          credentials: 'same-origin',
        });
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const payload = await response.json();

        if (!cancelled) {
          setBootstrap({ ...FALLBACK_BOOTSTRAP, ...payload });
          setLoadError('');
        }
      } catch (_error) {
        if (!cancelled) setLoadError('Using local fallback data because the template bootstrap endpoint was unavailable.');
      }
    };

    loadBootstrap();
    return () => { cancelled = true; };
  }, [props.bootstrapUrl]);

  const navigate = (nextPage) => {
    startTransition(() => setPage(nextPage));
  };

  return (
    <div>
      <CSidebar className="border-end" colorScheme="light" position="fixed" unfoldable={sidebarUnfoldable} visible={sidebarShow}>
        <CSidebarHeader className="border-bottom">
          <CSidebarBrand className="d-flex align-items-center gap-2 text-decoration-none mx-auto" href="#">
            <div className="tw-flex tw-h-9 tw-w-9 tw-items-center tw-justify-center tw-rounded-lg tw-text-sm tw-font-semibold tw-text-white" style={{ background: 'linear-gradient(135deg, #17324d, #3b6f90)' }}>ST</div>
            <div className="sidebar-brand-full">
              <div className="tw-text-sm tw-font-semibold tw-text-slate-800">{bootstrap.brand.name}</div>
              <div className="tw-text-[11px] tw-uppercase tw-tracking-[0.08em] tw-text-slate-500">{bootstrap.brand.tagline}</div>
            </div>
          </CSidebarBrand>
          <CSidebarToggler onClick={() => setSidebarUnfoldable((value) => !value)} />
        </CSidebarHeader>
        <CSidebarNav className="px-3 py-3">
          {NAV_ITEMS.map((item) => (
            <CNavItem key={item.id} href="#" active={page === item.id} onClick={(event) => { event.preventDefault(); navigate(item.id); }}>
              <div className="nav-link d-flex align-items-center gap-2">
                <CIcon icon={item.icon} className="nav-icon" />
                <span>{item.label}</span>
              </div>
            </CNavItem>
          ))}
        </CSidebarNav>
        <CSidebarFooter className="border-top px-3 py-3">
          <div className="tw-text-xs tw-uppercase tw-tracking-[0.08em] tw-text-slate-500">Current mode</div>
          <div className="tw-mt-1 tw-text-sm tw-font-medium tw-text-slate-800">Template shell</div>
        </CSidebarFooter>
      </CSidebar>

      <div className="wrapper d-flex flex-column min-vh-100">
        <CHeader position="sticky" className="mb-4">
          <CContainer fluid className="px-4">
            <CHeaderToggler className="ps-1" onClick={() => setSidebarShow((visible) => !visible)}>
              <CIcon icon={cilMenu} size="lg" />
            </CHeaderToggler>
            <CHeaderBrand className="mx-auto d-md-none">{bootstrap.brand.name}</CHeaderBrand>
            <CHeaderNav className="ms-auto tw-items-center tw-gap-2">
              <CInputGroup className="tw-hidden tw:w-[320px] tw-md:flex">
                <CInputGroupText><CIcon icon={cilSearch} /></CInputGroupText>
                <CFormInput placeholder="Search mock data" value={query} onChange={(event) => setQuery(event.target.value)} />
              </CInputGroup>
              <CButton color="light" variant="ghost" className="tw-border tw-border-slate-200"><CIcon icon={cilBell} /></CButton>
              <CDropdown variant="nav-item">
                <CDropdownToggle caret={false} className="tw-border-0 tw-bg-transparent tw-p-0">
                  <CAvatar color="primary" textColor="white">{userInitials}</CAvatar>
                </CDropdownToggle>
                <CDropdownMenu placement="bottom-end">
                  <CDropdownItem href="#"><CIcon icon={cilUser} className="me-2" />Profile</CDropdownItem>
                  <CDropdownDivider />
                  <CDropdownItem href="#">Template account</CDropdownItem>
                </CDropdownMenu>
              </CDropdown>
            </CHeaderNav>
          </CContainer>
          <CContainer fluid className="px-4">
            <div className="tw-flex tw-flex-col tw-gap-3 tw-py-2 tw-pb-3 tw-flex-lg-row tw-items-lg-center tw-justify-between">
              <div>
                <div className="tw-text-xs tw-uppercase tw-tracking-[0.08em] tw-text-slate-500">Admin Shell</div>
                <div className="tw-text-2xl tw-font-semibold tw-text-slate-800">{pageTitle}</div>
                {loadError && <div className="tw-mt-1 tw-text-xs tw-text-amber-600">{loadError}</div>}
              </div>
              <div className="tw-flex tw-items-center tw-gap-2">
                <CButton color="primary">Primary Action</CButton>
                <CButton color="light" className="tw-border tw-border-slate-200">Secondary Action</CButton>
              </div>
            </div>
          </CContainer>
        </CHeader>

        <div className="body flex-grow-1">
          <CContainer fluid className="px-4 pb-4">
            <CBreadcrumb className="mb-4">
              <CBreadcrumbItem href="#">Home</CBreadcrumbItem>
              <CBreadcrumbItem active>{pageTitle}</CBreadcrumbItem>
            </CBreadcrumb>
            {page === 'dashboard' && <DashboardView bootstrap={bootstrap} />}
            {page === 'customers' && <CustomersView customers={bootstrap.customers} query={query} />}
            {page === 'projects' && <ProjectsView projects={bootstrap.projects} />}
            {page === 'activity' && <ActivityView activity={bootstrap.activity} />}
            {page === 'settings' && <SettingsView bootstrap={bootstrap} />}
          </CContainer>
        </div>

        <CFooter className="px-4">
          <div className="tw-text-sm tw-text-slate-500">{bootstrap.brand.name}</div>
          <div className="ms-auto tw-text-sm tw-text-slate-500">Rails + React + local CoreUI</div>
        </CFooter>
      </div>
    </div>
  );
};

const mountNode = document.getElementById('admin-frame-root');
if (mountNode) createRoot(mountNode).render(<App />);
