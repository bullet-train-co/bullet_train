require "application_system_test_case"

class OpenApiV3Test < ApplicationSystemTestCase
  test "OpenAPI V3 document is valid" do
    visit "http://localhost:3001/api/v1/openapi.yaml"
    puts(output = `yarn exec redocly lint http://localhost:3001/api/v1/openapi.yaml 1> /dev/stdout 2> /dev/stdout; rm openapi.yaml`)
    assert output.include?("Woohoo! Your OpenAPI definition is valid.")
  end
end
