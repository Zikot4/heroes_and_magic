FactoryGirl.define do
  factory :account do
    association(:user)
  end
end
