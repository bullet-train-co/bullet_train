require "controllers/api/v1/test"
require "fileutils"

class Api::OpenApiControllerTest < Api::Test
  test "OpenAPI document is valid" do
    get api_path(version: "v1")

    openapi_yaml_path = Rails.root.join("tmp", "openapi.yaml")
    File.write(openapi_yaml_path, response.body)

    output = `yarn exec redocly lint api@v1 1> /dev/stdout 2> /dev/stdout`
    FileUtils.rm(openapi_yaml_path)

    warnings = output.match(/You have (\d+) warnings/)
    puts output if warnings
    refute warnings

    assert output.include?("Woohoo! Your OpenAPI definition is valid.")
  end
end
