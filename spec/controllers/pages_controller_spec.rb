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

    render_views

    context "table views" do
      it "displays Deliverers and Shifts info" do
        get :home
        @deliverers.each do |d|
          expect(response.body).to match("#{d.id}")
          expect(response.body).to match("#{d.name}")
          expect(response.body).to match("#{d.phone}")
          expect(response.body).to match("#{d.vehicle_to_s}")
          expect(response.body).to match("#{d.active_to_s}")
        end
        @shifts.each do |s|
          expect(response.body).to match("#{s.id}")
          expect(response.body).to match("#{s.start_time_to_s}")
          expect(response.body).to match("#{s.end_time_to_s}")
          expect(response.body).to match("#{s.deliverer.count}/#{s.max_count}")
        end
      end
    end
  end

end