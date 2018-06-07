module AssignmentsHelper
  # rubocop:disable Metrics/AbcSize
  # :reek:DuplicateMethodCall
  def print_date_range(range)
    date_to = range.begin.to_date
    date_from = range.end.to_date

    if date_to == date_from
      bold('On ') + date_output(date_to)
    else
      bold('From ') + date_output(date_to) +
        bold(' to ') + date_output(date_from)
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
