require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  # Create user for login
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "get #home" do

    # Create sample data for display
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

        # Check for view partials
        expect(response).to render_template("pages/home")
        expect(response).to render_template(partial: "pages/_deliverers_table")
        expect(response).to render_template(partial: "pages/_shifts_table")
        expect(response).to render_template(partial: "pages/_shift_assignment_form")
        expect(response).to render_template(partial: "pages/_view_assignment_form")

        # Identify Deliverers info in view
        @deliverers.each do |d|
          expect(response.body).to match("#{d.id}")
          expect(response.body).to match("#{d.name}")
          expect(response.body).to match("#{d.phone}")
          expect(response.body).to match("#{d.vehicle_to_s}")
          expect(response.body).to match("#{d.active_to_s}")
        end

        # Identify Shifts info in view
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
