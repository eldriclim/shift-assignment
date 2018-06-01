require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  # Create user for login
  Given{
    @user = FactoryGirl.create(:user)
    sign_in @user
  }

  context "get #home" do

    # Create sample data for display
    Given!(:deliverers) { FactoryGirl.create_list(:deliverer, 3) }
    Given!(:shifts) { FactoryGirl.create_list(:shift, 3) }

    context "retrieving models" do
      When { get :home }

      Then { expect(assigns(:deliverers)).to eq(deliverers) }
      And { expect(assigns(:shifts)).to eq(shifts) }
      And { expect(assigns(:assignment)).to be_a_new(Assignment) }
    end

    # Render views to check for Deliverers and Shifts info
    render_views

    context "table views" do
      When { get :home }

      # Check for view partials
      Then { expect(response).to render_template("pages/home") }
      And { expect(response).to render_template(partial: "pages/_deliverers_table") }
      And { expect(response).to render_template(partial: "pages/_shifts_table") }
      And { expect(response).to render_template(partial: "pages/_shift_assignment_form") }
      And { expect(response).to render_template(partial: "pages/_view_assignment_form") }

      # Identify Deliverers info in view
      And {
        deliverers.each do |d|
          expect(response.body).to match("#{d.id}")
          expect(response.body).to match("#{d.name}")
          expect(response.body).to match("#{d.phone}")
          expect(response.body).to match("#{d.vehicle.capitalize}")
          expect(response.body).to match("#{d.active_to_s}")
        end
      }


      # Identify Shifts info in view
      And {
        shifts.each do |s|
         expect(response.body).to match("#{s.id}")
         expect(response.body).to match("#{s.start_time_to_s}")
         expect(response.body).to match("#{s.end_time_to_s}")
         expect(response.body).to match("#{s.deliverers.count}/#{s.max_count}")
        end
      }
    end
  end

end
