require "application_system_test_case"

class ResolverSystemTest < ApplicationSystemTestCase
  test "`bin/resolve` can resolve `Users::Base`" do
    assert `bin/resolve Users::Base`.include?("app/models/concerns/users/base.rb")
  end

  test "`bin/resolve` can resolve `BulletTrain::Resolver`" do
    assert `bin/resolve BulletTrain::Resolver`.include?("lib/bullet_train/resolver.rb")
  end

  test "`bin/resolve` can resolve `shared/box`" do
    assert `ENABLE_VIEW_ANNOTATION=1 bin/resolve shared/box`.include?("app/views/themes/light/_box.html.erb")
  end
end
