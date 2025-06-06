require "application_system_test_case"
require "pagy"

class PaginationTest < ApplicationSystemTestCase
  setup do
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
    @team = @jane.current_team

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  teardown do
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  device_test "pagination works properly" do
    login_as(@jane, scope: :user)

    creative_concept = @team.scaffolding_absolutely_abstract_creative_concepts.create(name: "Test Name")

    # Pagy::DEFAULT[:items] denotes the max of records that exist on one page.
    (Pagy::DEFAULT[:items] + 1).times do |n|
      creative_concept.completely_concrete_tangible_things.create(text_field_value: "Test #{n + 1}")
    end

    visit root_path
    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
        sleep 2
      end
    end

    visit account_scaffolding_absolutely_abstract_creative_concept_path(creative_concept)

    assert_text("Test 1")
    refute_text("Test #{Pagy::DEFAULT[:items] + 1}")

    click_on "2"
    assert_text("Test #{Pagy::DEFAULT[:items] + 1}")
  end
end
