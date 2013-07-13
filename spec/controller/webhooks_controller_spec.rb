require "spec_helper"
require "striped/controller/webhooks"

describe "Striped::Controller::Webhooks", type: :controller do

  controller(ActionController::Base) do
    include Striped::Controller::Webhooks
  end

  describe "coverage of methods" do
    it "must cover all Stripe Events" do
      [:account_updated, :account_application_deauthorized, :balance_available, :charge_succeeded,
       :charge_failed, :charge_captured, :charge_dispute_created, :charge_dispute_updated,
       :charge_dispute_closed, :customer_created, :customer_updated, :customer_deleted,
       :customer_subscription_created, :customer_subscription_updated, :customer_subscription_deleted,
       :customer_subscription_trial_will_end, :customer_discount_created, :customer_discount_deleted,
       :invoice_created, :invoice_updated, :invoice_payment_succeeded, :invoice_payment_failed,
       :invoiceitem_created, :invoiceitem_updated, :invoiceitem_deleted, :plan_created, :plan_updated,
       :plan_deleted, :coupon_created, :coupon_deleted, :transfer_created, :transfer_updated, :transfer_paid,
       :transfer_failed, :ping
      ].each do |method|
        Striped::Controller::Webhooks.instance_methods.should include(method)
      end
    end
  end

  describe "#process_webhook" do
    before do
      controller.stub(params: StripeHelper::Response.new(:account_updated, format: :json) )
    end

    after { controller.process_webhook }

    it "calls the right method based on the event type" do
      controller.should_receive(:account_updated)
    end

  end

  describe "#account_updated" do
    subject { klass.new.account_updated }

    before do
      klass.stub(params: StripeHelper::Response.new(:account_updated, format: :json) )
    end

  end


end