module Striped::Model::Extensions

  extend ActiveSupport::Concern

  included do
    before_save :synchronize_with_stripe
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

  def synchronize_with_stripe

  end


end