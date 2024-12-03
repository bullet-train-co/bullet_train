# This is used in CI to combine coverage data from multiple test runners
namespace :coverage do
  task :report do
    require "simplecov"
    require "simplecov-json"

    SimpleCov.collate Dir["coverage_artifacts/**/.resultset.json"], "rails" do
      formatter SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::JSONFormatter
      ])
      #formatter SimpleCov::Formatter::MultiFormatter.new([
        #SimpleCov::Formatter::SimpleFormatter,
        #SimpleCov::Formatter::HTMLFormatter
      #])
    end
  end
end
