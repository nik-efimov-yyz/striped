require "spec_helper"
require "stripe"

class User < ActiveRecord::Base
  striped

  def custom_stripe_id_column
  end

  def custom_stripe_id_column=(value)
  end

end

describe User do

  subject { user }
  let(:user) { FactoryGirl.create :user, :with_stripe, status: status }
  let(:status) { "active" }

  # Models should automatically include Striped::Model
  it { should be_a_kind_of(Striped::Model::Base) }

  # Instance Methods
  describe "#active?" do
    subject { user.active? }
    context "one of the active statuses" do
      let(:status) { "trialing" }
      it { should be_true }
    end

    context "a status not included in active" do
      let(:status) { "canceled" }
      it { should be_false }
    end
  end

  describe "#overdue?" do

    subject { user.overdue? }

    context "default configuration" do
      context "correct status" do
        let(:status) { "past_due" }
        it { should be_true }
      end

      context "incorrect status" do
        let(:status) { "smth else" }
        it { should be_false }
      end
    end

    context "custom configuration" do
      before do
        Striped.configure do |config|
          config.overdue_status = "overdue"
        end
      end

      context "correct status" do
        let(:status) { "overdue" }
        it { should be_true }
      end

      context "incorrect status" do
        let(:status) { "past_due" }
        it { should be_false }
      end

    end
  end

  describe "#trialing?" do

    subject { user.trialing? }

    context "default configuraiton" do
      context "trialing status" do
        let(:status) { "trialing" }
        it { should be_true }
      end

      context "another status" do
        let(:status) { "active" }
        it { should be_false }
      end
    end


    context "custom configuration" do

      before do
        Striped.configure do |config|
          config.trialing_status = "testing"
        end
      end

      context "correct status" do
        let(:status) { "testing" }
        it { should be_true }

      end

      context "incorrect status" do
        let(:status) { "smth else" }
        it { should be_false }
      end

    end

  end

  describe "#sync_with_stripe" do

    context "default" do

      it "synchronizes on save" do
        user.should_receive(:sync_with_stripe)
        user.save
      end

    end

    context "disabled in the config" do
      before do
        Striped.stub(auto_sync_with_stripe: false)
      end

      it "does not sync automatically" do
        user.should_not_receive(:sync_with_stripe)
        user.save
      end
    end

    describe "updating Stripe data on save" do

      it "sends a stripe request if data has changed" do
        user.email = "new@example.com"
        user.stripe.should_receive(:save)
        user.save
      end

      context "email" do

        before { user.stripe.stub(email: user.email) }

        it "updates stripes email if email is different" do
          user.email = "new@example.com"
          user.stripe.should_receive(:email=).with("new@example.com")
          user.save
        end

        it "doesn't send an update if email is unchanged" do
          user.stripe.should_not_receive(:email=)
          user.save
        end

      end

    end

  end

  describe "#stripe" do
    subject { user.stripe }

    context "default" do

      context "stripe id present" do

        it "calls Stripe::Customer.retrieve method with the stripe id" do
          Stripe::Customer.should_receive(:retrieve).with(user.stripe_customer_id)
          user.stripe
        end

        it "calls Stripe::Customer.retrieve only once if called several times" do
          Stripe::Customer.should_receive(:retrieve).once
          user.stripe
          user.stripe
        end

      end

      context "no stripe id present" do
        before { user.stub(stripe_customer_id: nil) }
        it { should be_nil }
      end


    end

  end

  describe "#stripe_identifier" do

    subject { user.stripe_identifier }

    context "default configuration" do
      it "calls #stripe_customer_id method" do
        user.should_receive(:stripe_customer_id)
        subject
      end
    end

    context "custom configuration" do
      before { Striped.stub(stripe_customer_id_column: :custom_stripe_id_column) }
      it "calls the custom method" do
        user.should_receive(:custom_stripe_id_column)
        subject
      end
    end

  end

  describe "#has_stripe_account?" do

    subject { user.has_stripe_account? }

    it "should utilize #stripe_identity method" do
      user.should_receive(:stripe_identifier)
      subject
    end

    context "has stripe id set" do
      before { user.stub(stripe_customer_id: "123") }
      it { should be_true }
    end

    context "doesn't have stripe id set" do
      before { user.stub(stripe_customer_id: nil) }
      it { should be_false }
    end

  end

  describe "#initialize_stripe" do

    let(:user) { FactoryGirl.create :user, email: "joe@example.com" }

    describe "utilization" do

      context "default configuration" do

        context "stripe account already present" do
          before { user.stub(has_stripe_account?: true) }

          it "doesn't get called" do
            user.should_not_receive(:initialize_stripe)
            user.save
          end

        end

        context "stripe account not present" do
          before { user.stub(has_stripe_account?: false) }
          it "gets called" do
            user.should_receive(:initialize_stripe)
            user.save
          end

        end

      end

      context "auto_create_stripe_account set to false" do

        before do
          user.stub(has_stripe_account?: false)
          Striped.stub(auto_create_stripe_account: false)
        end

        it "doesn't get called" do
          user.should_not_receive(:initialize_stripe)
          user.save
        end

      end

    end

    it "sends Stripe request with the email" do
      Stripe::Customer.should_receive(:create).with({
          email: "joe@example.com"
      })
      user
    end

    it "sets stripe customer id to the received id" do
      user.stripe_customer_id.should == "cus_00000000000000"
    end

  end

end