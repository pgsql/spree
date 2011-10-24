class Shiplist < ActionMailer::Base
  default :from => "from@example.com"

  def shiplist_email(to, message, ids, protocol, host)
    @message = message
    @ids = ids
    @protocol = protocol
    @host = host
    mail(:to=>to, :subject=>"Shiplist")
  end
end
