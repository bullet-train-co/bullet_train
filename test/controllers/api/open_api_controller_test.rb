require "controllers/api/v1/test"
require "tempfile"

class Api::OpenApiControllerTest < Api::Test
  test "OpenAPI document is valid" do
    get api_path(version: "v1")
    output = nil
    Tempfile.create do |f|
      f.write(response.body)
      f.rewind
      output = `yarn exec redocly lint #{f.path} 1> /dev/stdout 2> /dev/stdout`
    end
    assert output.include?("Woohoo! Your OpenAPI definition is valid.")
  end
end
