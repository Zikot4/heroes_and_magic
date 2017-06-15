FactoryGirl.define do
  factory :buff do
    association(:unit)
    name  "ArcaneMagicBuff"
    variety :damage
  end
end
