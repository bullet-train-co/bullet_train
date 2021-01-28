# Roles, Permissions, Abilities, and Authorization

## Domain Model Overview

- A `User` belongs to a `Team` via a `Membership`.
- A `User` only has one `Membership` per team.
- A `Membership` can have zero, one, or many `Role`s assigned.
- A `Membership` without a `Role` is just a default team member.

## CanCanCan
Bullet Train leans very heavily on [CanCanCan](https://github.com/CanCanCommunity/cancancan) for implementing authorization and permissions. (We’re also very proud to sponsor its ongoing maintenance.) The original CanCan library by Ryan Bates was, in my opinion, a complete masterpiece and a software engineering marvel that has stood the test of time. It’s a diamond among gems. If you're not alreaady familiar with CanCanCan, you should [read its documentation](https://github.com/CanCanCommunity/cancancan) to get familiar with its DSL.

### Note About Pundit
Sometimes people ask us about Pundit. There’s nothing stopping you from utilizing Pundit in a Bullet Train project for specific hard-to-implement cases in your permissions model, but you wouldn’t want to try and replace CanCanCan with it. We do too much automatically with CanCanCan for that to be recommended. Furthermore, for myself personally, in those situations where there is a permission that needs to be implemented that isn’t easily implemented with CanCanCan, I usually just write vanilla Ruby code for that purpose. I’ve never personally reached for Pundit in a Bullet Train project.

## Caching
Because abilities are being evaluated on every request, it made sense to introduce a thin layer of caching to help speed things up. This is primarily implemented in the `UserPermissionCachingDecorator` in `app/models/ability.rb`.

The basic approach is that `UserPermissionCachingDecorator` wraps the incoming `User` model that’s being passed into the `Ability` class. It returns cached copies of the IDs returned by methods like `team_ids` and `admin_team_ids`. By default these caches are expired when membership changes are made on a given team. See `Membership#invalidate_caches` for details.

## Naming and Labeling
What we call a `Role` in the domain model is referred to as “Special Privileges” in the user-facing application. You can rename this to whatever you like in `config/locales/en/roles.en.yml`.

## Defaults
By default we have one role: “Team Administrator”, referenced in code by the key `admin`. If a team member isn’t assigned this role, they’re just a regular team member.

By default, `admin` has only a handful of additional privileges compared to a regular team member, which you can see in `app/models/ability.rb`. As you’ll see there, most permissions are evaluated against `user.team_ids`, which means any team that a user is a member of. Only a handful of abilities there check against `user.admin_team_ids`.

## Roles are Additive
Roles are intended to be additive. If you want to introduce the concept of a “Viewer” who can’t edit things, then what you really want to do is make the default (e.g. basic team member with no role) unable to edit things, and then introduce a new role that is able to edit things.

## Implementing Roles that Inherit

### Example: An “Administrator” can do everything a regular team member can do, but also more!
There isn’t anything to do here, really, because everyone on the team is a team member, so we don’t have to do anything to enable their abilities for administrators.
