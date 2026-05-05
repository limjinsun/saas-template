class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include GlobalMethods

  # HARD FORCE: Ban Date.today inside models
  def self.today
    raise StandardError, "🛑 DATE.TODAY IS BANNED. Use Time.zone.today"
  end

  # HARD FORCE: Ban Time.now inside models
  def self.now
    raise StandardError, "🛑 TIME.NOW IS BANNED. Use Time.zone.now"
  end
end
