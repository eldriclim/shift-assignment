require 'rails_helper'

RSpec.describe DeliverersHelper, type: :helper do
  describe '#shifts_on_date' do
    Given!(:shift_today) do
      time = Time.zone.now - 2.days
      FactoryGirl.create(:shift, start_time: time, end_time: time + 2.hours)
    end
    Given!(:shift_tomorrow) do
      time = Time.zone.now - 1.day
      FactoryGirl.create(:shift, start_time: time, end_time: time + 2.hours)
    end

    Then do
      expect(
        shifts_on_date([shift_today, shift_tomorrow], (Time.zone.today - 2.days))
      ).to eq [shift_today]
    end
  end

  describe '#time_range_to_s' do
    Given!(:shifts) { FactoryGirl.create_list(:shift, 2) }

    When(:output) { time_range_to_s(shifts) }

    Then do
      expect(output).to(
        eq ["#{shifts[0].start_time.strftime('%H:%M %p')} -" +
              " #{shifts[0].end_time.strftime('%H:%M %p')}",
            "#{shifts[1].start_time.strftime('%H:%M %p')} -" +
              " #{shifts[1].end_time.strftime('%H:%M %p')}"]
      )
    end
  end

  describe '#time_taken' do
    context 'shift exist' do
      Given!(:shifts) { FactoryGirl.create_list(:shift, 2) }

      Then(:output) { expect(time_taken(shifts)).to eq '4.0' }
    end

    context 'no shift exist' do
      Then(:output) { expect(time_taken([])).to eq '0' }
    end
  end
end
