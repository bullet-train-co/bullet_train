require "test_helper"
require "minitest/spec"

require_relative "../../../lib/scaffolding"

describe Scaffolding::Transformer do
  it "initializes" do
    Scaffolding::Transformer.new("CuriousKid", ["ProtectiveParent", "Team"])
  end

  it "properly generates a controller file for CuriousKid and ProtectiveParent" do
    @transformer = Scaffolding::Transformer.new("CuriousKid", ["ProtectiveParent", "Team"])
    @transformer.get_transformed_file_content("./app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb")
  end
end
