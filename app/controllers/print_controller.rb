class PrintController < Spree::BaseController
 

  def orders
    @orders = Order.all
  end
end
