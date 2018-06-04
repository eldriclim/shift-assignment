require 'rails_helper'

RSpec.describe Shift, type: :model do
  # Base setup for Shift
  Given!(:shift) do
    described_class.new(
      start_time: Time.zone.today.at_beginning_of_day,
      end_time: Time.zone.today.at_end_of_day,
      max_count: 10
    )
  end

  # Test association
  it { is_expected.to have_many(:assignments) }
  it { is_expected.to have_many(:deliverers).through(:assignments) }

  # Test Start time attribute
  it { is_expected.to validate_presence_of(:start_time) }
  it {
    is_expected.to(
      validate_uniqueness_of(:start_time).scoped_to(:end_time).
        with_message('Shift already exist')
    )
  }

  # Test End time
  it { is_expected.to validate_presence_of(:end_time) }

  # Test Start-End time condition
  context 'start and end time validation' do
    context 'start and end time is the same' do
      When do
        shift.end_time = Time.zone.today.at_beginning_of_day
      end

      Then { expect(shift).to be_invalid }
      And do
        expect(shift.errors[:start_time]).to(
          include('Start time and End time cannot be the same')
        )
      end
    end

    context 'start time is after end time' do
      When do
        shift.start_time = Time.zone.tomorrow.at_beginning_of_day
      end

      Then { expect(shift).to be_invalid }

      And do
        expect(shift.errors[:start_time]).to(
          include('Start time cannot be after End time')
        )
      end
    end
  end

  # Test Max count
  it {
    is_expected.to validate_presence_of(:max_count).
      with_message('Max count field is empty')
  }
  it {
    is_expected.to(
      validate_numericality_of(:max_count).only_integer.
        with_message('Max count has to be an integer')
    )
  }

  it {
    is_expected.to(
      validate_numericality_of(:max_count).is_greater_than(0).
        with_message('Max count has to be greater than 0')
    )
  }

  # Test instance methods
  describe '#max' do
    Given!(:shift) { FactoryGirl.create(:shift) }

    context 'when shift not maxed' do
      Then { expect(shift.max?).to eq(false) }
    end

    context 'when shift maxed' do
      When { Shift.any_instance.stub_chain(:deliverers, :count).and_return(2) }

      Then { expect(shift.max?).to eq(true) }
    end
  end

  describe '#start_time_to_s' do
    When do
      shift.start_time = Time.zone.parse('2018-05-24 10:00:00')
    end

    Then { expect(shift.start_time_to_s).to eq('2018-05-24 10:00:00') }
  end

  describe '#end_time_to_s' do
    When do
      shift.end_time = Time.zone.parse('2018-05-24 10:00:00')
    end

    Then { expect(shift.end_time_to_s).to eq('2018-05-24 10:00:00') }
  end
end
