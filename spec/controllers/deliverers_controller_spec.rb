require 'rails_helper'

RSpec.describe DeliverersController, type: :controller do
  # Create user for login
  Given do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # Test index action
  describe 'get #index' do
    # Create sample data for display
    Given!(:deliverers) { FactoryGirl.create_list(:deliverer, 3) }

    context 'retrieving models' do
      When { get :index }

      Then { expect(assigns(:deliverers)).to eq(deliverers) }
    end

    # Render views to check for Deliverers info
    render_views

    context 'table views' do
      When { get :index }

      # Check for view partials
      Then { expect(response).to render_template('deliverers/index') }

      And do
        expect(response).to render_template(partial: '_deliverers_table')
      end

      # Identify Deliverers info in view
      And do
        deliverers.each do |d|
          expect(response.body).to match(d.id.to_s)
          expect(response.body).to match(d.name.to_s)
          expect(response.body).to match(d.phone.to_s)
          expect(response.body).to match(d.vehicle.capitalize.to_s)
          expect(response.body).to match(d.active_to_s.to_s)
        end
      end
    end
  end

  # Test index action with params
  describe 'get #index with params' do
    Given!(:deliverers) { FactoryGirl.create_list(:deliverer, 15) }
    Given!(:deliverer_to_search) do
      FactoryGirl.create(:deliverer,
                         name: 'Bobby Lee',
                         phone: 123,
                         vehicle: 2,
                         active: true)
    end

    context 'when query is blank' do
      When do
        get :index, params: {
          query: {
            name_cont: '',
            phone_cont: '',
            vehicle_eq: '',
            active_eq: ''
          }
        }, format: 'js', xhr: true
      end

      Then { expect(assigns(:deliverers).length).to eq 16 }
    end

    context 'when query contains name partial' do
      When { get :index, params: { query: { name_cont: 'le' } } }

      Then { expect(assigns(:deliverers).length).to eq 1 }
    end
    context 'when query contains phone partial' do
      When { get :index, params: { query: { phone_cont: '23' } } }

      Then { expect(assigns(:deliverers).length).to eq 1 }
    end

    context 'when query contains vehicle value' do
      When { get :index, params: { query: { vehicle_eq: 2 } } }

      Then { expect(assigns(:deliverers).length).to eq 1 }
    end

    context 'when query contains active value' do
      When { get :index, params: { query: { active_eq: 'true' } } }

      Then { expect(assigns(:deliverers).length).to eq 1 }
    end
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
      And { is_expected.to redirect_to deliverers_path }
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

      Then { is_expected.to redirect_to deliverers_path }
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
