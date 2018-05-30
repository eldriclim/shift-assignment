module AssignmentsHelper
  def print_date_range(d1, d2)
    if d1.to_date == d2.to_date
      tag.strong("On ") + d1.strftime("%d %B %Y")
    else
      tag.strong("From ") + d1.strftime("%d %B %Y") +
        tag.strong(" to ") + d2.strftime("%d %B %Y")
    end
  end
end
