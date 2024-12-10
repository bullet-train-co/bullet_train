# This is used in CI to combine coverage data from multiple test runners
namespace :coverage do
  task :report, [:artifacts] do |t, args|
    require "simplecov"
    # In this one we use the external simplecov-json gem to get better info about the
    # suite as a whole, and for file coverage data.
    require "simplecov-json"

    SimpleCov.collate Dir[args[:artifacts]], "rails" do
      formatter SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::JSONFormatter
      ])
    end
  end
  task :report_with_groups, [:artifacts] do |t, args|
    require "simplecov"
    # In this one we use the JSONFormatter that ships with simplecov that includes group coverage info.
    require "simplecov_json_formatter"

    SimpleCov.collate Dir[args[:artifacts]], "rails" do
      formatter SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::JSONFormatter
      ])
    end
  end
  task :report_with_gem_groups, [:artifacts] do |t, args|
    require "simplecov"
    # In this one we use the JSONFormatter that ships with simplecov that includes group coverage info.
    require "simplecov_json_formatter"

    SimpleCov.collate Dir[args[:artifacts]], "rails" do
      groups.clear
      add_group "Starter Repo" do |src|
        !(src.filename =~ /local\/bullet_train-core/)
      end

      add_group "Bullet Train Core", "local/bullet_train-core"

      bt_gems = Dir.glob("local/bullet_train-core/*").select { |f| File.directory?(f) && f =~ /local\/bullet_train-core\/bullet_train/ }
      bt_gems.each do |bt_gem|
        add_group bt_gem.split("/").last, "#{bt_gem}/"
      end
      formatter SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::JSONFormatter
      ])
    end
  end
end
