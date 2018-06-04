require 'rails_helper'

RSpec.describe AssignmentsHelper, type: :helper do
  describe '#print_date_range' do
    Given!(:date1) { Time.parse('2018-05-23 10:00:00') }
    Given!(:date2) { Time.parse('2018-05-24 10:00:00') }

    context 'when start and end is the same day' do
      Then do
        expect(helper.print_date_range(date1, date1).to_s).to(
          eq('<strong>On </strong>23 May 2018')
        )
      end
    end

    context 'when start and end is one different days' do
      Then do
        expect(helper.print_date_range(date1, date2).to_s).to(
          eq('<strong>From </strong>23 May 2018" +
            "<strong> to </strong>24 May 2018')
        )
      end
    end
  end
end
