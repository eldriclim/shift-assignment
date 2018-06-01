require 'rails_helper'

RSpec.describe NavigationHelper, :type => :helper do

  context "signed in user" do
    Given { helper.stub(:user_signed_in?).and_return(true) }

    context "#collapsible_links_partial_path" do
      Then {
        expect(helper.collapsible_links_partial_path).to(
            eq 'layouts/navigation/collapsible_elements/signed_in_links')
      }
    end
  end

  context "non-signed in user" do
    Given { helper.stub(:user_signed_in?).and_return(false) }

    context "#collapsible_links_partial_path" do
      Then {
        expect(helper.collapsible_links_partial_path).to(
            eq 'layouts/navigation/collapsible_elements/non_signed_in_links')
      }
    end
  end
end
