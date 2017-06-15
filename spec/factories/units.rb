FactoryGirl.define do
  factory :unit do
    account_id 1      #You must write hash Account here) "create(:unit, account_id: Account.last)"
    variety "Mage"
    hp 50
  end
end
