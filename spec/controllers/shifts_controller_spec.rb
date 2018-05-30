require 'rails_helper'

RSpec.describe ShiftsController, type: :controller do

  # Create user for login
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # Test new action
  describe "get #new" do
    it "initializes a new shift" do
      get :new
      expect(assigns(:shift)).to be_a_new(Shift)
    end
  end

  # Test create action
  describe "post #create" do
    context "with valid attributes" do
      it "creates new shift" do
        expect{
          post :create,
          params: { shift: FactoryGirl.attributes_for(:shift) }
        }.to change{ Shift.count }.by(1)

        is_expected.to redirect_to home_path
      end
    end

    context "with invalid attributes" do
      it "redirects to #new with flash danger" do
        expect{
          post :create,
          params: {
            shift: {
              start_time: "2018-05-23 10:00:00",
              end_time: "2018-05-23 12:00:00",
              max_count: "a"
            }
          }
        }.to change{ Shift.count }.by(0)

        is_expected.to set_flash[:danger]
        is_expected.to redirect_to new_shift_path
      end
    end
  end

  # Test edit action
  describe "get #edit" do
    it "retrieves shift based on its ID" do
      @shift = FactoryGirl.create(:shift)

      get :edit, params: { id: @shift.id }
      
      expect(assigns(:shift)).to eq(@shift)
    end
  end

  # Test update action
  describe "patch #update" do
    before do
      @shift = FactoryGirl.create(:shift)
    end

    context "with valid attributes" do
      it "updates shift's attributes" do
        patch :update,
          params: {
            id: @shift.id,
            shift: FactoryGirl.attributes_for(:shift)
          }

        is_expected.to redirect_to home_path
      end
    end

    context "with invalid attributes" do
      it "redirects to #edit and flash danger" do
        patch :update,
          params: {
            id: @shift.id,
              shift: {
                start_time: "2018-05-23 10:00:00",
                end_time: "2018-05-23 12:00:00",
                max_count: "a"
            }
          }

        is_expected.to set_flash[:danger]
        is_expected.to redirect_to edit_shift_path
      end
    end
  end
end
