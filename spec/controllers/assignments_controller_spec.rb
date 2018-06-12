require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
  # Create user for login
  Given do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # Test new action
  describe 'get #new' do
    Given { FactoryGirl.create_list(:deliverer, 3) }
    Given { FactoryGirl.create_list(:shift, 3) }

    When { get :new }

    Then { expect(assigns(:deliverers).count).to eq 3 }
    And { expect(assigns(:shifts).count).to eq 3 }
    And { expect(assigns(:assignment)).to be_a_new(Assignment) }
  end

  # Test create action
  describe 'post #create' do
    Given!(:deliverer) { FactoryGirl.create_list(:deliverer, 2) }
    Given!(:shift) { FactoryGirl.create(:shift) }

    context 'when no assignment param' do
      When { post :create, params: {} }

      Then { is_expected.to set_flash[:danger] }
      And { is_expected.to redirect_to new_assignment_path }
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
      And { is_expected.to redirect_to new_assignment_path }
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
      And { is_expected.to redirect_to new_assignment_path }
    end
  end

  # Test index action
  describe 'get #index' do
    context 'when invalid date range' do
      When do
        get :index,
            params: {
              range1: {
                'date(3i)' => '23',
                'date(2i)' => '5',
                'date(1i)' => '2018'
              },
              range2: {
                'date(3i)' => '22',
                'date(2i)' => '5',
                'date(1i)' => '2018'
              }
            }
      end

      Then { is_expected.to set_flash[:danger].to('Invalid date range!') }
      And { is_expected.to redirect_to assignments_path }
    end

    context 'when valid date range' do
      Given!(:shifts) { FactoryGirl.create_list(:shift, 26) }
      Given!(:deliverer) { FactoryGirl.create(:deliverer) }
      Given!(:assignment) do
        FactoryGirl.create(
          :assignment, deliverer_id: deliverer.id, shift_id: shifts[0].id
        )
      end

      # Render views to check for Deliverers and Shifts info
      render_views

      context 'initializes shifts within range' do
        When do
          get :index, params: {
            range1: {
              'date(3i)' => '22',
              'date(2i)' => '5',
              'date(1i)' => '2018'
            },
            range2: {
              'date(3i)' => '24',
              'date(2i)' => '5',
              'date(1i)' => '2018'
            }
          }
        end

        Then { is_expected.not_to set_flash }
        And { expect(response).to render_template('assignments/index') }
        And { expect(response.body).to match('22 May 2018') }
        And { expect(response.body).to match('24 May 2018') }

        # Match Shift info
        And { expect(response.body).to match(shifts[0].id.to_s) }
        And { expect(response.body).to match(shifts[0].start_time_to_s.to_s) }
        And { expect(response.body).to match(shifts[0].end_time_to_s.to_s) }
        And do
          expect(response.body).to match(
            "#{shifts[0].deliverers.count}/#{shifts[0].max_count}"
          )
        end

        # Match Deliverer info within Shift
        And { expect(response.body).to match(deliverer.id.to_s) }
        And { expect(response.body).to match(deliverer.name.to_s) }
        And { expect(response.body).to match(deliverer.phone.to_s) }
      end

      context 'check for page 2' do
        # Larger search range to cover all 26 Shifts
        When do
          get :index, params: {
            range1: {
              'date(3i)' => '22',
              'date(2i)' => '5',
              'date(1i)' => '2017'
            },
            range2: {
              'date(3i)' => '24',
              'date(2i)' => '5',
              'date(1i)' => '2019'
            },
            page: 2
          }
        end

        # Check for the 26th shift on the second page, since limit is 25
        Then { expect(assigns(:shifts).count).to eq 1 }
        And { expect(response).to render_template('assignments/index') }

        # Match Shift info
        And { expect(response.body).to match(shifts[25].id.to_s) }
        And { expect(response.body).to match(shifts[25].start_time_to_s.to_s) }
        And { expect(response.body).to match(shifts[25].end_time_to_s.to_s) }
      end

      context 'when no date specified' do
        When { get :index, params: {} }

        Then { is_expected.not_to set_flash }
        And { expect(response).to render_template('assignments/index') }
        And { expect(response.body).to match(Time.zone.today.strftime('%d %B %Y')) }
      end
    end
  end
end
