require "application_system_test_case"

class AnimationsTest < ApplicationSystemTestCase
  def setup
    super
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
    @team = @jane.current_team
  end

  test "mobile menu works properly" do
    # TODO: Unfortunately we have to skip this test when using Cuprite because
    # the `obscured?` method below has not been implemented in the driver yet.
    skip unless Capybara.current_driver.to_s.include?("selenium")

    display_details = {resolution: [750, 1334], mobile: true, high_dpi: true}
    animation_duration = 0.5
    resize_display(display_details)
    login_as(@jane, scope: :user)
    visit root_path
    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
        sleep 2
      end
    end

    visit account_team_path(@jane.current_team)

    els = {
      open_button: first("#mobile-menu-open", visible: false),
      close_button: first("#mobile-menu-close", visible: false),
      backdrop: first("#mobile-menu-backdrop", visible: false)
    }

    3.times do |i|
      assert_not els[:open_button].obscured?, "open_button should not initially be obscured on iteration #{i}"
      [:close_button, :backdrop].each do |key|
        assert_not els[key].visible?, "#{key} should initially be hidden on iteration #{i}"
      end

      els[:open_button].click

      sleep(animation_duration)

      assert els[:open_button].obscured?, "open_button should be obscured after mobile menu open on iteration #{i}"
      [:close_button, :backdrop].each do |key|
        assert els[key].visible?, "#{key} should be visible after mobile menu open on iteration #{i}"
      end

      els[:close_button].click

      sleep(animation_duration)
    end
  end
end
