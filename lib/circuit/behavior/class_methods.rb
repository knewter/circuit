require 'circuit/behavior/stack'

module Circuit
  module Behavior
    module ClassMethods

      # creates and memoizes a stack object that will hold the middleware objects
      # attached to the behavior.
      #
      def stack
        @stack ||= (superclass and superclass.ancestors.include?(::Circuit::Behavior) ? superclass.stack.dup : Stack.new)
      end

      [:use, :delete, :insert, :insert_after, :insert_before, :swap].each do |methud|
        module_eval <<-METHOD
          def #{methud.to_s}(*args)
            self.stack.#{methud.to_s} *args
          end
        METHOD
      end

    end
  end
end
