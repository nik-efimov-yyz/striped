module Striped
  class AccountNotFound < StandardError; end
  class InactiveAccount < StandardError; end
  class UnknownAccountSource < StandardError; end
end