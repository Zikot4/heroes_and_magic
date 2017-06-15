FactoryGirl.define do
  factory :lobby do
    association(:user)
    count_of_users  2
    game_mode 3
    hidden false
    sequence(:url) { |i| "q#{i}q1" }
  end
end
