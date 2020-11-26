# Bullet Train Changelog

- ⛔️ Don't use the current iteration of kanban boards or conversations or use Sprinkle's "Cabled Collections" feature in production yet. There is a known security issue where a user could be connected to a conversation, be removed from their team, and continue to receive updates to that conversation. That could make for some awkward situations! We'll remove this item from the change log when the edge-case is addressed.
- ⛔️ The tests for inbound and outbound webhooks infrastructure are disabled. I don't know why these tests are unable to connect to the test server recursively since upgrading to Rails 6, but it's not working. Please beware if you have customers or important processes depending on these features.
