# About Super Scaffolding Tests

TODO

NOTE: the setup for this test really requires a clean git workspace.
you'll see why toward the end when you're trying to clean up the files
created (and then afterwards tested in the test below.)

before this test can be run, we need to do the following setup on the console:
  bundle exec test/bin/setup-super-scaffolding-system-test

to run this test:
  rails test test/system/super_scaffolding/super_scaffolding_test.rb
to run the super scaffolding test suite as a whole:
  rails test test/system/super_scaffolding/

after the test you can tear down what we've done here in the db:
  rake db:migrate VERSION=`ls db/migrate | sort | tail -n 9 | head -n 1`
  git checkout .
  git clean -d -f
