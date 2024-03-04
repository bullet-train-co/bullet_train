FactoryBot.define do
  factory :jobs_assigned_resource, class: 'Jobs::AssignedResource' do
    job { nil }
    resource { nil }
  end
end
