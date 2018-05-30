require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do

  # Create user for login
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # Test create action
  describe "post #create" do
    before do
      @deliverer = FactoryGirl.create_list(:deliverer, 2)
      @shift = FactoryGirl.create(:shift)
    end


    context "when no assignment param" do
      it "redirects to home_path and flashes danger" do
        post :create, params: {}

        is_expected.to set_flash[:danger]
      end
    end

    context "when no deliverer_id in param" do
      it "redirects to home_path and flashes danger" do
        post :create, params: {
          assignment: {
            shift_id: @shift.id
          }
        }

        is_expected.to set_flash[:danger]
      end
    end

    context "when no shift_id in param" do
      it "redirects to home_path and flashes danger" do
        post :create, params: {
          assignment: {
            deliverer_id: @deliverer[0].id
          }
        }

        is_expected.to set_flash[:danger]
      end
    end

    context "with valid attributes" do
      it "creates a new assignment" do
        post :create,
          params: {
            assignment: {
              deliverer_id: @deliverer[0].id,
              shift_id: @shift.id
            }
          }

        is_expected.to set_flash[:success]
        is_expected.to redirect_to home_path
      end
    end

    context "with invalid attributes" do
      it "flash danger" do
        post :create,
          params: {
            assignment: {
              deliverer_id: -1,
              shift_id: @shift.id
            }
          }

        is_expected.to set_flash[:danger].to("Error in assigning shift!")
        is_expected.to redirect_to home_path
      end
    end

    context "when shift has maxed out" do
      it "flash danger" do
        # Initial insertion: 0/1 -> 1/1
        post :create,
          params: {
            assignment: {
              deliverer_id: @deliverer[0].id,
              shift_id: @shift.id
            }
          }

        # Insertion to an already maxed out shift
        post :create,
          params: {
            assignment: {
              deliverer_id: @deliverer[1].id,
              shift_id: @shift.id
            }
          }

        is_expected.to set_flash[:danger].to("Shift count has already maxed out!")
        is_expected.to redirect_to home_path
      end
    end
  end

  # Test show action
  describe "post #show" do
    context "when invalid date range" do
      it "flash danger" do
        post :show,
          params: {
            range1: {
              "start_date(3i)" => "23",
              "start_date(2i)" => "5",
              "start_date(1i)" => "2018"
            },
            range2: {
              "end_date(3i)" => "22",
              "end_date(2i)" => "5",
              "end_date(1i)" => "2018"
            }
          }

        is_expected.to set_flash[:danger].to("Invalid date range!")
        is_expected.to redirect_to home_path
      end
    end

    context "when valid date range" do
      before do
        @shift = FactoryGirl.create(:shift)
        @deliverer = FactoryGirl.create(:deliverer)
        @assignment = FactoryGirl.create(:assignment, deliverer_id: @deliverer.id, shift_id: @shift.id)
      end

      render_views

      it "initializes shifts within range" do
        post :show,
          params: {
            range1: {
              "start_date(3i)" => "22",
              "start_date(2i)" => "5",
              "start_date(1i)" => "2018"
            },
            range2: {
              "end_date(3i)" => "24",
              "end_date(2i)" => "5",
              "end_date(1i)" => "2018"
            }
          }

          is_expected.not_to set_flash

          expect(response).to render_template("assignments/show")
          expect(response.body).to match("22 May 2018")
          expect(response.body).to match("24 May 2018")

          # Match Shift info
          expect(response.body).to match("#{@shift.start_time_to_s}")
          expect(response.body).to match("#{@shift.end_time_to_s}")
          expect(response.body).to match("#{@shift.deliverer.count}/#{@shift.max_count}")

          # Match Deliverer info within Shift
          expect(response.body).to match("#{@deliverer.id}")
          expect(response.body).to match("#{@deliverer.name}")
          expect(response.body).to match("#{@deliverer.phone}")


      end
    end
  end

end
