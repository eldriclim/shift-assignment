require 'rails_helper'

RSpec.describe SharedHelper, :type => :helper do

  describe "#flash_ul" do
    context "when message is array" do
      it "returns an unordered list" do
        expect(
          helper.flash_ul(["message1","message2","message3"])
        ).to eq(
          "<ul><li>message1</li><li>message2</li><li>message3</li></ul>"
        )
      end
    end

    context "when message is a string" do
      it "returns the string" do
        expect(helper.flash_ul("message")).to eq("message")
      end
    end
  end

end
