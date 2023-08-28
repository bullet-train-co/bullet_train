require "controllers/api/v1/test"

class Api::V1::SectionsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @site = create(:site, team: @team)
    @page = create(:page, site: @site)
    @section = build(:section, page: @page)
    @other_sections = create_list(:section, 3)

    @another_section = create(:section, page: @page)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @section.save
    @another_section.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(section_data)
    # Fetch the section in question and prepare to compare it's attributes.
    section = Section.find(section_data["id"])

    assert_equal_or_nil section_data["title"], section.title
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal section_data["page_id"], section.page_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/pages/#{@page.id}/sections", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    section_ids_returned = response.parsed_body.map { |section| section["id"] }
    assert_includes(section_ids_returned, @section.id)

    # But not returning other people's resources.
    assert_not_includes(section_ids_returned, @other_sections[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/sections/#{@section.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/sections/#{@section.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    section_data = JSON.parse(build(:section, page: nil).api_attributes.to_json)
    section_data.except!("id", "page_id", "created_at", "updated_at")
    params[:section] = section_data

    post "/api/v1/pages/#{@page.id}/sections", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/pages/#{@page.id}/sections",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/sections/#{@section.id}", params: {
      access_token: access_token,
      section: {
        title: "Alternative String Value",
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @section.reload
    assert_equal @section.title, "Alternative String Value"
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/sections/#{@section.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Section.count", -1) do
      delete "/api/v1/sections/#{@section.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/sections/#{@another_section.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
