require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
  # Create user for login
  Given do
    @user = FactoryGirl.create(:user)
    sign_in @user
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

      context 'when no date specified' do
        When { get :index, params: {} }

        Then { is_expected.not_to set_flash }
        And { expect(response).to render_template('assignments/index') }
        And { expect(response.body).to match(Time.zone.today.strftime('%d %B %Y')) }
      end
    end
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
    Given!(:deliverers) { FactoryGirl.create_list(:deliverer, 2) }
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
            deliverer_id: deliverers[0].id
          }
        }
      end

      Then { is_expected.to set_flash[:danger] }
      And { is_expected.to redirect_to new_assignment_path(deliverer_id: deliverers[0].id) }
    end

    context 'when assignment service success' do
      When do
        post :create,
             params: {
               assignment: {
                 deliverer_id: deliverers[0].id,
                 shift_id: shift.id
               }
             }
      end

      Then { is_expected.to set_flash[:success] }
      And do
        is_expected.to redirect_to new_assignment_path(
          deliverer_id: deliverers[0].id, shift_id: shift.id
        )
      end
    end
  end

  # Test destroy action
  describe 'delete #destroy' do
    Given!(:deliverer) { FactoryGirl.create(:deliverer) }
    Given!(:shift) { FactoryGirl.create(:shift) }
    Given!(:assignment) do
      FactoryGirl.create(:assignment, deliverer_id: deliverer.id, shift_id: shift.id)
    end

    context 'when successful destroy' do
      When do
        delete :destroy,
               params: {
                 id: assignment.id,
                 range1: '24-05-2018',
                 range2: '24-05-2018'
               }
      end

      Then { expect(Assignment.count).to eq(0) }
      And { is_expected.to set_flash[:success].to('Successfully undo an assignment') }
      And do
        is_expected.to redirect_to assignments_path(
          range1_destroy: '24-05-2018', range2_destroy: '24-05-2018'
        )
      end
    end

    context 'when unsuccessful destroy' do
      Given do
        allow(Assignment).to receive(:find).and_return(assignment)
        allow(assignment).to receive(:destroy).and_return(false)
      end

      When do
        delete :destroy,
               params: {
                 id: assignment.id,
                 range1: '24-05-2018',
                 range2: '24-05-2018'
               }
      end

      Then { expect(Assignment.count).to eq(1) }
      And { is_expected.to set_flash[:danger].to('Error in undoing assignment!') }
      And do
        is_expected.to redirect_to assignments_path(
          range1_destroy: '24-05-2018', range2_destroy: '24-05-2018'
        )
      end
    end
  end

  context '#retrieve_shift_in_range' do
    Given!(:shift) { FactoryGirl.create(:shift) }
    Given!(:range) { shift.start_time..shift.end_time }

    Then { expect(controller.retrieve_shift_in_range(range)).to include(shift) }
  end
end
