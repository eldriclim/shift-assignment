require 'rails_helper'

RSpec.describe SharedHelper, :type => :helper do

  describe "#flash_ul" do
    context "when message is array" do
      Then {
        expect(
          helper.flash_ul(["message1","message2","message3"])
        ).to eq "<ul><li>message1</li><li>message2</li><li>message3</li></ul>"
      }
    end

    context "when message is a string" do
      Then {
        expect(helper.flash_ul("message")).to eq("message")
      }
    end
  end

end
