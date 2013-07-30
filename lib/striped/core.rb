module Striped

  # Configuration Options
  def self.configure
    yield self if block_given?
  end

  # Account statuses that are considered to be 'active'
  mattr_accessor :active_statuses
  self.active_statuses = [:active, :trialing, :past_due]

  # Whether or not to synchronize model with Stripe. Could be true or false
  mattr_accessor :auto_sync_with_stripe
  self.auto_sync_with_stripe = true

  # The Parent Class name from which Striped controller will be inheriting from
  mattr_accessor :base_controller
  self.base_controller = "ApplicationController"

  # The name of the helper method that is the source for the account information
  # This depends on the end application configuration. When used with Devise,
  # it's most likely going to be :current_user
  mattr_accessor :current_account_method
  self.current_account_method = :current_user

  # The account status that is considered overdue
  mattr_accessor :overdue_status
  self.overdue_status = :past_due

  # 3rd-Party provider of the account data. Depending on the provider, it may enable
  # additional functionality, such as webhooks
  mattr_accessor :provider
  self.provider = :stripe

  # The name of the object that is acting as the account. Typically, it's the user
  mattr_accessor :scope
  self.scope = :user

  # The name of the column that holds Stripe Customer ID for the account
  mattr_accessor :stripe_customer_id_column
  self.stripe_customer_id_column = :stripe_customer_id

  # The account status that is considered to be on trial
  mattr_accessor :trialing_status
  self.trialing_status = :trialing

end