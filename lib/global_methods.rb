module GlobalMethods
  def format_money(amount)
    ActiveSupport::NumberHelper.number_to_currency(amount, unit: "")
  end

  def log_str(str)
    "\e[44;37m[#{str}]\e[0m"
  end
end
