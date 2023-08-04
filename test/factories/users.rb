FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "generic-user-#{n}@example.com" }
    password { "08h4f78hrc0ohw9f8heso" }
    password_confirmation { "08h4f78hrc0ohw9f8heso" }
    sign_in_count { 1 }
    current_sign_in_at { Time.now }
    last_sign_in_at { 1.day.ago }
    current_sign_in_ip { "127.0.0.1" }
    last_sign_in_ip { "127.0.0.2" }
    time_zone { ActiveSupport::TimeZone.all.first.name }
    locale { nil }
    factory :onboarded_user do
      first_name { "First Name" }
      last_name { "Last Name" }
      after(:create) do |user|
        user.create_default_team
      end
      factory :two_factor_user do
        otp_secret { User.generate_otp_secret }
        otp_required_for_login { true }
      end

      factory :user_example do
        first_name { "Example First Name" }
        last_name { "Example Last Name" }
      end
    end
  end
end
