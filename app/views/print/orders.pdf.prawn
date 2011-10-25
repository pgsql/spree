
@orders.each do |order|
 pdf.text("ORDER:#{order.number} ORDER DATE:#{order.created_at.to_date} Status:#{t(order.state).titleize} Payment State:#{order.payment_state if order.payment_state } Shipment State:#{order.shipment_state if order.shipment_state } Total:#{number_to_currency order.total}", :indent_paragraphs => 10)
end





