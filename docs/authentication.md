# Authentication
Bullet Train uses [Devise](https://github.com/heartcombo/devise) for authentication and we've done the work of making the related views look pretty and well-integrated with the look-and-feel of the application template.

## Related Files

Devise is very well documented elsewhere, so we'll simply direct you to the places where it lives and is integrated in a Bullet Train application.

### Configuration
 - `config/initializers/devise.rb`
 - `devise_for :users` in `config/routes.rb`

### Customized Controllers
 - `app/controllers/registrations_controller.rb`
   - We've added some additional functionality to the registrations controller in support of Bullet Train's invitation system and invitation-only sign-up system.

### Views
 - Surrounding layout: `app/views/layouts/devise.html.erb`
 - Sign-in form: `app/views/devise/sessions/new.html.erb`
 - Sign-up form: `app/views/devise/registrations/new.html.erb`
 - Forgot password form: `app/views/devise/registrations/new.html.erb`
 - Reset password form: `app/views/devise/passwords/edit.html.erb`
 - Additional views:  `app/views/devise/*`

## Related Topics
 - [Authentication with Third-Party OAuth Providers](/docs/oauth.md)
