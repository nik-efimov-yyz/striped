module Striped::Controller

  module Base

    extend ActiveSupport::Concern

    module ClassMethods

      def validates_account(*args)
        options = args.extract_options!

        self.before_filter(*options.slice(:only, :except, :if, :unless)) do |controller|
          next if controller.instance_variable_defined?(:@_skip_account_validation)
          raise Striped::AccountNotFound unless current_account.present?
          raise Striped::InactiveAccount unless current_account.active?
        end

      end

      def skip_account_validation(*args)
        self.prepend_before_filter(*args) do |controller|
          controller.instance_variable_set(:@_skip_account_validation,true)
        end
      end

    end

    def current_account
      @current_account ||= self.send(::Striped.current_account_method)
    end

  end

end


# Automatically load Striped::Controller into ActionController::Base
if defined? ActionController::Base
  ActionController::Base.class_eval do
    include Striped::Controller::Base
  end
end