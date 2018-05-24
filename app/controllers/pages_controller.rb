class PagesController < ApplicationController
  def index
  end

  def home
    @deliverers = Deliverer.all
    @shifts = Shift.all
    @assignment = Assignment.new
  end
end
