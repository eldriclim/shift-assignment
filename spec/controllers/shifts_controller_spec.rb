require 'rails_helper'

RSpec.describe ShiftsController, type: :controller do

  # Create user for login
  Given {
    @user = FactoryGirl.create(:user)
    sign_in @user
  }

  # Test new action
  describe "get #new" do
    When { get :new }
    Then { expect(assigns(:shift)).to be_a_new(Shift) }
  end

  # Test create action
  describe "post #create" do
    context "with valid attributes" do
      When {
        post :create,
        params: { shift: FactoryGirl.attributes_for(:shift) }
      }

      Then { expect(Shift.count).to eq 1 }

      And { is_expected.to redirect_to home_path }
    end

    context "with invalid attributes" do
      When {
        post :create,
        params: {
          shift: {
            start_time: "2018-05-23 10:00:00",
            end_time: "2018-05-23 12:00:00",
            max_count: "a"
          }
        }
      }

      Then { expect(Shift.count).to eq 0 }
      And { is_expected.to set_flash[:danger] }
      And { is_expected.to redirect_to new_shift_path }
    end
  end

  # Test edit action
  describe "get #edit" do
    Given!(:shift) { FactoryGirl.create(:shift) }

    When { get :edit, params: { id: shift.id } }

    Then { expect(assigns(:shift)).to eq(shift) }
  end

  # Test update action
  context "patch #update" do
    Given(:shift) { FactoryGirl.create(:shift) }

    context "with valid attributes" do
      When {
        patch :update,
          params: {
            id: shift.id,
            shift: FactoryGirl.attributes_for(:shift)
          }
      }

      Then { is_expected.to redirect_to home_path }
    end

    context "with invalid attributes" do
      When {
        patch :update,
          params: {
            id: shift.id,
              shift: {
                start_time: "2018-05-23 10:00:00",
                end_time: "2018-05-23 12:00:00",
                max_count: "a"
            }
          }
      }

      Then { is_expected.to set_flash[:danger] }
      And { is_expected.to redirect_to edit_shift_path }
    end
  end
end
