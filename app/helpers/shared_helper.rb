module SharedHelper
  def flash_ul(message)
    if message.kind_of?(Array)
      tag.ul{
        message.each do |m|
          concat tag.li(m)
        end
      }
    else
      message
    end
  end
end
