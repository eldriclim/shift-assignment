require 'rails_helper'

RSpec.describe AvailableShiftsApi do
  describe '#perform' do
    Given!(:shift) { FactoryGirl.create(:shift) }

    context 'invalid argument' do
      Then do
        expect(AvailableShiftsApi.new('', '').perform).to(
          eq(status: 'Error: Invalid arguments')
        )
      end
      And do
        expect(AvailableShiftsApi.new('2018-05-24', '').perform).to(
          eq(status: 'Error: Invalid arguments')
        )
      end
      And do
        expect(AvailableShiftsApi.new('', '2018-05-24').perform).to(
          eq(status: 'Error: Invalid arguments')
        )
      end
    end

    context 'invalid range' do
      Then do
        expect(AvailableShiftsApi.new('2019-05-24', '2018-05-24').perform).to(
          eq(status: 'Error: Invalid date range')
        )
      end
    end

    context 'output not empty' do
      When(:output) { AvailableShiftsApi.new('2018-05-25', '2018-05-25').perform }

      Then { expect(output[:status]).to eq 'OK' }
      And { expect(output[:shifts]).to eq [shift] }
    end

    context 'output empty' do
      context 'not in range' do
        When(:output) { AvailableShiftsApi.new('2019-05-25', '2019-05-25').perform }

        Then { expect(output[:status]).to eq 'OK' }
        And { expect(output[:shifts]).to eq [] }
      end

      context 'all maxed' do
        # Stub for #max? to return true
        When { allow_any_instance_of(Shift).to receive(:max?).and_return(true) }
        When(:output) { AvailableShiftsApi.new('2018-05-25', '2018-05-25').perform }

        Then { expect(output[:status]).to eq 'OK' }
        And { expect(output[:shifts]).to eq [] }
      end
    end
  end
end
