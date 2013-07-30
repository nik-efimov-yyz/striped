module Striped::Model::Extensions

  extend ActiveSupport::Concern

  included do
    after_save :sync_with_stripe, if: lambda { Striped.auto_sync_with_stripe }
  end

  module ClassMethods

  end

  # Returns true if the status is one of the active statuses
  def active?
    Striped.active_statuses.map(&:to_sym).include?(self.status.to_sym)
  end

  def trialing?
    Striped.trialing_status.to_sym == self.status.to_sym
  end

  def overdue?
    Striped.overdue_status.to_sym == self.status.to_sym
  end

  def stripe
    return nil unless stripe_ready?
    @_stripe ||= Stripe::Customer.retrieve(_stripe_customer_id)
  end

  def stripe_ready?
    _stripe_customer_id.present?
  end

  def sync_with_stripe
    return true unless stripe_ready?

    # Updating email and name columns
    if self.respond_to?(:email)
      if self.email != stripe.email
        stripe.email = self.email
        stripe.save
      end
    end

  end

  private

  def pull_from_stripe

  end

  def _stripe_customer_id
    self.send(Striped.stripe_customer_id_column)
  end




end