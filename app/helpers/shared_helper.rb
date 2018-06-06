module SharedHelper
  # :reek:FeatureEnvy
  def flash_ul(message)
    if message.is_a?(Array)
      return message[0] if message.length == 1

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
