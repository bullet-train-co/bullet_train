FactoryBot.define do
  factory :address do
    addressable { nil }
    address_one { "1000 Vin Scully Avenue" }
    address_two { nil }
    city { "Los Angeles" }
    region_id { 1416 }
    region_name { "California" }
    country_id { 233 }
    postal_code { "90090" }
  end
end
