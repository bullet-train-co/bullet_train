# Onboarding
Bullet Train provides an easy to understand and modifiable structure for defining required onboarding steps and forms. This system makes it easy for users to complete required steps before seeing your application's full account interface. The code for this feature is well documented in the code with comments, so rather than duplicating that document here, we'll simply direct you to the relevant files.

## Included Onboarding Steps

### Collect User Details

The included "user details" onboarding step is intended to collect any fields that are required for a user account to be "complete" while not requiring those fields to be collected on the initial sign up form. This is a deliberate UX decision to try and increase conversions on the initial form.

### Collect User Email

The "user email" onboarding step is specifically used in situations where a user signs up with an OAuth provider that either doesn't supply their email address to the application or doesn't have a verified email address for the user. In this situation, we want to have an email address on their account, so we prompt them for it.

## Relevant Files

### Controllers
 - `ensure_onboarding_is_complete` in `app/controllers/account/application_controller.rb`
 - `app/controllers/account/onboarding/user_details_controller.rb`
 - `app/controllers/account/onboarding/user_email_controller.rb`

### Views
 - `app/views/account/onboarding/user_details/edit.html.erb`
 - `app/views/account/onboarding/user_email/edit.html.erb`

### Models
 - `user#details_provided?` in `app/models/user.rb`

### Routes
 - `namespace :onboarding` in `config/routes.rb`

## Adding Additional Steps
Although you can implement onboarding steps from scratch, we always just copy and paste one of the existing steps as a starting point, like so:

1. Copy, rename, and modify of the existing onboarding controllers.
2. Copy, rename, and modify the corresponding `edit.html.erb` view.
3. Copy and rename the route entry in `config/routes.rb`.
4. Add the appropriate gating logic in `ensure_onboarding_is_complete` in `app/controllers/account/application_controller.rb`

Onboarding steps aren't limited to targeting `User` models. It's possible to add onboarding steps to help flesh out team `Membership` records or `Team` records as well. You can use this pattern for setting up any sort of required data for either the user or the team.
