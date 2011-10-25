class PrintController < Spree::BaseController
 

  def orders
    @orders = warden.user.orders
  end
end
