require "test_helper"

class HackTaskTest < ActiveSupport::TestCase
  # TODO: Try to get these values dynamically.
  FRAMEWORK_PACKAGES = [
    "bullet_train",
    "bullet_train-api",
    "bullet_train-fields",
    "bullet_train-has_uuid",
    "bullet_train-incoming_webhooks",
    "bullet_train-integrations",
    "bullet_train-integrations-stripe",
    "bullet_train-obfuscates_id",
    "bullet_train-outgoing_webhooks",

    # TODO: We need to add this with bin/hack --link
    # "bullet_train-roles",

    "bullet_train-scope_questions",
    "bullet_train-scope_validator",
    "bullet_train-sortable",
    "bullet_train-super_load_and_authorize_resource",
    "bullet_train-super_scaffolding",
    "bullet_train-themes",
    "bullet_train-themes-light",
    "bullet_train-themes-tailwind_css",
  ]

  def setup
    @original_gemfile_lines = File.open("Gemfile").readlines
    @temp_gemfile_lines = File.open("test/support/temp_gemfile.rb").readlines

    @current_bullet_train_gem_version = @original_gemfile_lines.find do |line|
      line.match?('gem "bullet_train"')
    end

    # Because these tests are being run against a task in the `bullet_train` gem,
    # we ensure that the original `bullet_train` gem the developer is using stays in the temp Gemfile.
    # We can afford to skip checking `path: ...` for this gem in the individual test cases
    # because the `--link` logic is mostly covered for the other Bullet Train gems that are in the Gemfile,
    # including ones that aren't originally there but are added with `bin/hack --link`.
    @temp_gemfile_lines = @temp_gemfile_lines.map do |line|
      line.match?('gem "bullet_train"') ? @current_bullet_train_gem_version : line
    end

    # Replace the Gemfile with the temp file.
    File.write("Gemfile", @temp_gemfile_lines.join)
  end

  def teardown
    File.write("Gemfile", @original_gemfile_lines.join)
    `bundle install`
  end

  if Dir.exist?("local/bullet_train-core")
    test "bin/hack --link links gems properly to local/bullet_train-core" do
      `bin/hack --link`

      # Reload the Gemfile's contents.
      edited_gemfile = File.open("Gemfile").readlines.join

      FRAMEWORK_PACKAGES.each do |gem_name|
        next if gem_name == "bullet_train"
        assert edited_gemfile.include?("gem \"#{gem_name}\", path: \"local/bullet_train-core/#{gem_name}\"")
      end
    end
  end
end
