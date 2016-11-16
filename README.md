# Shinkansen Template Application

## What's Provided

### Vanilla Rails

Anything Rails has a default for, we just work with the default. The most
notable example is using Rails' default testing framework over RSpec, which
is what I've typically used in my own projects.

### Authentication

We use `devise` for authentication and `cancancan` for authorization.

### We don't use Haml.

I love Haml. We don't use Haml by default because not everyone in the world
loves it as much as I do. Instead, the [`haml-rails` Gem](https://github.com/indirect/haml-rails)
provides an easy method to convert all your templates to Haml.

### rails_admin.

`rails_admin` provides fantastic CRUD functionality out of the box and adheres
to the constraints configured with `cancancan`. For a lot of private-facing
web applications, `rails_admin` can actually replace the need for developing
much of a UI for an application.

### Heroku.

There are some optional Heroku bindings in the application. We favor Heroku
because we feel that it's the easiest way for newcomers to deploy to and
manage production infrastructure. We would rather default to "easy" and let the
more experienced folks sort out how to get things working on their own, more
complicated infrastructure.
