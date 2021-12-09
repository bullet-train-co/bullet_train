# Bullet Train Changelog

## December 8, 2021

### ⚠️ Roles and permission definitions have been completely refactored.

See [the updated documentation](/docs/permissions.md) for details.

Migration notes:

- The `roles` table has been removed and replaced with `config/models/roles.yml` instead.
- The `Role` model still exists, but is powered by [ActiveHash](https://github.com/zilkey/active_hash) and backed by that YAML file.
- The `team_ids_by_roles` and `team_ids_by_role` methods have been removed. If you were using these, look at `parent_ids_for` as a replacement.
- After running the `db/migrate/20211129044008_migrate_role_ids_to_yml.rb`, all `Role` objects that were present in the database will automatically be added to the `config/models/roles.yml` file.  The `membership_roles` table will be dropped and all records will be added to the new `Membership.role_ids` column instead.
- After running the migration, you will need to manually configure each role in `config/models/roles.yml` for your specific application.  This should mainly involve adding the correct models to the models array for each role.  For details, see `docs/permissions.md`.
- This entire thing is a big change, please think carefully about the implications for your application before deploying to production. Be sure to have a database backup on hand for reference in case something goes wrong and you need to reference the previous state.
- For an example of how to migrate your existing permissions to this new configuration file, [see this video](https://www.loom.com/share/9af9112e5d50492f835096b6b84c240a).

Method migrations:

- The `roles_managable_by_all` method has been removed. If you were using it, look at `Role#manageable_by?` and `Role#included_roles` methods.
- There is a new `default` role that has been added.  All members on a team actually inherit the abilities of this role.
- The `Team#invalidate_caches` method was removed. We specific invalidate the cache at a user-level when one of their `Membership` records is updated.

## November 28, 2021

### ⚠️ Outgoing webhook event types moved to YAML file

The definition of outgoing webhook event types has changed from being database-backed to being backed by a YAML configuration file in `config/models/webhooks/outgoing/event_types.yml`. This update includes destructive migrations. The database migrations will handle mapping any previously configured endpoints to the new setup, but in order for it to work you'll need to first ensure that you have all event types you previously had defined in `db/seeds/webhooks.rb` now defined in `config/models/webhooks/outgoing/event_types.yml`.
