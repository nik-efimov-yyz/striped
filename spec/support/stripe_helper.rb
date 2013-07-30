module StripeHelper

  class Response
    def self.new(stripe_response, *args)
      options = args.extract_options!
      options[:format] ||= :object
      raise "Invalid Format for Stripe Response" unless [:object, :json].include?(options[:format])

      stripe_response_file = JSON.parse(IO.read("spec/support/stripe/#{stripe_response}.json"), symbolize_names: true)
      if options[:format] == :object
        StripeHelper::NestedOstruct.new(stripe_response_file)
      else
        stripe_response_file
      end
    end
  end

  class NestedOstruct
    def self.new(hash)
      OpenStruct.new(hash.inject({}){|r,p| r[p[0]] = p[1].kind_of?(Hash) ?
          NestedOstruct.new(p[1]) : p[1]; r })
    end
  end

end