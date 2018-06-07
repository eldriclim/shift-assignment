class DeliverersFilterService
  def initialize(params)
    @name = params[:name]
    @phone = params[:phone]
    @vehicle = params[:vehicle]
    @active = params[:active]
  end

  # rubocop:disable Metrics/AbcSize
  # :reek:TooManyStatements
  def perform
    return Deliverer.all if empty_conditions?(@name, @phone, @vehicle, @active)

    records = Deliverer

    # Filter by name
    if @name != ''
      records = records.where('lower(name) LIKE lower(?)', "%#{@name}%")
    end

    # Filter by phone
    if @phone != ''
      records = records.where('lower(phone) LIKE lower(?)', "%#{@phone}%")
    end

    # Filter by vehicle
    if @vehicle != ''
      records = records.where(vehicle: Deliverer.vehicles[@vehicle])
    end

    # Filter by status
    if @active != ''
      records = records.where(active: true) if @active == 'true'
      records = records.where(active: false) if @active == 'false'
    end

    records.all
  end
  # rubocop:enable Metrics/AbcSize

  # :reek:UtilityFunction
  def empty_conditions?(*conds)
    conds.each do |con|
      return false if con != ''
    end
    true
  end
end
