require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AssignmentsHelper. For example:
#
# describe AssignmentsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AssignmentsHelper, type: :helper do

  describe "#print_date_range" do
    date1 = DateTime.parse("2018-05-23 10:00:00")
    date2 = DateTime.parse("2018-05-24 10:00:00")


    context "when start and end is the same day" do
      it "displays a single day in header" do
        expect(helper.print_date_range(date1, date1).to_s).to(
          eq("<strong>On </strong>23 May 2018"))
      end
    end

    context "when start and end is one different days" do
      it "displays both days in header" do
        expect(helper.print_date_range(date1, date2).to_s).to(
          eq("<strong>From </strong>23 May 2018<strong> to </strong>24 May 2018"))
      end
    end
  end

end
