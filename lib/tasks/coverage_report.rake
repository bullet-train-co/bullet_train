# This is used in CI to combine coverage data from multiple test runners
namespace :coverage do
  task :report do
    require "simplecov"
    # In this one we use the external simplecov-json gem to get better info about the
    # suite as a whole, and for file coverage data.
    require "simplecov-json"

    SimpleCov.collate Dir["coverage_artifacts/**/.resultset.json"], "rails" do
      formatter SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::JSONFormatter
      ])
    end
  end
  task :report_with_groups do
    require "simplecov"
    # In this one we use the built-in JSONFormatter that includes group coverage info.

    SimpleCov.collate Dir["coverage_artifacts/**/.resultset.json"], "rails" do
      formatter SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::JSONFormatter
      ])
    end
  end
end
