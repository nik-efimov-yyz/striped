module Striped::Controller

  module Webhooks

    def process_webhook
      method = params[:type].gsub(".","_").to_sym
      self.send(method)
    end

    def account_updated

    end

    def account_application_deauthorized

    end

    def balance_available

    end

    def charge_succeeded

    end

    def charge_failed

    end

    def charge_captured

    end

    def charge_dispute_created

    end

    def charge_dispute_updated

    end

    def charge_dispute_closed

    end

    def customer_created

    end

    def customer_updated

    end

    def customer_deleted

    end

    def customer_subscription_created

    end

    def customer_subscription_updated

    end

    def customer_subscription_deleted

    end

    def customer_subscription_trial_will_end

    end

    def customer_discount_created

    end

    def customer_discount_deleted

    end

    def invoice_created

    end

    def invoice_updated

    end

    def invoice_payment_succeeded

    end

    def invoice_payment_failed

    end

    def invoiceitem_created

    end

    def invoiceitem_updated

    end

    def invoiceitem_deleted

    end

    def plan_created

    end

    def plan_updated

    end

    def plan_deleted

    end

    def coupon_created

    end

    def coupon_deleted

    end

    def transfer_created

    end

    def transfer_updated

    end

    def transfer_paid

    end

    def transfer_failed

    end

    def ping

    end


  end

end