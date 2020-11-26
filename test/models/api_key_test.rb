require "test_helper"

describe ApiKey do

  subject { create(:api_key) }

  it { must belong_to(:user) }

  it '#active' do
    assert_respond_to(ApiKey, :active)
    assert_includes ApiKey.active, subject
    refute_includes ApiKey.active, create(:inactive_api_key)
  end

  it 'must be valid' do
    value(subject).must_be :valid?
  end
end
