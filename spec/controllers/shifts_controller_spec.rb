require 'rails_helper'

RSpec.describe ShiftsController, type: :controller do
  # Create user for login
  Given do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # Test index action
  describe 'get #index' do
    # Create sample data for display
    Given!(:shifts) { FactoryGirl.create_list(:shift, 3) }

    context 'retrieving models' do
      When { get :index }

      Then { expect(assigns(:shifts)).to eq(shifts) }
    end

    # Render views to check for Shifts info
    render_views

    context 'table views' do
      When { get :index }

      # Check for view partials
      Then { expect(response).to render_template('shifts/index') }

      And do
        expect(response).to render_template(partial: 'shifts/_shifts_table')
      end

      # Identify Shifts info in view
      And do
        shifts.each do |s|
          expect(response.body).to match(s.id.to_s)
          expect(response.body).to match(s.start_time_to_s.to_s)
          expect(response.body).to match(s.end_time_to_s.to_s)
          expect(response.body).to match("#{s.deliverers.count}/#{s.max_count}")
        end
      end
    end
  end

  # Test new action
  describe 'get #new' do
    When { get :new }
    Then { expect(assigns(:shift)).to be_a_new(Shift) }
  end

  # Test create action
  describe 'post #create' do
    context 'with valid attributes' do
      When do
        post :create,
             params: { shift: FactoryGirl.attributes_for(:shift) }
      end

      Then { expect(Shift.count).to eq 1 }
      And { is_expected.to set_flash[:success] }
      And { is_expected.to redirect_to shifts_path }
    end

    context 'with invalid attributes' do
      When do
        post :create,
             params: {
               shift: {
                 start_time: '2018-05-23 10:00:00',
                 end_time: '2018-05-23 12:00:00',
                 max_count: 'a'
               }
             }
      end

      Then { expect(Shift.count).to eq 0 }
      And { is_expected.to set_flash[:danger] }
      And { is_expected.to redirect_to new_shift_path }
    end
  end

  # Test edit action
  describe 'get #edit' do
    Given!(:shift) { FactoryGirl.create(:shift) }

    When { get :edit, params: { id: shift.id } }

    Then { expect(assigns(:shift)).to eq(shift) }
  end

  # Test update action
  context 'patch #update' do
    Given(:shift) { FactoryGirl.create(:shift) }

    context 'with valid attributes' do
      When do
        patch :update,
              params: {
                id: shift.id,
                shift: FactoryGirl.attributes_for(:shift)
              }
      end

      Then { is_expected.to set_flash[:success] }
      And { is_expected.to redirect_to shifts_path }
    end

    context 'with invalid attributes' do
      When do
        patch :update,
              params: {
                id: shift.id,
                shift: {
                  start_time: '2018-05-23 10:00:00',
                  end_time: '2018-05-23 12:00:00',
                  max_count: 'a'
                }
              }
      end

      Then { is_expected.to set_flash[:danger] }
      And { is_expected.to redirect_to edit_shift_path }
    end
  end

  # Test /api/available_shifts
  describe 'get #available_shifts' do
    Given!(:shift) { FactoryGirl.create(:shift) }

    context 'missing params' do
      When { get :available_shifts }
      When(:json) { JSON.parse(response.body) }

      Then { expect(json['status']).to eq 'Error: Missing arguments' }
    end

    context 'successful call' do
      When do
        get :available_shifts,
            params: {
              start_time: '2016-05-23',
              end_time: '2019-05-23'
            }
      end

      When(:json) { JSON.parse(response.body) }

      # ID comparison is used as expected json object is result of render
      Then { expect(json['status']).to eq 'OK' }
      And { expect(json['shifts'][0]['id']).to eq shift.id }
    end
  end
end
