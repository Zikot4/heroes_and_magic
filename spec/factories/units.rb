FactoryGirl.define do
  factory :unit do
    account_id (:account)
    variety "Mage"
    hp 50

    trait :priest do
      variety "Priest"
    end
    trait :dead do
      dead true
    end
  end
end
