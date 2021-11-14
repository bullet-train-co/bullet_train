# Domain Modeling in Bullet Train

Domain modeling is one of the most important activities in software development. With [Super Scaffolding](/docs/super-scaffolding.md), it's also one of the highest leverage activities in Bullet Train development.

## What is a "Domain Model"?

In software application development, your domain model is the object-oriented representation (or "abstraction") of the problem space you're solving problems for. In Rails, the classes that represent your domain model live in `app/models`.

## What is "Domain Modeling"?

"Domain modeling" refers to the process by which you decide which entities to introduce into your application's domain model, how those models relate to each other, and which attributes belong on which models.

Because in Rails most of your models will typically be backed by tables in a database, the process of domain modeling substantially overlaps with "database design". This is especially true in systems like Rails that implement their domain model with the Active Record pattern, because your table structure and object-oriented models are pretty much mapped one-to-one[<sup>*</sup>](https://en.wikipedia.org/wiki/Object–relational_impedance_mismatch).

## The Importance of Domain Modeling

### Usability

Generally speaking, the better your domain model is mapped to the real-world problem space, the more likely it is to map to your own users conceptual model of the problem space in their own head. Since the structure of your domain model ends up having such a large influence on the default structure and navigation of your application UI, getting the domain model "right" is the first step in creating an application that is easy for users to understand and use.

### Extendability

Feature requests come from the real world, and specifically from the parts of reality your application doesn't already solve for. The better your existing domain model captures the existing real-world problem space you've tried to solve problems for, the easier it will be for your application to add new models for features that solve the new problems your users are actually experiencing in real life. Inversely, if you take the wrong shortcuts when representing the problem space, it will be difficult to find the right place to add new features in a way that makes sense to your users.

## Important Bullet Train Concepts

### The "Parent Model"

The idea of a "parent model" is different than [a "parent class" in an object-oriented sense](https://en.wikipedia.org/wiki/Inheritance_\(object-oriented_programming\)). When we say "parent model", we're referring to the model that another model primarily belongs to. For example, a `Task` might primarily belong to a `Project`. Although this type of hierarchy isn't an entirely natural concept in object-oriented programming itself, (where our UML diagrams have many types of relationships flying in different directions,) it's actually a very natural concept in the navigation structure of software, which is why breadcrumbs are such a popular tool for navigation. It's also a concept that is very natural in traditional Rails development, expressed in the definition of nested RESTful routes for resources.

## Philosophies

### Take your time and get it right.

Because Super Scaffolding makes it so easy to bring your domain model to life, you don't have to rush into that implementation phase of writing code. Instead, you can take your sweet time thinking through your proposed domain model and mentally running it through the different scenarios and use cases it needs to solve for. If you get aspects of your domain model wrong, it can be really hard to fix later.

### More minds are better.

Subject your proposed domain model to review from other developers or potential users and invite their thoughts.

### Tear it down to get it right.

In traditional Rails development, it can be so much work to bring your domain model to life in views and controllers that if you afterward realize you missed something or got something wrong structurally, it can be tempting not to fix it or refactor it. Because Super Scaffolding eliminates so much of the busy work of bringing your domain model to life in the initial implementation phase, you don't have to worry so much about tearing down your scaffolds, reworking the domain model, and running through the scaffolding process again.

### Focus on the structure and namespacing. Don't worry about every attribute.

One of the unique features of Super Scaffolding is that it allows you to scaffold additional attributes with `bin/super-scaffold crud-field` after the initial scaffolding of a model with `bin/super-scaffold crud`. That means that you don't have to worry about figuring out every single attribute that might exist on a model before running Super Scaffolding. Instead, the really important piece is:

1. Naming the model.
2. Determining which parent model it primarily belongs to.
3. Determining whether the model should be [in a topic namespace](https://blog.bullettrain.co/rails-model-namespacing/).

### Start with CRUD, then polish.

Even if you know there's an attribute or model that you're going to want to polish up the user experience for, still start with the scaffolding. This ensures that any model or attribute is also represented in your REST API and you have feature parity between your web-based experience and what developers can integrate with and automate.

### Pluralize preemptively.

> Before you write any code — ask if you could ever possibly want multiple kinds of the thing you are coding. If yes, just do it. Now, not later.

— [Shawn Wang](https://twitter.com/swyx)

> I've done this refactoring a million times. I'll be like, I thought there would only ever be one subscription team, user plan, name, address, and it always ends up being like, "Oh, actually there's more." I almost never go the other way. What if you just paid the upfront cost of thinking "This is just always a collection"?

— [Ben Orenstein](https://twitter.com/r00k)

[I believe this is one of the most important articles in software development in the last ten years.](https://www.swyx.io/preemptive-pluralization/) However, with great domain modeling power comes great UX responsibility, which we'll touch on later.

## A Systematic Approach

### 1. Write `rails g` and `bin/super-scaffold` commands in a scratch file.

See the [Super Scaffolding documentation](/docs/super-scaffolding.md) for more specific guidance. Leave plenty of comments in your scratch file describing anything that isn't obvious and providing examples of values that might populate attributes.

### 2. Review with other developers.

Push up a pull request with your scratch file and invite review from other developers. They might bring up scenarios and use cases you didn't think of, better ways of representing something, or generate questions that don't have an obvious answer and require feedback from a subject matter expert.

### 3. Review with non-developer stakeholders.

Engage with product owners or potential users and talk through each part of the domain model in your scratch file without showing it to them or getting too technical. Just talk through which entities you chose to represent, which attributes and options are available. Talk through the features those models and attributes allow you to provide and which use cases you think you've covered.

In these discussions, you're looking for inspiration of additional nouns, verbs, and use cases you may not have considered in your initial modeling. Even if you choose not to incorporate certain ideas or feature requests immediately, you're at least taking into consideration whether they would fit nicely into the mental model you have represented in your domain model.

### 4. Run the commands.

Be sure to commit your results at this point. This helps isolate the computer generated code from the work you'll do in the next step (which you may want to have someone review.)

### 5. Polish the UI.

By default, Bullet Train produces a very CRUD-y user experience. The intention has always been that the productivity gains provided by Super Scaffolding should be reinvested into the steps that come before and after. Spend more time domain modeling, and then spend more time polishing up the resulting UX.

This is especially true in situations where you've chosen to pluralize preemptively. Ask yourself: Does every user need this option in the plural? If not, should we try to simplify the conceptual model by representing it as a "has one" until they opt-in to complexity? Doing this allows you to have the best of both worlds: Simplicity for those who can fit within it, and advanced functionality that users can opt into.
