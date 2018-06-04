require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
  # Create user for login
  Given do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # Test create action
  describe 'post #create' do
    Given!(:deliverer) { FactoryGirl.create_list(:deliverer, 2) }
    Given!(:shift) { FactoryGirl.create(:shift) }

    context 'when no assignment param' do
      When { post :create, params: {} }
      Then { is_expected.to set_flash[:danger] }
    end

    context 'when assignment service failure' do
      When do
        post :create, params: {
          assignment: {
            deliverer_id: deliverer[0].id
          }
        }
      end

      Then { is_expected.to set_flash[:danger] }
      And { is_expected.to redirect_to home_path }
    end

    context 'when assignment service success' do
      When do
        post :create,
             params: {
               assignment: {
                 deliverer_id: deliverer[0].id,
                 shift_id: shift.id
               }
             }
      end

      Then { is_expected.to set_flash[:success] }
      And { is_expected.to redirect_to home_path }
    end
  end

  # Test show action
  describe 'post #show' do
    context 'when invalid date range' do
      When do
        post :show,
             params: {
               range1: {
                 'start_date(3i)' => '23',
                 'start_date(2i)' => '5',
                 'start_date(1i)' => '2018'
               },
               range2: {
                 'end_date(3i)' => '22',
                 'end_date(2i)' => '5',
                 'end_date(1i)' => '2018'
               }
             }
      end

      Then { is_expected.to set_flash[:danger].to('Invalid date range!') }
      And { is_expected.to redirect_to home_path }
    end

    context 'when valid date range' do
      Given!(:shift) { FactoryGirl.create(:shift) }
      Given!(:deliverer) { FactoryGirl.create(:deliverer) }
      Given!(:assignment) do
        FactoryGirl.create(
          :assignment, deliverer_id: deliverer.id, shift_id: shift.id
        )
      end

      # Render views to check for Deliverers and Shifts info
      render_views

      context 'initializes shifts within range' do
        When do
          post :show,
               params: {
                 range1: {
                   'start_date(3i)' => '22',
                   'start_date(2i)' => '5',
                   'start_date(1i)' => '2018'
                 },
                 range2: {
                   'end_date(3i)' => '24',
                   'end_date(2i)' => '5',
                   'end_date(1i)' => '2018'
                 }
               }
        end

        Then { is_expected.not_to set_flash }
        And { expect(response).to render_template('assignments/show') }
        And { expect(response.body).to match('22 May 2018') }
        And { expect(response.body).to match('24 May 2018') }

        # Match Shift info
        And { expect(response.body).to match(shift.start_time_to_s.to_s) }
        And { expect(response.body).to match(shift.end_time_to_s.to_s) }
        And do
          expect(response.body).to match(
            "#{shift.deliverers.count}/#{shift.max_count}"
          )
        end

        # Match Deliverer info within Shift
        And { expect(response.body).to match(deliverer.id.to_s) }
        And { expect(response.body).to match(deliverer.name.to_s) }
        And { expect(response.body).to match(deliverer.phone.to_s) }
      end
    end
  end
end
