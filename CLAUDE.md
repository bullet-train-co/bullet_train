# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bullet Train is a Rails 8 SaaS application template/starter kit. It provides pre-built functionality (authentication, teams, invitations, roles, API, webhooks, admin panel) via a suite of `bullet_train-*` gems all locked to the same version (currently 1.39.0 in `BULLET_TRAIN_VERSION`).

## Relationship to bullet_train-core

This repo is the **application shell**. The vast majority of Bullet Train's logic lives in the [bullet_train-core](https://github.com/bullet-train-co/bullet_train-core) monorepo, which contains all the `bullet_train-*` gems (bullet_train, bullet_train-api, bullet_train-super_scaffolding, bullet_train-themes-light, etc.).

**What this means in practice:**
- Models here (User, Team, Membership) are thin wrappers that `include` concerns like `Users::Base`, `Teams::Base`, `Memberships::Base` — those concerns are defined in bullet_train-core, not here.
- Controllers follow the same pattern: `ApplicationController` includes `Controllers::Base`, `Account::ApplicationController` includes `Account::Controllers::Base` — all defined in the core gems.
- Routes for built-in resources (users, teams, memberships, invitations, etc.) are defined in the gems. This repo's `config/routes.rb` uses `extending` (`only: []`) to re-open those route blocks for customization.
- Views, partials, and helpers for built-in features also come from the gems.
- The CSS pipeline compiles from theme gem source: `bin/link` creates symlinks in `tmp/gems/` pointing to installed gem paths, and PostCSS reads from `tmp/gems/bullet_train-themes-light/`.
- The esbuild config resolves theme JavaScript entry points via `bundle exec bin/theme javascript <theme>`.

**When you can't find the implementation of something in this repo, it's almost certainly in bullet_train-core.** Look at the included concern name (e.g., `Users::Base`) and find it in the corresponding gem within the core repo.

For local core gem development, cloned core gems can be placed in `local/` (gitignored, and excluded from StandardRB via `.standard.yml`).

## Key Commands

### Development
- `bin/dev` — Start all dev processes (Rails server, Sidekiq, esbuild, Tailwind CSS) via overmind/foreman
- `bin/setup` — Full project setup (Ruby, Node, DB, assets)
- `bin/super-scaffold` — Code generation tool for CRUD resources
- `bin/link` — Create theme symlinks needed for CSS compilation

### Testing
- `rails test` — Run all unit/controller tests
- `rails test:system` — Run system tests (Capybara + Selenium)
- `rails test test/models/user_test.rb` — Run a single test file
- `rails test test/models/user_test.rb:15` — Run a specific test by line number

### Linting
- `bundle exec standardrb` — Check Ruby code formatting
- `bundle exec standardrb --fix` — Auto-fix Ruby formatting issues

### Database
- `bin/db_schema_check` — Validate migrations don't cause unexpected schema changes

## Architecture

### Multi-Tenancy Model
The core domain model is **User → Membership → Team**. Teams are the tenancy boundary. Most application resources belong to a Team (either directly or through nesting). Users access teams through Memberships, which carry role information.

### Super Scaffolding Markers
Files contain `# 🚅` marker comments that indicate insertion points for the `bin/super-scaffold` code generator. Do not remove these comments — they are required for code generation to work.

### Route Organization
Routes are split across `config/routes/*.rb` files and loaded via `draw`:
- `config/routes.rb` — Main routes with three namespaces: `public` (unauthenticated), `account` (authenticated), `api`
- `config/routes/api/v1.rb` — API routes
- `config/routes/devise.rb`, `sidekiq.rb`, `avo.rb`, `concerns.rb` — Feature-specific routes

Routes use `shallow` nesting and an `extending` pattern (`only: []`) to allow app-level route files to extend routes already defined in Bullet Train gems.

### Frontend Stack
- **Hotwire**: Turbo + Stimulus for interactivity
- **Tailwind CSS v4** with PostCSS, compiled from theme gem source via `bin/link` symlinks
- **esbuild** for JavaScript bundling with theme-aware entry points
- **Propshaft** as the asset pipeline

### Background Jobs
Sidekiq for background processing. In tests, Sidekiq runs inline (`Sidekiq::Testing.inline!`).

### API Layer
RESTful JSON API under `/api/v1/` with Doorkeeper OAuth2 authentication.

### Admin Panel
Avo (v3+) for admin interface. Avo resources live in `app/avo/`. Avo code is excluded from test coverage by default.

## Testing Details

- **Framework**: Minitest with FactoryBot for test data
- **System tests**: Capybara with Selenium WebDriver (Chrome)
- **CI**: GitHub Actions with parallel test execution via Knapsack Pro
- Seeds are loaded in the test environment by default (`test_helper.rb`)
- `FactoryBot::Syntax::Methods` is included globally in `ActiveSupport::TestCase`

## CI Pipeline

GitHub Actions runs on PRs: Minitest (parallelized), StandardRB lint, and database schema check.

## StandardRB Configuration

`.standard.yml` ignores trailing comma rules globally and has relaxed rules for `config/environments/` files to minimize merge conflicts during Rails upgrades.
