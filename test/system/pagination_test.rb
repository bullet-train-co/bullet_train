require "application_system_test_case"

class PaginationTest < ApplicationSystemTestCase
  def setup
    super
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
    @team = @jane.current_team
  end

  unless scaffolding_things_disabled?
    test "pagination works properly" do
      display_details = @@test_devices[:macbook_pro_15_inch]
      resize_for(display_details)
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

      assert page.has_content?("Test 1")
      refute page.has_content?("Test #{Pagy::DEFAULT[:items] + 1}")

      click_on "Next"
      assert page.has_content?("Test #{Pagy::DEFAULT[:items] + 1}")
    end
  end
end
