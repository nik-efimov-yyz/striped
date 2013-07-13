require "spec_helper"

class User < ActiveRecord::Base
  striped
end

describe User do

  subject { user }
  let(:user) { User.new(status: status) }
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

end