FactoryBot.define do
  factory :group do
    name { Faker::Team.unique.name }
    description { Faker::Lorem.paragraph }
  end
end
