FactoryGirl.define do
  factory :shift do
    sequence(:start_time) { |n| (DateTime.parse("2018-05-23 10:00:00") + (n*2).hours).strftime("%Y-%m-%d %T") }
    sequence(:end_time) { |n| (DateTime.parse("2018-05-23 12:00:00") + (n*2).hours).strftime("%Y-%m-%d %T") }
    max_count 2
  end
end
