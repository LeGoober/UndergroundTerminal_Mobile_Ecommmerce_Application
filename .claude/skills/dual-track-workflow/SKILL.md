---
name: dual-track-workflow
description: Underground Terminal's dual-track delivery workflow — internal MVP engineering vs stakeholder-facing marketing/mockups. Use when planning a release, building a pitch or mock for stakeholders/sponsors/clients (including white-label reskins for other pitches), scoping new platform features, or deciding which skill/connector to chain for a task.
---

# Dual-Track Delivery Workflow — Underground Terminal

Underground Terminal is a B2B ecommerce platform for the luxury fashion &
cosmetics sector: verified suppliers, buyers and designers; secure
transactions; real-time logistics; inventory management. Every piece of work
belongs to one of two tracks. Name the track before starting.

## Track 1 — Internal system (the product)

Spring Boot 3 backend (Java 17, JPA, JWT + OAuth2, minimal third-party deps —
prefer what Spring already ships) + Flutter mobile app (Provider state,
dark luxury theme in `mobile/lib/theme/app_theme.dart`).

- **Branches:** `feature/*` → `dev` (CI) → `staging` (Render pre-prod) →
  `prod` (Render production). Never commit feature work straight to
  staging/prod.
- **Skill chain:** implement → `code-reviewer` (structured review) →
  built-in `/code-review` + `verify` before promoting a branch.
- **Rule:** new capabilities extend the existing entity → repository →
  service → controller pattern. No new dependency unless Spring/Flutter
  can't do it natively.

## Track 2 — External marketing (the story)

Stakeholder-facing assets that show the platform's value: the marketing mock,
pitch decks, sponsor material.

- **Source of truth:** `marketing/index.html` — single-file, white-label.
  Brand tokens live in the `:root` CSS block; demo content in the single
  `DEMO_DATA` script object; wordmark marked with `data-brand`. To reskin
  for another pitch (e.g. a clothing brand or services client), copy the
  file and change only those three surfaces.
- **Skill chain:** `frontend-design` (direction, anti-slop) →
  `ui-ux-pro-max` / `ui-styling` (refinement) → `dataviz` (any chart) →
  browser screenshot critique before shipping.
- **Deploys:** `marketing` branch → Render static site
  (`underground-terminal-marketing` in render.yaml), independent of the
  app pipeline.
- **Honesty rule:** demo figures are always labeled illustrative; feature
  claims must map to what the backend actually supports.

## Connector map

| Need | Use |
|---|---|
| Design source-of-truth, design↔code sync | Figma MCP (authenticated) |
| Pitch deck, brand kit, social resizes | Canva connector |
| Shareable live mock | Render static site from `marketing` branch |
| Reproducibility / review | GitHub branches + PRs |

## Scoping ritual (before building anything)

Run a short Q&A with Rorisang covering, at minimum:
1. Which track is this? (product vs story)
2. Minimum deliverable that impresses the audience (stakeholder, sponsor,
   client) — live URL beats slides beats documents.
3. What existing backend capability grounds the claim? If none, either
   build it on Track 1 first or label it illustrative on Track 2.
4. Where does it deploy, and on which branch?

Feed stakeholder feedback from Track 2 back into the Track 1 roadmap each
cycle; abstract shipped Track 1 features into Track 2 visuals.
