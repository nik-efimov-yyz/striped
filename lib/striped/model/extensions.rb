module Striped::Model::Extensions

  extend ActiveSupport::Concern

  included do
    before_save :initialize_stripe,
      unless: Proc.new { |account| Striped.auto_create_stripe_account == false || account.has_stripe_account? }
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
    return nil unless has_stripe_account?
    @_stripe ||= ::Stripe::Customer.retrieve(stripe_identifier)
  end

  def stripe_identifier
    self.send(Striped.stripe_customer_id_column)
  end

  def stripe_identifier= (value)
    self.send((Striped.stripe_customer_id_column.to_s + "=").to_sym, value)
  end

  def has_stripe_account?
    stripe_identifier.present?
  end

  def initialize_stripe
    stripe_response = ::Stripe::Customer.create({
        email: self.email
    })
    self.stripe_identifier = stripe_response.id
    true
  end

  def sync_with_stripe
    return true unless has_stripe_account?

    # Updating email and name columns
    if self.respond_to?(:email)
      if self.email != stripe.email
        stripe.email = self.email
        stripe.save
      end
    end

  end

end