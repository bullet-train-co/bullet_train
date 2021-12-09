# Roles, Permissions, Abilities, and Authorization

## CanCanCan

Bullet Train leans heavily on [CanCanCan](https://github.com/CanCanCommunity/cancancan) for implementing authorization and permissions. (We’re also proud sponsors of its ongoing maintenance.) The original CanCan library by Ryan Bates was, in our opinion, a masterpiece and a software engineering marvel that has stood the test of time. It's truly a diamond among Ruby Gems. If you're not already familiar with CanCanCan, you should [read its documentation](https://github.com/CanCanCommunity/cancancan) to get familiar with its features and DSL.

## Additional Abstraction

Over many years of successfully implementing applications with CanCanCan, it became apparent to us that a supplemental level of abstraction could help streamline and simplify the definition of many common permissions, especially in large applications. However, should you encounter situations where this abstraction doesn't meet your specific needs, you can always implement the permissions you need using standard CanCanCan directives in `app/models/ability.rb`.

## Domain Model Overview

- A `User` belongs to a `Team` via a `Membership`.
- A `User` only has one `Membership` per team.
- A `Membership` can have zero, one, or many `Role`s assigned.
- A `Membership` without a `Role` is just a default team member.

## Configuration

Bullet Train's `Role` model is backed by a Yaml configuration in `config/models/roles.yml`.

To help explain this configuration and it's options, we'll provide the following hypothetical example:

```
default:
  models:
    Project: read
    Billing::Subscription: read

editor:
  manageable_roles:
    - editor
  models:
    Project: manage

billing:
  manageable_roles:
    - billing
  models:
    Billing::Subscription: manage

admin:
  includes:
    - editor
    - billing
  manageable_roles:
    - admin
```

Here's a breakdown of the structure of the configuration file:

 - `default` represents all permissions that are granted to any active member on a team.
 - `editor`, `billing`, and `admin` represent additional roles that can be assigned to a membership.
 - `models` provides a list of resources that members with a specific role will be granted.
 - `manageable_roles` provides a list of roles that can be assigned to other users by members that have the role being defined.
 - `includes` provides a list of other roles whose permissions should also be made available to members with the role being defined.
 - `manage`, `read`, etc. are all CanCanCan-defined actions that can be granted.

The following things are true given the example configuration above:

 - By default, users on a team are read-only participants.
 - Users with the `editor` role:
   - can give other users the `editor` role.
   - can modify project details.
 - Users with the `billing` role:
   - can give other users the `billing` role.
   - can create and update billing subscriptions.
 - Users with the `admin` role:
   - inherit all the privileges of the `editor` and `billing` roles.
   - can give other users the `editor`, `billing`, or `admin` role. (The ability to grant `editor` and `billing` privileges is inherited from the other roles listed in `includes`.)

### Assigning Multiple Actions per Resource

You can also grant more granular permissions by supplying a list of the specific actions per resource, like so:

```
editor:
  models:
    project:
      - read
      - update
```

## Applying Configuration

All of these definitions are interpreted and translated into CanCanCan directives when we invoke the following Bullet Train helper in `app/models/ability.rb`:

```
permit user, through: :memberships, parent: :team
```

In the example above:

 - `through` should reference a collection on `User` where access to a resource is granted. The most common example is the `memberships` association, which grants a `User` access to a `Team`. **In the context of `permit` discussions, we refer to the `Membership` model in this example as "the grant model".**
 - `parent` should indicate which level the models in `through` will grant a user access at. In the case of a `Membership`, this is `team`.

 The `permit` helper is some of the highest-leverage magic we provide in Bullet Train and we're sympathetic to developers who want to understand the magic they're employing, so we've provided as much of that as we can inline as code comments in the implementation itself.

## Additional Grant Models

To illustrate the flexibility of this approach, consider that you may want to grant non-administrative team members different permissions for different `Project` objects on a `Team`. In that case, `permit` actually allows us to re-use the same role definitions to assign permissions that are scoped by a specific resource, like this:

```
permit user, through: :projects_collaborators, parent: :project
```

In this example, `permit` is smart enough to only apply the permissions granted by a `Projects::Collaborator` record at the level of the `Project` it belongs to. You can turn any model into a grant model by adding `include Roles::Support` and adding a `role_ids:jsonb` attribute. You can look at `Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator` for an example.

## Additional Notes

### Caching
Because abilities are being evaluated on basically every request, it made sense to introduce a thin layer of caching to help speed things up. When evaluating permissions, we store a cache of the result in the `ability_cache` attribute of the `User`. By default, making changes to a model that includes the `Roles::Support` concern will invalidate that user's cache.

### Debugging
If you want to see what CanCanCan directives are being created by your permit calls, you can add the `debug: true` option to your `permit` statement in `app/models/ability.rb`.

Likewise, to see what abilities are being added for a certain user, you can run the following on the Rails console:

```
user = User.first
Ability.new(user).permit user, through: :projects_collaborators, parent: :project, debug: true
```

### Naming and Labeling
What we call a `Role` in the domain model is referred to as “Special Privileges” in the user-facing application. You can rename this to whatever you like in `config/locales/en/roles.en.yml`.

## Note About Pundit
There’s nothing stopping you from utilizing Pundit in a Bullet Train project for specific hard-to-implement cases in your permissions model, but you wouldn’t want to try and replace CanCanCan with it. We do too much automatically with CanCanCan for that to be recommended. That said, in those situations where there is a permission that needs to be implemented that isn’t easily implemented with CanCanCan, consider just writing vanilla Ruby code for that purpose.
