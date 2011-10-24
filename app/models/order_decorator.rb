Order.class_eval do
  # customize the checkout state machine
  state_machine :initial => 'cart', :use_transactions => false do
    event :next do
      transition :from => 'cart', :to => 'address'
      transition :from => 'address', :to => 'payment'
      transition :from => 'confirm', :to => 'complete'

      # note: some payment methods will not support a confirm step
      transition :from => 'payment', :to => 'confirm',
                 :if => Proc.new { Gateway.current && Gateway.current.payment_profiles_supported? }

      transition :from => 'payment', :to => 'complete'
    end

    event :cancel do
      transition :to => 'canceled', :if => :allow_cancel?
    end
    event :return do
      transition :to => 'returned', :from => 'awaiting_return'
    end
    event :resume do
      transition :to => 'resumed', :from => 'canceled', :if => :allow_resume?
    end
    event :authorize_return do
      transition :to => 'awaiting_return'
    end

  end
end
