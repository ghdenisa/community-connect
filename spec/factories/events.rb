FactoryBot.define do
  factory :event do
    association :group
    association :creator, factory: :user
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    starts_at { Faker::Time.between(from: DateTime.now, to: DateTime.now + 30.days) }
    public { false }

    trait :public do
      public { true }
    end

    trait :past do
      starts_at { Faker::Time.between(from: DateTime.now - 30.days, to: DateTime.now - 1.day) }
    end
  end
end
