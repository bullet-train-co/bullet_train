FactoryBot.define do
  factory :api_key do
    user
    token { "MyString" }
    secret { "MyString" }
    last_used_at { "2017-11-04 15:56:20" }
    factory :inactive_api_key do
      revoked_at { "2017-11-04 15:56:20" }
    end
  end
end
