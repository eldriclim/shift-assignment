require 'rails_helper'

RSpec.describe SharedHelper, type: :helper do
  describe '#flash_ul' do
    context 'when message is array' do
      context 'when array length is 1' do
        Then do
          expect(
            helper.flash_ul(%w[message1])
          ).to eq 'message1'
        end
      end

      context 'when array length is greater than 1' do
        Then do
          expect(
            helper.flash_ul(%w[message1 message2 message3])
          ).to eq '<ul><li>message1</li><li>message2</li><li>message3</li></ul>'
        end
      end
    end

    context 'when message is a string' do
      Then do
        expect(helper.flash_ul('message')).to eq('message')
      end
    end
  end
end
