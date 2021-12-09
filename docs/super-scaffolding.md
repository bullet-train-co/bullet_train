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
 - It generates headless-browser feature tests for the CRUD workflows.

When adding just one model, Super Scaffolding generates ~30 different files on your behalf.

## Living Templates

Bullet Train's Super Scaffolding engine is a unique approach to code generation, based on template files that are functional code instead of obscure DSLs that are difficult to customize and maintain. Super Scaffolding automates the most repetitive and mundane aspects of building out your application's basic structure. Furthermore, it does this without leaning on the magic of libraries that force too high a level of abstraction. Instead, it generates standard Rails code that is both ready for prime time, but is also easy to customize and modify.

## Usage

### Prerequisites

Before getting started with Super Scaffolding, it's critical to understand [the philosophy of domain modeling in Bullet Train](/docs/philosophy/domain-modeling.md).

### Self-Documenting CLI Tool

The Super Scaffolding shell script provides its own documentation. To get started, run the following your shell:

```
bin/super-scaffold
```

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
