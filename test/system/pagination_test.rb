require "application_system_test_case"

class PaginationTest < ApplicationSystemTestCase
  def setup
    super
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
    @team = @jane.current_team
  end

  test "pagination works properly" do
    display_details = @@test_devices[:macbook_pro_15_inch]
    resize_for(display_details)

    login_as(@jane, scope: :user)
    visit account_team_path(@jane.current_team)

    click_on "Add New Creative Concept"
    fill_in "Name", with: "Test Name"
    click_on "Create Creative Concept"

    assert page.has_content? "Creative Concept was successfully created."

    creative_concept = @team.scaffolding_absolutely_abstract_creative_concepts.order(:id).last

    # Pagy::DEFAULT[:items] denotes the max of records that exist on one page.
    (Pagy::DEFAULT[:items] + 1).times do |n|
      creative_concept.completely_concrete_tangible_things.create(text_field_value: "Test #{n + 1}")
    end

    # Reload.
    visit current_path

    assert page.has_content?("Test 1")
    refute page.has_content?("Test #{Pagy::DEFAULT[:items] + 1}")

    click_on "Next"
    assert page.has_content?("Test #{Pagy::DEFAULT[:items] + 1}")
  end
end
