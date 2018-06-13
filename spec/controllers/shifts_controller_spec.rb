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
    Given!(:shifts) { FactoryGirl.create_list(:shift, 26) }

    # Render views to check for Shifts info
    render_views

    context 'table views' do
      When { get :index }

      # Check for view partials
      Then { expect(response).to render_template('shifts/index') }

      And { expect(response).to render_template(partial: 'shifts/_shifts_table') }

      # Identify Shifts info in view
      And do
        shifts.each_with_index do |s, index|
          # Since default page limit is 25
          break if index == 25

          expect(response.body).to match(s.id.to_s)
          expect(response.body).to match(s.start_time_to_s.to_s)
          expect(response.body).to match(s.end_time_to_s.to_s)
          expect(response.body).to match("#{s.deliverers.count}/#{s.max_count}")
        end
      end
    end

    context 'check for page 2' do
      When do
        get :index, params: {
          page: 2,
          limit: 25
        }
      end

      # Check for the 26th shift on the second page, since limit is 25
      Then { expect(assigns(:shifts).count).to eq 1 }

      And { expect(response).to render_template('shifts/index') }
      And { expect(response).to render_template(partial: 'shifts/_shifts_table') }

      # Match Shift info
      And { expect(response.body).to match(shifts[25].id.to_s) }
      And { expect(response.body).to match(shifts[25].start_time_to_s.to_s) }
      And { expect(response.body).to match(shifts[25].end_time_to_s.to_s) }
      And do
        expect(response.body).to match(
          "#{shifts[25].deliverers.count}/#{shifts[25].max_count}"
        )
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
end
