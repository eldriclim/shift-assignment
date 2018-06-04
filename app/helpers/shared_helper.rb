module SharedHelper
  def flash_ul(message)
    if message.is_a?(Array)
      tag.ul do
        message.each do |m|
          concat tag.li(m)
        end
      end
    else
      message
    end
  end
end
