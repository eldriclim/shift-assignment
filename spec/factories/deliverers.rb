FactoryGirl.define do
  factory :deliverer do
    name "My Name"
    vehicle 1
    sequence(:phone) { |n| "#{(n+9000001)}"}
    active false
  end
end
