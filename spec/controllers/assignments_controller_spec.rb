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

  context '#date_range' do
    Given!(:date1_hash) do
      {
        'date(3i)' => 23,
        'date(2i)' => 0o5,
        'date(1i)' => 2018
      }
    end
    Given!(:date2_hash) do
      {
        'date(3i)' => 24,
        'date(2i)' => 0o5,
        'date(1i)' => 2018
      }
    end

    When(:date1) do
      Time.zone.parse(
        "#{date1_hash['date(3i)']}-#{date1_hash['date(2i)']}-#{date1_hash['date(1i)']}"
      )
    end
    When(:date2) do
      Time.zone.parse(
        "#{date2_hash['date(3i)']}-#{date2_hash['date(2i)']}-#{date2_hash['date(1i)']}"
      )
    end

    Then do
      expect(controller.date_range(date1_hash, date2_hash)).to(
        eq(date1.at_beginning_of_day..date2.at_end_of_day)
      )
    end
  end

  context '#retrieve_shift_in_range' do
    Given!(:shift) { FactoryGirl.create(:shift) }
    Given!(:range) { shift.start_time..shift.end_time }

    Then { expect(controller.retrieve_shift_in_range(range)).to include(shift) }
  end
end
