# Bullet Train Changelog

## December 8, 2021

### 🚨 Role Refactor

🚨 WARNING 🚨
This change contains destructive migrations.  Read the detaills below before running.

Roles have been refactored and migrated from a database table to a yml file.

- The roles table has been removed and replaced with `config/models/role.yml` instead.
- The team_ids_by_roles and team_ids_by_role methods have been removed.  You should instead use the `parent_ids_for` method.
- THe `roles_managable_by_all` method has been removed. Instead, use the `Role#manageable_by?` and `Role#included_roles` methods.
- There is a new `default` role that has been added.  All users are automatically assigned this role.  It does not need to be added to a memberships's role_ids.
- After running MigrateRoleIdsToYml, all Roles that were present in the database will automatically be added to the `config/models/roles.yml` file.  The membership_roles table will be dropped and all records will be added to the new `Membership.role_ids` column instead.  Note that the role ids will change when migrating from the database to the yml file.  MigrateRoleIdsToYmlFile allows for this and will migrate from the old ids to the new ones when setting the `Membership.role_ids` column.
- After running the migration, you will need to manually configure the Roles in `config/models/roles.yml` for your specific application.  This should mainly involve adding the correct models to the models array for each role.  For details on how to configure the roles.yml file, see `docs/permissions.md`.
- The Team#invalidate_caches method was removed.  Most changes to a user's permissions should only effect that current user so ther is no need to invalidate the cache for all users on the team.

It is recommended to run this migration on a dump from production before deploying it to production.  It would also be a good idea to take a backup of the Role and MembershipRole tables before running the migration.


## November 28, 2021

### Webhook migration to yml file

- The definition of outgoing webhook event types has changed from being database-backed to being backed by a Yaml configuration file in `config/models/webhooks/outgoing/event_types.yml`. The database migrations will handle mapping any previously configured endpoints to the new setup, but in order for it to work you'll need to first ensure that you have all event types you previously had defined in `db/seeds/webhooks.rb` now defined in `config/models/webhooks/outgoing/event_types.yml`.
