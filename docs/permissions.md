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

All of these definitions are interpreted and translated into CanCanCan directives when we invoke the following Bullet Train helper in `app/models/ability.rb`:

```
permit user, through: :memberships, parent: :team
```

## role.yml syntax

We have tried to provide examples in the default role.yml file to show the different syntax styles available.
The top level key is the name of the role.
Under the models key, you add a hash of all models that that role can interact with.  Under the model's name, you can add either a string or an array.  If you just want to add a single CanCanCan action (eg manage), add that as a string.  If you want to add multiple CanCanCan actions, use an array with each action on a separate line.  Eg:

```
admin:
  models:
    team: manage
    project:
      - read
      - update
```


Roles can include other roles to inherit all their permissions.  Use the includes key and an array of roles to include (this one should always be an array).  Eg:

```
admin:
  includes:
    - editor
```

The manageable_roles key specifies which roles can be managed by the given role.  For example, say you had an editor role but you didn't want editors to be able to add other editors, you would do something like this:

```
reader:
  # Some other more basic role
  # No need to include the default role as that gets included in every role by default
  ...
editor:
  includes:
    - reader
  manageable_roles:
    - reader
admin:
  includes:
  - editor # No need to include reader here because admin inherits that through editor
  manageable_roles:
    - editor
    - admin # Roles should be able to manage themselves in most cases
```


## How the permit method works

The `permit` helper is some of the highest-leverage magic we provide in Bullet Train and we're sympathetic to developers who want to understand the magic they're employing, so we've provided that inline as code comments in the implementation itself.  Below is a basic explanation of how to use the permit method that should be enough to get you started.

The `through` parameter should be a relation on User where roles are added.  In most cases, this will be the Membership model so the :memberships relation.
The `parent` is the top level resource that all child resources belong to.  In the case of Memberships, the parent resource is the Team that they belong to.

To help illustrate, let's take another example.  In Bullet Train, we have the concept of "Collaborators" on a Creative Concept.
By default, non-admin team members can't view Creative Concepts.  They need to be added to each Creative Concept as a Collaborator.  The Collaborator model also has roles.  Collaborators can be viewers, editors and admins of a particular Creative Concept.  You can think of the Collaborator model as a Membership to a Creative Concept.

The real magic here is that you can use the same set of roles to apply to either a Membership or a Collaborator.  A Membership can be granted the admin role and it is considered an admin of the whole team.  A Collaborator can be granted the admin role and it is considered an admin of the Creative Concept.

Because we have two different models that can have roles applied, we need two calls to the permit method in the ability file.  To add the CanCanCan directives for collaborators, you would use:

```
permit user, through: :scaffolding_absolutely_abstract_creative_concepts_collaborators, parent: :creative_concept
```

Now when the permit method runs, it will create all the required CanCanCan directives to allow users access to the correct Creative Concepts they have been added to as Collaborators.

Because we use the same roles for both Membership and Collaborator, there will be some models defined in the roles that don't apply in one context or the other.  The permit method checks if a class has a certain association before adding the CanCanCan directives.  This means, if your admin role has `Team: manage`, when we come to apply the directives from a Collaborator perspective, because a team doesn't belong to a Creative Concept (the parent model for a Collaborator), we will skip that directive.  However, because a `Scaffolding::CompletelyConcrete::TangibleThing` does belong to a Creative Concept, we _would_ apply any related directives.

If you want to see what CanCanCan directives are being created by your permit calls, you can add the `print_output: true` option to the permit method.  To see what roles are being added for a certain user, run this in the console:

```
user = User.first
Ability.new(user).permit user, through: :scaffolding_absolutely_abstract_creative_concepts_collaborators, parent: :creative_concept, debug: true
```

This will print out all the CanCanCan directives that would be added for that user in that context.  It will also show you which models were skipped over because they didn't repond to the parent object.

## Adding Roles to a new model

Generally, Roles would just be added to Membership records.  However, in some situations, you may want to add roles to other models.  For example, in Bullet Train, CreativeConcepts are only visible to admin members of the team.  To allow a regular user access to a single CreativeConcept we have a CreativeConcepts::Collaborator model.  You can think of the Collaborator model as a "membership" record for Creative Concepts.  Just like a Membership to a team grants a user access to the team with permissions scoped by roles added to the membership, a Collaborator is a user's access to a specific CreativeConcept.  If you have any resources in your application that regular team members won't have access to without explicit permission, you should consider a similar setup.  Another example would be a team representing a department in a large company.  That department may run many projects and the employees of the department should only have access to the projects that they are involved in.  In this scenario, you would have a Project model and something like a Projects::Associate.  The Projects::Associate model would join Memberships directly to Projects and allow regular users access to just those projects.  If you wanted to have different classes of Associates, you could add roles to the Associate model.

The goal here is that the same roles should be able to be applied in different contexts.  So if you have an admin role that is allowed to update and destroy projects, you could apply that role to either a Membership or a Projects::Associate.  The `permit` method will work out the associations and conditions to make it all work under the hood with CanCanCan.  You just need to set the `role_ids` column to `["admin"]` on either the Membership or Projects::Associate record.

If you want to add Roles to a new model in your application, do the following:

- Create your new model and make sure it has a jsonb type `roles_ids` column.
- Your model should `belongs_to :team` or `has_one :team, through: :parent`.  If you're using superscaffolding, these will be added automatically.
- Add the Role::Support concern to your model
- If your model should only have a subset of your roles available as options, add the `roles_only` class method.  See Membership for an example.
- Make sure to add any role_id options to your translation file for your new model (see memberships.en.yml for an example)
- Update your form and views to accept an array of role_ids (see membership for an example of allowing multiple roles and collaborator for an example that only alows a single role)
- Update the `config/models/roles.yml` file with any extra Roles or models required.
- Ensure that the model you are adding roles to belongs to User either directly or indirectly.  In default Bullet Train, Membership belongs to a User directly.  A Collaborator belongs to a user _through_ a Membership.  You just need to make sure you have a `belongs_to` or `has_one through:` back to the User model.
- That's it! Sit back and relax knowing you have a super secure permission model that's incredibly easy to configure!

## Additional Details

### Caching
Because abilities are being evaluated on every request, it made sense to introduce a thin layer of caching to help speed things up. This is primarily implemented in the `parent_ids_for` method in `app/models/user.rb`.

Because almost all models eventually roll back up to a Team record, in order for us to generate the condition hash for CanCanCan, we need to know the parent ids that the current user should have access to.  We create a hash on the User record under the `ability_cache` column and add unique keys for each resource with an array of parent ids.  By default, making changes to a model that includes the `Role::Support` concern will invalidate that user's cache.  See the `invalidate_cache` method in `Role::Support`.

### Naming and Labeling
What we call a `Role` in the domain model is referred to as “Special Privileges” in the user-facing application. You can rename this to whatever you like in `config/locales/en/roles.en.yml`.

## Note About Pundit
Sometimes people ask us about Pundit. There’s nothing stopping you from utilizing Pundit in a Bullet Train project for specific hard-to-implement cases in your permissions model, but you wouldn’t want to try and replace CanCanCan with it. We do too much automatically with CanCanCan for that to be recommended. Furthermore, for myself personally, in those situations where there is a permission that needs to be implemented that isn’t easily implemented with CanCanCan, I usually just write vanilla Ruby code for that purpose. I’ve never personally reached for Pundit in a Bullet Train project.
