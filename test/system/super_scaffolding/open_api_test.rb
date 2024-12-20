require "application_system_test_case"

# We run this in CI on each super scaffold test node to ensure that the OpenAPI Document
# is still valid after generating super scaffolds.
class SuperScaffoldingOpenAPITest < ApplicationSystemTestCase
  test "OpenAPI V3 document is still valid" do
    visit "/" # Make sure the test server is running before linting the file.

    puts(output = `yarn exec redocly lint http://127.0.0.1:#{Capybara.server_port}/api/v1/openapi.yaml 1> /dev/stdout 2> /dev/stdout`)
    # redocly/openapi-core changed the format of their success message in version 1.2.0.
    # https://github.com/Redocly/redocly-cli/pull/1239
    # We use a robust regex here so that we can match both formats.
    assert output.match?(/Woohoo! Your (Open)?API (definition|description) is valid./)
  end
end
