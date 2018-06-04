module AssignmentsHelper
  # rubocop:disable Metrics/AbcSize
  def print_date_range(range)
    d1 = range.begin.to_date
    d2 = range.end.to_date

    if d1 == d2
      bold('On ') + date_output(d1)
    else
      bold('From ') + date_output(d1) +
        bold(' to ') + date_output(d2)
    end
  end
  # rubocop:enable Metrics/AbcSize

  def date_output(date)
    date.strftime('%d %B %Y')
  end

  def bold(string)
    tag.strong(string)
  end
end
