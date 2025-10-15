require "application_system_test_case"

class ResolverSystemTest < ApplicationSystemTestCase
  test "`bin/resolve` can resolve `Users::Base`" do
    assert `bin/resolve Users::Base`.include?("app/models/concerns/users/base.rb")
  end

  test "`bin/resolve` can resolve `BulletTrain::Resolver`" do
    assert `bin/resolve BulletTrain::Resolver`.include?("lib/bullet_train/resolver.rb")
  end

  test "bin/resolve can resolve `shared/attributes/text`" do
    relative_view_path = "app/views/themes/base/attributes/_text.html.erb"
    local_view_path = Dir.glob("#{Rails.root}/app/views/**/*/attributes/_text.html.erb").pop
    if local_view_path
      assert `bin/resolve shared/attributes/text`.include?(local_view_path)
    else
      themes_gem = Gem::Specification.find_by_name("bullet_train-themes").gem_dir
      absolute_path = themes_gem + "/" + relative_view_path
      assert `bin/resolve shared/attributes/text`.include?(absolute_path)
    end
  end

  unless ENV["SKIP_RESOLVE_TEST"].present?
    test "`bin/resolve` can resolve `shared/box`" do
      # TODO Figure out how to make this test pass when we're working on a checked out copy of the theme.
      # TODO Figure out how to make this test pass when using a theme other than Light that overrides the box partial.
      assert `ENABLE_VIEW_ANNOTATION=1 bin/resolve shared/box`.include?("app/views/themes/light/_box.html.erb")
    end
  end
end
