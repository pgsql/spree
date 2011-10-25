pdf.text("  ORDER                 ORDER DATE       Status              Payment State     Shipment State    Total ", :indent_paragraphs => 10)

@orders.each do |order|
 pdf.text(" #{order.number}           #{order.created_at.to_date}        #{t(order.state).titleize}             #{order.payment_state if order.payment_state }        #{order.shipment_state if order.shipment_state }           #{number_to_currency order.total}   ", :indent_paragraphs => 10)
end





