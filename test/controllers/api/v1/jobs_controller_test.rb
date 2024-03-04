require "controllers/api/v1/test"

class Api::V1::JobsControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @department = create(:department, team: @team)
  @job = build(:job, department: @department)
  @other_jobs = create_list(:job, 3)

  @another_job = create(:job, department: @department)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @job.save
  @another_job.save

  @original_hide_things = ENV["HIDE_THINGS"]
  ENV["HIDE_THINGS"] = "false"
  Rails.application.reload_routes!
end

def teardown
  super
  ENV["HIDE_THINGS"] = @original_hide_things
  Rails.application.reload_routes!
end

# This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
# data we were previously providing to users _will_ break the test suite.
def assert_proper_object_serialization(job_data)
  # Fetch the job in question and prepare to compare it's attributes.
  job = Job.find(job_data["id"])

  assert_equal_or_nil job_data['name'], job.name
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal job_data["department_id"], job.department_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/departments/#{@department.id}/jobs", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  job_ids_returned = response.parsed_body.map { |job| job["id"] }
  assert_includes(job_ids_returned, @job.id)

  # But not returning other people's resources.
  assert_not_includes(job_ids_returned, @other_jobs[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/jobs/#{@job.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/jobs/#{@job.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  job_data = JSON.parse(build(:job, department: nil).api_attributes.to_json)
  job_data.except!("id", "department_id", "created_at", "updated_at")
  params[:job] = job_data

  post "/api/v1/departments/#{@department.id}/jobs", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/departments/#{@department.id}/jobs",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/jobs/#{@job.id}", params: {
    access_token: access_token,
    job: {
      name: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @job.reload
  assert_equal @job.name, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/jobs/#{@job.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("Job.count", -1) do
    delete "/api/v1/jobs/#{@job.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/jobs/#{@another_job.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
