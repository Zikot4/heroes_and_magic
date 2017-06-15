FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "#{i}@examp"}
    password "123456"
  end
end
