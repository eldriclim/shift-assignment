class PagesController < ApplicationController
  def index
  end

  def info
    @deliverers = Deliverer.all
    @shifts = Shift.all
  end
end
