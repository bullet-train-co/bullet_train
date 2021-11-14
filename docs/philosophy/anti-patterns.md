# Bullet Train Anti-Patterns

## The "Anemic Domain Model": Service Objects (or Form Objects) Everywhere

There have been, at times, advocates in the Rails ecosystem of an approach where classes in `app/models` are only concerned with "persistence", or the mapping of data to and from application memory and the database. There have also been developers whose default approach is to extract any type of business logic away from the classes in `app/models` and into "service objects", to the point where they'll end up with service objects for every CRUD operation like "create user", etc.

[The identification of this tendency as an anti-pattern](https://martinfowler.com/bliki/AnemicDomainModel.html) predates Rails.

It's not to say there isn't room for the occasional well-placed service object or form object, but in the context of Bullet Train we double down on the traditional Rails approach of a "fat model" where classes in `app/models` not only have persistence responsibilities, but also collect business logic and user-facing form validations as well. In fact, with Bullet Train's Action Models, even things that would sometimes rightfully be implemented as service objects will instead tend end up being implemented as part of your domain model.
