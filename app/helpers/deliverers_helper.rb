module DeliverersHelper
  def vehicle_helper(i)
    case i
    when 0
      "Motorbike"
    when 1
      "Bicycle"
    when 2
      "Scooter"
    else
      "ERROR"
    end
  end

  def active_helper(b)
    case b
    when true
      "Active"
    when false
      "Inactive"
    else
      "ERROR"
    end
  end
end
