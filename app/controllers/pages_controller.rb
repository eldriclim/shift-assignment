class PagesController < ApplicationController
  def home
    @deliverers = Deliverer.all
    @shifts = Shift.all
    @assignment = Assignment.new
  end

  def test
    render 'home_new'
  end
end
