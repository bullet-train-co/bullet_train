# Code Generation with Super Scaffolding

Super Scaffolding is Bullet Train’s code generation engine. Its goal is to allow you to produce production-ready CRUD interfaces for your models while barely lifting a finger, and it handles a lot of other grunt-work as well.

Here’s a list of what Super Scaffolding takes care of for you each time you add a model to your application:

 - It generates a basic CRUD controller and accompanying views.
 - It generates a Yaml locale file for the views’ translatable strings.
 - It generates type-specific form fields for each attribute of the model.
 - It generates an API controller and an accompanying entry in the application’s API docs.
 - It generates a serializer that’s used by the API and when dispatching webhooks.
 - It adds the appropriate permissions for multitenancy in CanCanCan’s configuration file.
 - It adds the model’s table view to the show view of its parent.
 - It adds the model to the application’s navigation (if applicable).
 - It generates breadcrumbs for use in the application’s layout.
 - It generates the appropriate routes for the CRUD controllers and API endpoints.

When adding just one model, Super Scaffolding generates ~30 different files on your behalf.

## Living Templates

Bullet Train's Super Scaffolding engine is a unique approach to code generation, based on template files that are functional code instead of obscure DSLs that are difficult to customize and maintain. Super Scaffolding automates the most repetitive and mundane aspects of building out your application's basic structure. Furthermore, it does this without leaning on the magic of libraries that force too high a level of abstraction. Instead, it generates standard Rails code that is both ready for prime time, but is also easy to customize and modify.

## Prerequisites

Before getting started with Super Scaffolding, we recommend reading about [the philosophy of domain modeling in Bullet Train](/docs/philosophy/domain-modeling.md).

## Usage

The Super Scaffolding shell script provides its own documentation. If you're curious about specific scaffolders or parameters, you can run the following in your shell:

```
bin/super-scaffold
```

## Examples

### 1. Basic CRUD Scaffolding with `crud`

Let's implement the following feature:

> An organization has many projects.

First, generate the model with the standard Rails generator:

```
rails g model Project team:references name:string
```

In the above example, `team` represents the model that a `Project` primarily belongs to.

⚠️ Don't run migrations right away. It would be fine in this case, but sometimes the subsequent Super Scaffolding step actually updates the migration as part of its magic.

Next, run the `crud` scaffolder:

```
bin/super-scaffold crud Project Team name:text_field
rake db:migrate
```

In the above example, `text_field` was selected from [the list of available field partials](/docs/field-partials.md). We'll show examples with `trix_editor` and `super_select` later.

### 2. Nested CRUD Scaffolding with `crud`

Building on that example, let's implement the following feature:

```
A project has many goals.
```

Again, we'll generate the model using the standard Rails generator:

```
rails g model Goal project:references description:string
```

You can see in the example above that there is no direct reference to team, but to `project` instead, since that's where a `Goal` belongs.

Now, run the `crud` scaffolder:

```
bin/super-scaffold crud Goal Project,Team description:text_field
rake db:migrate
```

You can see in the example above how we've specified `Project,Team`, because we want to specify the entire chain of ownership back to the `Team`. This allows Super Scaffolding to automatically generate the required permissions.

### 3. Adding New Fields with `crud-field`

One of Bullet Train's most valuable features is the ability to add new fields to existing scaffolded models. When you add new fields with the `crud-field` scaffolder, you don't have to remember to add that same attribute to table views, show views, translation files, API endpoints, serializers, tests, documentation, etc.

Building on the earlier example, consider the following new requirement:

> In addition to a name, a project can have a description.

First, use the standard Rails migration generator to add the attribute in the database:

```
rails g migration add_description_to_projects description:text
```

Then, use the `crud-field` scaffolder to add it throughout the application:

```
bin/super-scaffold crud-field Project description:trix_editor
rake db:migrate
```

As you can see, when we're using `crud-field`, we don't need to supply the chain of ownership back to `Team`.

### 4. Adding Option Fields with Fixed, Translatable Options

Continuing with the earlier example, let's address the following new requirement:

> Users can specify the current project status.

We have multiple [field partials](/docs/field-partials.md) that we could use for this purpose, including `buttons`, `options`, or `super_select`.

In this example, let's add a status attribute and present it as buttons:

```
rails g migration add_status_to_projects status:string
bin/super-scaffold crud-field Project status:buttons
```

By default, Super Scaffolding configures the buttons as "One", "Two", and "Three", but in this example you can edit those options in the `fields` section of `config/locales/en/projects.en.yml`. For example, you could specify the following options:

```
planned: Planned
started: Started
completed: Completed
```

If you want new `Project` models to be set to `planned` by default, you can add that to the migration file that was generated before running it, like so:

```
add_column :projects, :status, :string, default: "planned"
```

### 5. Scaffolding `belongs_to` Associations, Team Member Assignments

Continuing with the example, consider the following requirement:

> A project has one specific project lead.

Although you might think this calls for a reference to `User`, we've learned the hard way that it's typically much better to assign resources on a `Team` to a `Membership` on the team instead. For one, this allows you to assign resources to new team members that haven't accepted their invitation yet (and don't necessarily have a `User` record yet.)

We can accomplish this like so:

```
rails g migration add_lead_to_projects lead:references
```

Then, to add the field, we specify the following:

```
bin/super-scaffold crud-field Project lead_id:super_select[class_name=Membership]
rake db:migrate
```

There are two important things to point out here:

1. When we use `rails g model` or `rails g migration`, we specify the `references` column name as `lead`, but when we're specifying the _field_ we want to scaffold, we specify it as `lead_id`, because that's the name of the attribute on the form, in strong parameters, etc.
2. We have to specify the model name with the `class_name` option so that Super Scaffolding can fully work it's magic. We can't reflect on the association, because at this point the association isn't properly defined yet. With this information, Super Scaffolding can handle that step for you.

Finally, Super Scaffolding will prompt you to edit `app/models/project.rb` and implement the required logic in the `valid_leads` method. This is a template method that will be used to both populate the select field on the `Project` form, but also enforce some important security concerns in this multi-tenant system. In this case, you can define it as:

```
def valid_leads
  team.memberships.current_and_invited
end
```

(The `current_and_invited` scope just filters out people that have already been removed from the team.)

### 6. Scaffolding Has-Many-Through Associations with `join-model`

Finally, working from the same example, imagine the following requirement:

> A project can be labeled with one or more project-specific tags.

We can accomplish this with a new model, a new join model, and a `super_select` field.

First, let's create the tag model:

```
rails g model Projects::Tag team:references name:string
bin/super-scaffold crud Projects::Tag Team name:text_field
```

Note that project tags are specifically defined at the `Team` level. The same tag can be applied to multiple `Project` models.

Now, let's create a join model for the has-many-through association:

```
rails g model Projects::AppliedTag project:references tag:references
```

We're not going to scaffold this model with the typical `crud` scaffolder, but some preparation is needed before we can use it with the `crud-field` scaffolder, so we need to do the following:

```
bin/super-scaffold join-model Projects::AppliedTag project_id[class_name=Project] tag_id[class_name=Projects::Tag]
```

All we're doing here is specifying the name of the join model, and the two attributes and class names of the models it joins. Note again that we specify the `_id` suffix on both of the attributes.

Now that the join model has been prepared, we can use the `crud-field` scaffolder to create the multi-select field:

```
bin/super-scaffold crud-field Project tag_ids:super_select[class_name=Projects::Tag]
rake db:migrate
```

Just note that the suffix of the field is `_ids` plural, and this is an attribute provided by Rails to interact with the `has_many :tags, through: :applied_tags` association.

The `crud-field` step will ask you to define the logic for the `valid_tags` method in `app/models/project.rb`. You can define it like so:

```
def valid_tags
  team.projects_tags
end
```

Honestly, it's crazy that we got to the point where we can handle this particular use case automatically. It seems simple, but there is so much going on to make this feature work.

## Additional Notes

### `TangibleThing` and `CreativeConcept`

In order to properly facilitate this type of code generation, Bullet Train includes two models in the `Scaffolding` namespace:

1. `Scaffolding::AbsolutelyAbstract::CreativeConcept`
2. `Scaffolding::CompletelyConcrete::TangibleThing`

Their peculiar naming is what's required to ensure that their corresponding view and controller templates can serve as the basis for any combination of different model naming or [namespacing](https://blog.bullettrain.co/rails-model-namespacing/) that you may need to employ in your own application.

### Hiding Scaffolding Templates

You won't want your end users seeing the Super Scaffolding templates in your environment, so you can disable their presentation by setting `HIDE_THINGS` in your environment. For example, you can add the following to `config/application.yml`:

```
HIDE_THINGS: true
```

## Advanced Examples
 - [Super Scaffolding with Delegated Types](/docs/super-scaffolding/delegated-types.md)
