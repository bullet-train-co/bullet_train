# Roles, Permissions, Abilities, and Authorization

## CanCanCan
Bullet Train leans heavily on [CanCanCan](https://github.com/CanCanCommunity/cancancan) for implementing authorization and permissions. (We’re also proud sponsors of its ongoing maintenance.) The original CanCan library by Ryan Bates was, in our opinion, a masterpiece and a software engineering marvel that has stood the test of time. It's truly a diamond among Ruby Gems. If you're not already familiar with CanCanCan, you should [read its documentation](https://github.com/CanCanCommunity/cancancan) to get familiar with its features and DSL.

## Bullet Train Roles
Over many years of successfully implementing applications with CanCanCan, it became apparent to us that a supplemental level of abstraction could help streamline and simplify the definition of many common permissions, especially in large applications. We've since extracted this functionality into [a standalone Ruby Gem](https://github.com/bullet-train-co/bullet_train-roles) and moved the documentation that used to be here into [the README for that project](https://github.com/bullet-train-co/bullet_train-roles/blob/main/README.md). Should you encounter situations where this abstraction doesn't meet your specific needs, you can always implement the permissions you need using standard CanCanCan directives in `app/models/ability.rb`.

## Additional Notes

### Caching
Because abilities are being evaluated on basically every request, it made sense to introduce a thin layer of caching to help speed things up. When evaluating permissions, we store a cache of the result in the `ability_cache` attribute of the `User`. By default, making changes to a model that includes the `Roles::Support` concern will invalidate that user's cache.

### Naming and Labeling
What we call a `Role` in the domain model is referred to as “Special Privileges” in the user-facing application. You can rename this to whatever you like in `config/locales/en/roles.en.yml`.

## Note About Pundit
There’s nothing stopping you from utilizing Pundit in a Bullet Train project for specific hard-to-implement cases in your permissions model, but you wouldn’t want to try and replace CanCanCan with it. We do too much automatically with CanCanCan for that to be recommended. That said, in those situations where there is a permission that needs to be implemented that isn’t easily implemented with CanCanCan, consider just writing vanilla Ruby code for that purpose.
