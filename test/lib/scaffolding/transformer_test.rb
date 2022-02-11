require "test_helper"
require "minitest/spec"
require "scaffolding/class_names_transformer"
require "scaffolding/transformer"

describe Scaffolding::Transformer do
  it "initializes" do
    Scaffolding::Transformer.new("CuriousKid", ["ProtectiveParent", "Team"])
  end

  it "properly generates a controller file for CuriousKid and ProtectiveParent" do
    @transformer = Scaffolding::Transformer.new("CuriousKid", ["ProtectiveParent", "Team"])
    template_path = @transformer.resolve_template_path("app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb")
    @transformer.get_transformed_file_content(template_path)
  end
end
