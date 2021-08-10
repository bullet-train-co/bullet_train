require "test_helper"
require "minitest/spec"

require_relative "../../../lib/scaffolding"

describe Scaffolding::RoutesFileManipulator do
  subject { Scaffolding::RoutesFileManipulator }

  it "initializes" do
    subject.new(example_file, "CuriousKid", ["ProtectiveParent", "Team"])
  end

  let(:example_file) { "test/lib/scaffolding/examples/example._rb" }

  describe "common_namespaces" do
    examples = {

      ["Scaffolding::Thing", "Scaffolding::Widget"] =>
        ["scaffolding"],

      ["Scaffolding::SomethingTogether::Thing", "Scaffolding::SomethingTogether::Widget"] =>
        ["scaffolding", "something_together"],

      ["Scaffolding::SomethingTogether::Thing", "Scaffolding::SomethingElse::Widget"] =>
        ["scaffolding"]

    }

    examples.each do |inputs, outputs|
      it "returns #{outputs} for `#{inputs.first}` under `#{inputs.last}`" do
        results = subject.new(example_file, *inputs).common_namespaces
        assert_equal outputs, results
      end
    end
  end

  # describe 'divergent_namespaces' do
  #   examples = {
  #
  #     ['Scaffolding::Thing', 'Scaffolding::Widget'] =>
  #       [[], []],
  #
  #     ['Scaffolding::SomethingTogether::Thing', 'Scaffolding::SomethingTogether::Widget'] =>
  #       [[], []],
  #
  #     ['Scaffolding::SomethingTogether::Thing', 'Scaffolding::SomethingElse::Widget'] =>
  #       [['something_together'], ['something_else']],
  #
  #   }
  #
  #   examples.each do |inputs, outputs|
  #     it "returns #{outputs.to_s} for `#{inputs.first}` under `#{inputs.last}`" do
  #       results = subject.new(example_file, *inputs).divergent_namespaces
  #       assert_equal outputs, results
  #     end
  #   end
  # end

  describe "divergent_parts" do
    examples = {

      ["Scaffolding::Thing", "Scaffolding::Widget"] =>
        [[], "things", [], "widgets"],

      ["Scaffolding::SomethingTogether::Thing", "Scaffolding::SomethingTogether::Widget"] =>
        [[], "things", [], "widgets"],

      ["Scaffolding::SomethingTogether::Thing", "Scaffolding::SomethingElse::Widget"] =>
        [["something_together"], "things", ["something_else"], "widgets"]

    }

    examples.each do |inputs, outputs|
      it "returns #{outputs} for `#{inputs.first}` under `#{inputs.last}`" do
        results = subject.new(example_file, *inputs).divergent_parts
        assert_equal outputs, results
      end
    end
  end

  describe "find_namespaces" do
    describe "root level" do
      examples = {
        ["webhooks", "incoming"] => {"webhooks" => 46, "incoming" => 47}
      }

      examples.each do |inputs, outputs|
        it "returns #{outputs} for `#{inputs.first}` under `#{inputs.last}`" do
          results = subject.new(example_file, nil, nil).find_namespaces(inputs)
          assert_equal outputs, results
        end
      end
    end

    describe "under team" do
      examples = {
        ["imports", "csv", "scaffolding"] => {"imports" => 147, "csv" => 148, "scaffolding" => 150}
      }

      examples.each do |inputs, outputs|
        it "returns #{outputs} for `#{inputs.first}` under `#{inputs.last}`" do
          results = subject.new(example_file, nil, nil).find_namespaces(inputs, 143)
          assert_equal outputs, results
        end
      end
    end
  end

  describe "find_block_end" do
    examples = {
      # namespace :account
      109 => 243
    }

    examples.each do |starting_line_number, ending_line_number|
      it "returns #{ending_line_number} for #{starting_line_number}" do
        results = subject.new(example_file, "Something", "Nothing").find_block_end(starting_line_number)
        assert_equal ending_line_number, results
      end
    end
  end

  describe "find_or_create_namespaces" do
    it "adds ['account', 'testing', 'example'] appropriately" do
      manipulator = subject.new(example_file, "Something", "Nothing")
      manipulator.find_or_create_namespaces(["account", "testing", "example"])
      assert_equal File.readlines("test/lib/scaffolding/examples/result_1._rb"), manipulator.lines
    end
  end

  describe "find_resource_block" do
    it "finds ['account', 'teams'] appropriately" do
      manipulator = subject.new(example_file, "Something", "Nothing")
      assert_equal 143, manipulator.find_resource_block(["account", "teams"])
    end
    it "does not find ['account', 'asdf']" do
      manipulator = subject.new(example_file, "Something", "Nothing")
      assert_nil manipulator.find_resource(["account", "asdf"])
    end
  end

  describe "find_resource" do
    it "finds ['account', 'teams'] appropriately" do
      manipulator = subject.new(example_file, "Something", "Nothing")
      assert_equal 143, manipulator.find_resource(["account", "teams"])
    end
    it "does not find ['account', 'asdf']" do
      manipulator = subject.new(example_file, "Something", "Nothing")
      assert_nil manipulator.find_resource(["account", "asdf"])
    end
  end

  describe "apply" do
    it "adds 'Example' within 'Team' appropriately" do
      manipulator = subject.new(example_file, "Example", "Team")
      manipulator.apply(["account"])
      assert_equal File.readlines("test/lib/scaffolding/examples/result_2._rb"), manipulator.lines
    end
    it "adds 'Sample' under 'Membership' that appropriately" do
      manipulator = subject.new(example_file, "Sample", "Membership")
      manipulator.apply(["account"])
      assert_equal File.readlines("test/lib/scaffolding/examples/result_3._rb"), manipulator.lines
    end
    it "adds 'Webhooks::Outgoing::Log' under 'Webhooks::Outgoing::Event' that appropriately" do
      manipulator = subject.new(example_file, "Webhooks::Outgoing::Log", "Webhooks::Outgoing::Event")
      manipulator.apply(["account"])
      assert_equal File.readlines("test/lib/scaffolding/examples/result_6._rb"), manipulator.lines
    end
    it "adds 'Teams::Log' under 'Team' appropriately" do
      manipulator = subject.new(example_file, "Teams::Log", "Team")
      manipulator.apply(["account"])
      assert_equal File.readlines("test/lib/scaffolding/examples/result_4._rb"), manipulator.lines
    end
    it "adds 'Webhooks::Log' under 'Webhooks::Outgoing::Event' appropriately" do
      manipulator = subject.new(example_file, "Webhooks::Log", "Webhooks::Outgoing::Event")
      manipulator.apply(["account"])
      assert_equal File.readlines("test/lib/scaffolding/examples/result_5._rb"), manipulator.lines
    end
    it "adds the sortable concern properly" do
      manipulator = subject.new(example_file, "Example", "Team", {"sortable" => true})
      manipulator.apply(["account"])
      assert_equal File.readlines("test/lib/scaffolding/examples/result_7._rb"), manipulator.lines
    end
  end
end
