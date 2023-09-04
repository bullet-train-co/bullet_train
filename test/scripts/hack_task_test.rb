require "test_helper"

class HackTaskTest < ActiveSupport::TestCase
  def setup
    @original_gemfile_lines = File.open("Gemfile").readlines
    @temp_gemfile_lines = File.open("test/support/temp_gemfile.rb").readlines

    @current_bullet_train_gem_version = @original_gemfile_lines.find do |line|
      line.match?('gem "bullet_train"')
    end

    # Ensure the original bullet_train path stays in the temp Gemfile.
    @temp_gemfile_lines = @temp_gemfile_lines.map do |line|
      if line.match?('gem "bullet_train"')
        @current_bullet_train_gem_version
      else
        line
      end
    end

    # Replace the Gemfile with the temp file.
    File.write("Gemfile", @temp_gemfile_lines.join)
  end

  def teardown
    File.write("Gemfile", @original_gemfile_lines.join)
  end

  # TODO
  test "bin/hack --link Links gems properly to local/bullet_train-core" do
  end
end
