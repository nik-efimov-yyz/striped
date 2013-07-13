require "spec_helper"

class TestBaseController < ApplicationController

  def index
    render text: "index action rendered"
  end

  def show
    render text: "show action rendered"
  end

  def current_user

  end

  def condition_method

  end
end

describe "Controller that uses Striped", type: :controller do

  let(:user) { FactoryGirl.create :user, :active }

  describe "default behaviour" do

    controller(TestBaseController) do
      validates_account
    end

    before do
      controller.stub(current_user: user)
    end

    context "user not signed in" do
      let(:user) { nil }
      it { expect { get :index }.to raise_error(Striped::AccountNotFound) }
    end

    context "user signed in" do

      context "active client" do
        before { get :index }
        let(:user) { FactoryGirl.create :user, :active }
        it { response.body.should == "index action rendered" }
      end

      context "inactive client" do
        let(:user) { FactoryGirl.create :user, :unpaid }
        it { expect { get :index }.to raise_error(Striped::InactiveAccount) }
      end

    end

  end

  describe "skipping validations" do

    before { controller.stub(current_user: user) }

    let(:user) { FactoryGirl.create :user, :unpaid }

    describe "skip on controller level" do
      controller(TestBaseController) do
        validates_account
        skip_account_validation
      end

      before { get :index }

      it { response.body.should == "index action rendered" }
    end

    describe "skip if" do

      controller(TestBaseController) do
        validates_account
        skip_account_validation if: :condition_method
      end

      context "condition passes" do
        before do
          controller.stub(condition_method: true)
          get :index
        end
        it { response.body.should == "index action rendered" }
      end

      context "condition fails" do
        before { controller.stub(condition_method: false) }
        it { expect { get :index }.to raise_error(Striped::InactiveAccount) }
      end
    end

    describe "skip only" do
      controller(TestBaseController) do
        validates_account
        skip_account_validation only: [:show]
      end

      context "calling the only action" do
        before { get :show, id: "smth" }
        it { response.body.should == "show action rendered" }
      end

      context "calling some other action" do
        it { expect { get :index }.to raise_error(Striped::InactiveAccount) }
      end
    end

  end

end

