# Understanding `permit`

The `permit` helper is some of the highest-leverage magic we provide in Bullet Train and we're sympathetic to developers who want to understand the magic they're employing, so we've provided as much of that as we can inline as code comments in the implementation itself.

In addition to that, below is a basic explanation of how to use the permit method that should be enough to get you started.

Given the following invocation in `app/models/ability.rb`:

```
permit user, through: :memberships, parent: :team
```

 - `through` should reference a collection on `User` where access to a resource is granted. The most common example in Bullet Train is the `memberships` association, which grants a `User` access to a `Team`. *In the context of `permit` discussions, we refer to the `Membership` model of this example as "the grant model".*
 - `parent` should indicate which level the models in `through` will grant a user access at. In the case of a `Membership`, this is `team`.

## Additional Grant Models

To illustrate the flexibility of this approach, consider that you may want to grant non-administrative team members different permissions for different `Project` objects on a `Team`. In that case, `permit` actually allows us to re-use the same role definitions to assign permissions that are scoped by a specific resource, like this:

```
permit user, through: :projects_collaborators, parent: :project
```

In this example, `permit` is smart enough to only apply the permissions granted by a `Projects::Collaborator` record at the level of the `Project` it belongs to.

For details on how to add resource-level permissions, see [Adding Additional Grant Models](/docs/permissions/new-grant-models.md).

## Debugging

If you want to see what CanCanCan directives are being created by your permit calls, you can add the `debug: true` option to your `permit` statement in `app/models/ability.rb`.

Likewise, to see what abilities are being added for a certain user, you can run the following on the Rails console:

```
user = User.first
Ability.new(user).permit user, through: :projects_collaborators, parent: :project, debug: true
```
