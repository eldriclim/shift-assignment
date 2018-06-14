FactoryGirl.define do
  factory :deliverer do
    name 'My Name'
    vehicle 1
    sequence(:phone) { |n| ((n + 9_000_001)).to_s }
    sequence(:email) { |n| ((n + 9_000_001)).to_s + '@email.com' }
    active false
  end
end
