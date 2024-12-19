# About Super Scaffolding Tests

These tests each require some super scaffolding commands to be run _before_ running the tests.

Each subdirectory below contains a `setup.rb` file that you can run to generate the necessary scaffolding.

After running the tests you can run `teardown.rb` from the same directory to remove the super scaffolded code.

**NOTE** We highly reocmmend that you start with a clean git workspace. The super scaffolding commands generate
a lot of files and the cleanup process is... let's call it "brute force". If you have uncommitted changes in
your repo before running `setup.rb` they're likely to get clobbered when you run `teardown.rb`

### Example

To run the `insight` test, you'd run these commands from the main project directory.

First run the `setup.rb` script to generate the scaffolding and run migrations.

```
$ ./test/system/super_scaffolding/insight/setup.rb
Generating Insight model with 'bin/rails generate model Insight team:references name:string description:text'

Writing './app/controllers/account/insights_controller.rb'.
Fixing Standard Ruby on './app/controllers/account/insights_controller.rb'.
Writing './app/views/account/insights/index.html.erb'.
Writing './app/views/account/insights/_menu_item.html.erb'.
# snip
```

Then run the test:

```
$ rails test test/system/super_scaffolding/insight/
🌱 Generating global seeds.
🌱 Generating test environment seeds.
Not requiring Knapsack Pro.
If you'd like to use Knapsack Pro make sure that you've set the environment variable KNAPSACK_PRO_CI_NODE_INDEX
Started with run options --seed 45445

BulletTrain::SuperScaffolding::InsightTest
Puma starting in single mode...
* Puma version: 6.5.0 ("Sky's Version")
* Ruby version: ruby 3.3.6 (2024-11-05 revision 75015d4c1f) [arm64-darwin23]
*  Min threads: 5
*  Max threads: 5
*  Environment: test
*          PID: 55207
* Listening on http://127.0.0.1:3001
Use Ctrl-C to stop
  test_developers_can_generate_a_Insight_and_a_nested_Personality::CharacterTrait_model PASS (3.51s)

Finished in 3.51351s
1 tests, 4 assertions, 0 failures, 0 errors, 0 skips
Coverage report generated for test to /Users/jgreen/projects/bullet-train-co/bullet_train/coverage.
Line Coverage: 45.18% (150 / 332)
```
Then run `teardown.rb` to clean up:

```
$ ./test/system/super_scaffolding/insight/teardown.rb
db/schema.rb has changed - we need to rollback
== 20241219204101 CreatePersonalityCharacterTraits: reverting =================
-- drop_table(:personality_character_traits)
   -> 0.0037s
== 20241219204101 CreatePersonalityCharacterTraits: reverted (0.0073s) ========

== 20241219204056 CreateInsights: reverting ===================================
-- drop_table(:insights)
   -> 0.0016s
== 20241219204056 CreateInsights: reverted (0.0017s) ==========================

Updated 8 paths from the index

Removing app/avo/resources/insight.rb
Removing app/avo/resources/personality_character_trait.rb
Removing app/controllers/account/insights_controller.rb
Removing app/controllers/account/personality/
Removing app/controllers/api/v1/insights_controller.rb
Removing app/controllers/api/v1/personality/
Removing app/controllers/avo/insights_controller.rb
Removing app/controllers/avo/personality_character_traits_controller.rb
Removing app/models/insight.rb
Removing app/models/personality.rb
Removing app/models/personality/
Removing app/views/account/insights/
Removing app/views/account/personality/
Removing app/views/api/v1/insights/
Removing app/views/api/v1/personality/
Removing config/locales/en/insights.en.yml
Removing config/locales/en/personality/
Removing db/migrate/20241219204056_create_insights.rb
Removing db/migrate/20241219204101_create_personality_character_traits.rb
Removing test/controllers/api/v1/insights_controller_test.rb
Removing test/controllers/api/v1/personality/
Removing test/factories/insights.rb
Removing test/factories/personality/
Removing test/models/insight_test.rb
Removing test/models/personality/
```
