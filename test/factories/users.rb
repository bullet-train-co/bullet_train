FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "generic-user-#{n}@example.com" }
    password { '08h4f78hrc0ohw9f8heso' }
    password_confirmation { '08h4f78hrc0ohw9f8heso' }
    sign_in_count { 1 }
    current_sign_in_at { Time.now }
    last_sign_in_at { 1.day.ago }
    current_sign_in_ip { '127.0.0.1' }
    last_sign_in_ip { '127.0.0.2' }
    time_zone { nil }
    factory :onboarded_user do
      first_name { 'First Name' }
      last_name { 'Last Name' }
      after(:create) do |user|
        user.create_default_team
        team = user.current_team
      end
    end
  end
end
