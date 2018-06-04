require 'rails_helper'

RSpec.describe DeliverersController, type: :controller do
  # Create user for login
  Given do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # Test new action
  describe 'get #new' do
    When { get :new }

    Then { expect(assigns(:deliverer)).to be_a_new(Deliverer) }
  end

  # Test create action
  describe 'post #create' do
    context 'with valid attributes' do
      When do
        post :create, params: {
          deliverer: FactoryGirl.attributes_for(:deliverer)
        }, as: :json
      end

      Then { expect(Deliverer.count).to eq 1 }
      And { is_expected.to redirect_to home_path }
    end

    context 'with invalid attributes' do
      When do
        post :create, params: {
          deliverer: {
            name: 'My Name',
            vehicle: 1,
            phone: 'a',
            active: false
          }
        }, as: :json
      end

      Then { expect(Deliverer.count).to eq 0 }
      And { is_expected.to set_flash[:danger] }
      And { is_expected.to redirect_to new_deliverer_path }
    end
  end

  # Test edit action
  describe 'get #edit' do
    Given!(:deliverer) { FactoryGirl.create(:deliverer) }

    When { get :edit, params: { id: deliverer.id } }

    Then { expect(deliverer).to eq(assigns(:deliverer)) }
  end

  # Test update action
  describe 'patch #update' do
    Given!(:deliverer) { FactoryGirl.create(:deliverer) }

    context 'with valid attributes' do
      When do
        patch :update,
              params: {
                id: deliverer.id,
                deliverer: FactoryGirl.attributes_for(:deliverer)
              },
              as: :json
      end

      Then { is_expected.to redirect_to home_path }
    end

    context 'with invalid attributes' do
      When do
        patch :update,
              params: {
                id: deliverer.id,
                deliverer: {
                  name: 'My Name',
                  vehicle: 1,
                  phone: 'a',
                  active: false
                }
              },
              as: :json
      end

      Then { is_expected.to set_flash[:danger] }
      And { is_expected.to redirect_to edit_deliverer_path }
    end
  end
end
