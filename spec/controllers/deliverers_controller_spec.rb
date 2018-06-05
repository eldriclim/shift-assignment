require 'rails_helper'

RSpec.describe DeliverersController, type: :controller do

  # Create user for login
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # Test new action
  describe "get #new" do
    it "initializes a new deliverer" do
      get :new

      expect(assigns(:deliverer)).to be_a_new(Deliverer)
    end
  end

  # Test create action
  describe "post #create" do

    context "with valid attributes" do
      it "creates new deliverer" do
        expect{
          post :create,
          params: { deliverer: FactoryGirl.attributes_for(:deliverer) },
          as: :json
        }.to change{ Deliverer.count }.by(1)

        is_expected.to redirect_to home_path
      end
    end

    context "with invalid attributes" do
      it "redirects to #new with flash danger" do
        expect{
          post :create,
          params: {
            deliverer: {
              name: "My Name",
              vehicle: 1,
              phone: "a",
              active: false
            }
          },
          as: :json
        }.to change{ Deliverer.count }.by(0)

        is_expected.to set_flash[:danger]
        is_expected.to redirect_to new_deliverer_path

      end
    end
  end

  # Test edit action
  describe "get #edit" do
    it "retrieves deliverer based on its ID" do
      @deliverer = FactoryGirl.create(:deliverer)

      get :edit, params: { :id => @deliverer.id }

      expect(@deliverer).to eq(assigns(:deliverer))

    end
  end

  # Test update action
  describe "patch #update" do
    before do
      @deliverer = FactoryGirl.create(:deliverer)
    end

    context "with valid attributes" do
      it "update deliverer's attributes" do

        patch :update,
          params: {
            :id => @deliverer.id,
            deliverer: FactoryGirl.attributes_for(:deliverer)
          },
          as: :json

        is_expected.to redirect_to home_path
      end
    end

    context "with invalid attributes" do
      it "redirects to #edit and flash danger" do

        patch :update,
          params: {
            :id => @deliverer.id,
            deliverer: {
              name: "My Name",
              vehicle: 1,
              phone: "a",
              active: false
            }
          },
          as: :json

        is_expected.to set_flash[:danger]
        is_expected.to redirect_to edit_deliverer_path

      end
    end
  end
end
