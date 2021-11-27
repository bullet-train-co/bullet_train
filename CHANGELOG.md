# Bullet Train Changelog

- The definition of outgoing webhook event types has changed from being database-backed to being backed by a Yaml configuration file in `config/models/webhooks/outgoing/event_types.yml`. The database migrations will handle mapping any previously configured endpoints to the new setup, but in order for it to work you'll need to first ensure that you have all event types you previously had defined in `db/seeds/webhooks.rb` now defined in `config/models/webhooks/outgoing/event_types.yml`.
