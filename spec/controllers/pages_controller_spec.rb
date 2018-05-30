require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  # Create user for login
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "get #home" do
    before do
      @deliverers = FactoryGirl.create_list(:deliverer, 3)
      @shifts = FactoryGirl.create_list(:shift, 3)
    end

    it "displays all Deliverers and Shifts" do

      get :home
      expect(assigns(:deliverers)).to eq(@deliverers)
      expect(assigns(:shifts)).to eq(@shifts)
      expect(assigns(:assignment)).to be_a_new(Assignment)
    end
  end

end
