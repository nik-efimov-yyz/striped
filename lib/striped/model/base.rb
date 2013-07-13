module Striped::Model

  module Base

    extend ActiveSupport::Concern

    module ClassMethods

      def striped(*args)
        require "striped/model/extensions"
        include Striped::Model::Extensions
      end

    end

  end

end

if defined? ActiveRecord::Base
  ActiveRecord::Base.class_eval do
    include Striped::Model::Base
  end
end