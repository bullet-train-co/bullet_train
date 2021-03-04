# Automated Test Suite
All of Bullet Train’s core functionality is verifiable using the provided test suite. This foundation of headless browser integration tests took a ton of time to write, but they can give you the confidence and peace of mind that you haven't broken any key functionality in your application before a deploy.

You can run the test suite with the following command in your shell:

```
rails test
```

## Fixing Broken Tests

### 1. Run Chrome in Non-Headless Mode

When debugging tests, it's important to be able to see what Capybara is seeing. You can disable the headless browser mode by prefixing `rails test` like so:

```
MAGIC_TEST=1 rails test
```

When you run the test suite with `MAGIC_TEST` set in your environment like this, the browser will appear on your screen after the first Capybara test starts. (This may not be the first test that runs.) Be careful not to interact with the window when it appears, as sometimes your interactions can cause the test to fail needlessly.

### 2. Insert `binding.pry`.

Open the failing test file and insert `binding.pry` right before the action or assertion that is causing the test to fail. After doing that, when you run the test, it will actually stop and open a debugging console while the browser is still open to the appropriate page where the test is beginning to fail. You can use this console and the open browser to try and figure out why the test is failing. When you're done, hit <kbd>Control</kbd> + <kbd>D</kbd> to exit the debugger and continue letting the test run.
