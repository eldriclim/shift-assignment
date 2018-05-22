class DeliverersController < ApplicationController

  # GET /deliverers/#
  def show
    @deliverer = Deliverer.find(params[:id])
  end

end
