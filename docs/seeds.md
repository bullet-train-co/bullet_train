# Database Seeds

Bullet Train introduces a new, slightly different expectation for Rails seed data: **It should be possible to run `rake db:seed` multiple times without creating duplicate data.**

## The Rails Default

This is different than the Rails default, [as evidenced by the Rails example](https://guides.rubyonrails.org/v6.1.1/active_record_migrations.html#migrations-and-seed-data) which uses `Product.create`:

```
5.times do |i|
  Product.create(name: "Product ##{i}", description: "A product.")
end
```

## Bullet Train Example

In Bullet Train applications, you would implement that same `db/seeds.rb` logic like so:

```
5.times do |i|
  Product.find_or_create_by(name: "Product ##{i}") do |product|
    # this only happens if on a `create`.
    production.description = "A product."
  end
end
```

## Why?
We do this so Bullet Train applications can re-use the logic in `db/seeds.rb` for three purposes:

1. Set up new local development environments.
2. Ensure the test suite has the same configuration for features whose configuration is backed by Active Record (e.g. [subscriptions](/docs/subscriptions.md) and [outgoing webhooks](/docs/webhooks/outgoing.md)).
3. Ensure any updates to the baseline configuration that have been tested both locally and in CI are the exact same updates being executed in production upon deploy.

This makes `db/seeds.rb` a single source of truth for this sort of baseline data, instead of having this concern spread and sometimes duplicated across `db/seeds.rb`, `db/migrations/*`, and `test/fixtures`.

## Seeds for Different Environments
In some cases, you may have core seed data like roles that needs to exist in every environment, but you also have development data to populate in your non-production environments. Bullet Train makes this easy by supporting per-environment seed files in the `db/seeds` folder like `db/seeds/test.rb` and `db/seeds/development.rb`.

Then in `db/seeds.rb`, you can load all of the shared core seed data at the beginning of `db/seeds.rb` and then load the environment-specific seeds only when you've specified one of those environments.

```
load "#{Rails.root}/db/seeds/development.rb" if Rails.env.development?
load "#{Rails.root}/db/seeds/test.rb" if Rails.env.test?
```

## Feedback
We're always very hesitant to stray from Rails defaults, so it must be said that our commitment to this approach isn't set in stone. It's worked very well for us in a number of applications, so we've standardized on it, but the approach is certainly open to discussion.
