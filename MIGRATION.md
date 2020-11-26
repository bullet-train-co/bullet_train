# Migration Guidance

## Fixing Super Scaffold-Based Integration and Controller Tests
### February 6, 2018

We ran into some issues with some of our test templates after upgrading to Rails 5.2.0-rc1.

For integration tests that were generated from `test/integration/things_test.rb`, you should:

1. Update them to extend from `ActionDispatch::IntegrationTest` instead of `Capybara::Rails::TestCase`.
2. A call to `super` should be added as the first line of the `setup` method.

Controller tests generated from `test/account/things_controller_test.rb` should:

1. Update them to extend from `ActionDispatch::IntegrationTest` instead of `Capybara::Rails::TestCase`.
2. The tests were previously wrapped in a `describe "when user is signed in" do` block. You should remove this surrounding block.
3. After doing this, the indentation level of the tests will be one level too deep, so adjust the indentation to the left..
4. `setup do` should be changed to `def setup`.
5. A call to `super` should be added as the first line of the `setup` method.

To see an example of how we made these changes on the `Things` related controllers, see https://github.com/andrewculver/bullet-train/commit/b502ee3 .
