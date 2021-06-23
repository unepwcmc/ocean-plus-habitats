module NumberHelper
  include ActiveSupport::NumberHelper

  def delimit(number)
    number_to_delimited(number)
  end
end