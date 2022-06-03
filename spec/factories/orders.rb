FactoryBot.define do

  factory :order do
    association :merchant
    association :shopper
    amount { '445.5' }

    trait :incomplete do
      completed_at { nil }
    end

    trait :complete do
      completed_at { Time.now }
    end
  end

end
