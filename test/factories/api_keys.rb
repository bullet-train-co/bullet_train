FactoryBot.define do
  factory :api_key do
    user
    last_used_at { "2017-11-04 15:56:20" }
    after(:create) do |api_key, evaluator|
      api_key.generate_encrypted_secret(evaluator.respond_to?(:secret) ? evaluator.secret : nil)
    end
    factory :inactive_api_key do
      revoked_at { "2017-11-04 15:56:20" }
    end
  end
end
