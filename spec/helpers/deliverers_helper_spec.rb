require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the DeliverersHelper. For example:
#
# describe DeliverersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe DeliverersHelper, type: :helper do

  describe '#vehicle_helper' do
    context 'input 0' do
      it 'returns Motorbike' do
        expect(helper.vehicle_helper(0)).to eq("Motorbike")
      end
    end

    context 'input 1' do
      it 'returns Bicycle' do
        expect(helper.vehicle_helper(1)).to eq("Bicycle")
      end
    end

    context 'input 2' do
      it 'returns Scooter' do
        expect(helper.vehicle_helper(2)).to eq("Scooter")
      end
    end
  end

  describe '#active_helper' do
    context 'input true' do
      it 'returns Active' do
        expect(helper.active_helper(true)).to eq("Active")
      end
    end

    context 'input false' do
      it 'returns Inactive' do
        expect(helper.active_helper(false)).to eq("Inactive")
      end
    end

  end
end
