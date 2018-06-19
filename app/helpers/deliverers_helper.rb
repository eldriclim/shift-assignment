module DeliverersHelper
  def month_range
    today = Time.zone.today
    (today - 29)..today
  end

  # :reek:TooManyStatements
  def shifts_on_date(queue, date)
    shifts = []
    while !queue.empty?
      head = queue.first

      break if head.start_time >= date.at_end_of_day

      shifts << queue.shift
    end
    shifts
  end

  def time_range_to_s(shifts)
    shifts.map do |shift|
      "#{shift.start_time.strftime('%H:%M %p')} - #{shift.end_time.strftime('%H:%M %p')}"
    end
  end

  # :reek:TooManyStatements
  def time_taken(shifts)
    total_time = 0

    shifts.each do |shift|
      total_time += shift.end_time - shift.start_time
    end

    hours = total_time / 3600.0
    return '0' if hours <= 0
    hours.to_s
  end
end
