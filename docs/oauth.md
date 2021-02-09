# OAuth Providers
Bullet Train implements [Omniauth](https://github.com/omniauth/omniauth) which enables [Super Scaffolding](/docs/super-scaffolding) to easily add [any of the third-party OAuth providers in its community-maintained list of strategies](https://github.com/omniauth/omniauth/wiki/List-of-Strategies) for user-level authentication and team-level integrations via API and incoming webhooks. For specific instructions on adding new OAuth providers, run the following on your shell:

```
bin/super-scaffold oauth-provider
```

## Stripe Connect Example
Similar to the `TangibleThings` template for [Super Scaffolding CRUD workflows](/docs/super-scaffolding.md), Bullet Train includes a Stripe Connect integration by default and this example also serves as a template for Super Scaffolding to implement other providers you might want to add.

## Relevant Files

You should be able to add third-party OAuth providers with Super Scaffolding without any manual effort. However, if you need to dig in, here are the files you're looking for:

### Core Functionality
 - `config.omniauth` in `config/initializers/devise.rb`
   - Third-party OAuth providers are registered at the top of this file.
 - `app/controllers/account/oauth/omniauth_callbacks_controller.rb`
   - This controller contains all the logic that executes when a user returns back to your application after working their way through the third-party OAuth provider's workflow.
 - `omniauth_callbacks` in `config/routes.rb`
   - This file just registers the above controller with Devise.
 - `app/views/devise/shared/_oauth.html.erb`
   - This partial includes all the buttons for presentation on the sign in and sign up pages.

### Stripe Connect Example and Template
 - Model: `app/models/oauth/stripe_account.rb`
 - Routes: `namespace :oauth` in `config/routes.rb`
   - Routes are defined under both `namespace :account` and `namespace :api`.
 - Controller: `app/controllers/account/oauth/stripe_accounts_controller.rb`
 - Views: `app/views/account/oauth/stripe_accounts/*`
 - Translations: `config/locales/en/oauth/stripe_accounts.en.yml`
 - See [Incoming Webhooks](/docs/webhooks/incoming.md) also.
