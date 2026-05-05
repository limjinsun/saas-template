module ApplicationHelper
  include GlobalMethods

  def form_with(**options, &block)
    options[:html] ||= {}
    options[:html][:autocomplete] ||= "off"
    super(**options, &block)
  end

  def safari_browser?
    ua = request.user_agent.to_s
    ua.include?("Safari") && !ua.include?("Chrome") && !ua.include?("Chromium") && !ua.include?("Android")
  end

  def not_chrome_browser?
    ua = request.user_agent.to_s
    !ua.include?("Chrome") && !ua.include?("Chromium") && !ua.include?("Android")
  end

  def smart_titleize
    stop_words = %w[a an and the or for nor on at to by]
    self.split.each_with_index.map do |word, index|
      if index > 0 && stop_words.include?(word.downcase)
        word.downcase
      else
        word.capitalize
      end
    end.join(" ")
  end

end
