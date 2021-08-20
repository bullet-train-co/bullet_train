# Automated Question Methods from Scopes

When defining a new scope in your model, Bullet Train will automatically define a question method for that scope so you don’t have to.

When you define an Active Record scope, you get an instance level `?` method which uses the same logic. For example, try adding the following scope to your Team model:
```ruby
scope :long_names, -> { where("LENGTH(name) > 15") }
# 🚅 add scopes above.

# 🚅 add validations above.

...
```

And that’s it! The corresponding question method will now be available for use with your instance variables.

```ruby
# The original scope which returns an array of objects.
Team.long_names
#=> #<ActiveRecord::Relation [#<Team id: 1, name: "A Team with a  Long Name”, ...>]>

# The question scope which is generated automatically in its singular form.
t = Team.long_names.first
t.long_name?
#=> true
```

This is a common pattern where, for instance, you might want to write something like `some_object.active?` in a view after you’ve declared `scope :active` in your model. Instead of implementing the logic in both SQL and Ruby, the boolean method is defined automatically, and it is guaranteed to match the scope.
