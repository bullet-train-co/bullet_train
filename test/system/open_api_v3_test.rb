require "application_system_test_case"

class OpenApiV3Test < ApplicationSystemTestCase
  test "OpenAPI V3 document is valid" do
    output = `yarn exec redocly lint http://localhost:3000/api/v1/openapi.yaml 1> /dev/stdout 2> /dev/stdout`
    assert output.include?("Woohoo! Your OpenAPI definition is valid.")
  end
end
