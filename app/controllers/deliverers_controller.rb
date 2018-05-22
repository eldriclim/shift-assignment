class DeliverersController < ApplicationController

  # GET /deliverers
  def index
    @deliverers = Deliverer.all
  end

  # GET /deliverers/#
  def show
    @deliverer = Deliverer.find(params[:id])
  end

  # GET /deliverers/new
  # page to add
  def new
    @deliverer = Deliverer.new
  end

  # POST /deliverers
  def create
    @deliverer = Deliverer.new(deliverer_params)

    if @deliverer.save
      redirect_to deliverers_path
      # redirect_to @deliverer
    else
      render 'new'
    end
  end

  # GET /deliverers/#/edit
  # page to edit
  def edit
    @deliverer = Deliverer.find(params[:id])
  end

  # PATCH /deliverers/#
  def update
    @deliverer = Deliverer.find(params[:id])
    if @deliverer.update_attributes(deliverer_params)
      redirect_to deliverers_path
    else
      render 'edit'
    end
  end


  private
  def deliverer_params
    params.require(:deliverer).permit(:name, :phone, :vehicle, :active)
  end



end
