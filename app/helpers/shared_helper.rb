module SharedHelper
  def flash_ul(message)
    if message.is_a?(Array)
      tag.ul do
        message.each do |mes|
          concat tag.li(mes)
        end
      end
    else
      message
    end
  end
end
