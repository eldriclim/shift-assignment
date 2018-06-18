FactoryGirl.define do
  factory :deliverer do
    name 'My Name'
    vehicle 1
    sequence(:phone) { |n| ((n + 9_000_001)).to_s }
    active false
    shifts_count 0
  end
end
