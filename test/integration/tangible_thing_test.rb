require 'test_helper'

class AccountTest < ActionDispatch::IntegrationTest
  @@test_devices.each do |device_name, display_details|
    test "create a new account on a #{device_name}" do
      new_user = build :user

      resize_for(display_details)

      visit root_path

      click_on "Don't have an account?"
      fill_in 'Your Email Address', with: 'me@acme.com'
      fill_in 'Set Password', with: 'password123'
      fill_in 'Confirm Password', with: 'password123'
      click_on 'Sign Up'
      fill_in 'Your First Name', with: 'John'
      fill_in 'Your Last Name', with: 'Doe'
      fill_in 'Your Team Name', with: 'My Super Team'
      page.select 'Brisbane', from: 'Your Time Zone'
      click_on 'Next'

      click_on 'Add New Creative Concept'
      fill_in 'Name', with: 'My Generic Creative Concept'
      fill_in 'Description', with: 'Dummy description for my creative concept'
      click_on 'Create Creative Concept'

      click_on 'Add New Tangible Thing'
      fill_in 'Text Field Value', with: 'My value for this text field'
      click_on 'Three'
      fill_in 'Date Field Value', with: '01/17/2021'
      fill_in 'Email Field Value', with: 'me@acme.com'

      fill_in 'Password Field Value', with: 'secure-password'
      fill_in 'Phone Field Value', with: '(201) 551-8321'
      page.select 'Two', from: 'Select Value'
      page.select 'Three', from: 'Super Select Value'
      fill_in 'Text Area Value', with: 'Long text for this text area field'

      click_on 'Create Tangible Thing'

      assert page.has_content?('Tangible Thing was successfully created.')

      tangible_thing = Scaffolding::CompletelyConcrete::TangibleThing.last

      visit account_scaffolding_completely_concrete_tangible_thing_path(tangible_thing)

      assert page.has_content?('My value for this text field')
      assert page.has_content?('three')
      assert page.has_content?('me@acme.com')
      assert page.has_content?('+12015518321')
      assert page.has_content?('two')
      assert page.has_content?('three')
      assert page.has_content?('Long text for this text area field')
    end
  end
end