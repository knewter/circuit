module Circuit
  module Tree
    class Base

      class << self

        # Attempts to fetch the behavior from a parent class or returns value.
        # when passed a single option it will set the behavior to the current
        # value.
        #
        # @overload behavior
        #   @returns [Class, nil] returns current behavior, or nil if unset or
        #                         uninheritable.
        # @overload behavior(new_behavior)
        #   @param [Class]        new_behavior
        #   @returns [Class, nil] returns new_behavior
        def behavior(*args)
          return @behavior if args.empty? and @behavior
          if superclass.respond_to?(:behavior) and not superclass.behavior.nil?
            @behavior ||= super || nil
          end
        end

      end

    end
  end
end
