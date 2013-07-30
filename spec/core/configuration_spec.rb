require "spec_helper"

describe "Striped Configuration" do

  subject { Striped }

  describe "Default Configuration" do
    its(:active_statuses) { should == [:active, :trialing, :past_due] }
    its(:auto_sync_with_stripe) { should == true }
    its(:auto_create_stripe_account) { should == true }
    its(:base_controller) { should == "ApplicationController" }
    its(:current_account_method) { should == :current_user }
    its(:overdue_status) { should == :past_due }
    its(:provider) { should == :stripe }
    its(:scope) { should == :user }
    its(:stripe_customer_id_column) { should == :stripe_customer_id }
    its(:trialing_status) { should == :trialing }
  end

  describe "Custom Configuration" do

    before do
      Striped.configure do |config|
        config.scope = :client
      end
    end

    its(:scope) { should == :client }
  end



end