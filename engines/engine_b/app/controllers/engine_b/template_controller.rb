module EngineB
  class TemplateController < ApplicationController
    def bootstrap
      render json: {
        brand: {
          name: "SaaS Template",
          tagline: "Multi-tenant shell",
        },
        metrics: [
          { label: "Active workspaces", value: "24", meta: "+3 this month" },
          { label: "MRR tracked", value: "$48K", meta: "Mock portfolio number" },
          { label: "Onboarding completion", value: "81%", meta: "Across all accounts" },
          { label: "Automation coverage", value: "12 flows", meta: "Placeholder ops metric" },
        ],
        customers: [
          { name: "Northstar Ops", owner: "Avery Kim", plan: "Growth", health: "Healthy", arr: 12_400 },
          { name: "Signal Peak", owner: "Drew Patel", plan: "Starter", health: "Draft", arr: 2_400 },
          { name: "Tern Studio", owner: "Lena Brooks", plan: "Scale", health: "Healthy", arr: 18_900 },
          { name: "Field Current", owner: "Mason Reed", plan: "Growth", health: "AtRisk", arr: 8_600 },
          { name: "Blue Mesa", owner: "Noah Park", plan: "Starter", health: "Live", arr: 3_200 },
        ],
        projects: [
          { code: "PRJ-101", name: "Tenant onboarding flow", owner: "Avery Kim", stage: "Live", progress: 88 },
          { code: "PRJ-108", name: "Usage insights dashboard", owner: "Lena Brooks", stage: "Healthy", progress: 73 },
          { code: "PRJ-114", name: "Workspace settings redesign", owner: "Drew Patel", stage: "Draft", progress: 34 },
          { code: "PRJ-120", name: "Email automation pack", owner: "Mason Reed", stage: "Planned", progress: 16 },
        ],
        activity: [
          { when: "2 min ago", actor: "System", action: "Provisioned workspace", target: "Northstar Ops" },
          { when: "18 min ago", actor: "Avery Kim", action: "Updated onboarding checklist", target: "PRJ-101" },
          { when: "1 hour ago", actor: "Lena Brooks", action: "Invited teammate", target: "Tern Studio" },
          { when: "3 hours ago", actor: "Automation bot", action: "Published usage snapshot", target: "Blue Mesa" },
          { when: "Yesterday", actor: "Drew Patel", action: "Created workspace template", target: "Signal Peak" },
        ],
        launch_checklist: [
          { label: "Tenant setup", value: 92 },
          { label: "Admin shell branding", value: 68 },
          { label: "Mock CRUD patterns", value: 74 },
          { label: "Integration placeholder", value: 31 },
        ],
        notes: [
          "The original app stays untouched. This repo is the extraction workspace for a reusable SaaS shell.",
          "Keep the tenant model, admin chrome, auth assumptions, and build tooling. Replace the domain later.",
          "Next likely step: replace template bootstrap payloads with resources aligned to your product direction.",
        ],
        settings: {
          default_plan: "Growth",
          region: "US-East",
          timezone: Current.tenant&.time_zone || "UTC",
        },
      }
    end
  end
end
