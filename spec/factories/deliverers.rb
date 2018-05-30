FactoryGirl.define do
  factory :deliverer do
    name "My Name"
    vehicle 1
    sequence(:phone) { |n| "#{n}"}
    active false
  end
end
