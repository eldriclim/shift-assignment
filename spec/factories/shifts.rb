FactoryGirl.define do
  factory :shift do
    sequence(:start_time) do |n|
      (Time.zone.parse('2018-05-23 10:00:00') +
        (n * 2).hours).strftime('%Y-%m-%d %T')
    end
    sequence(:end_time) do |n|
      (Time.zone.parse('2018-05-23 12:00:00') +
        (n * 2).hours).strftime('%Y-%m-%d %T')
    end
    max_count 2
    deliverers_count 0
  end
end
