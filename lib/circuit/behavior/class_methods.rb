require 'circuit/behavior/stack'

module Circuit
  module Behavior
    module ClassMethods

      # creates and memoizes a stack object that will hold the middleware 
      # objects attached to the behavior.
      #
      # @returns [Stack] newly create stack or superclass duplicate
      def stack
        @stack ||= (mixing_behaviors? ? superclass.stack.dup : Stack.new)
      end

      # defines accessor methods for commonly used stack configuration 
      # methods. This would allow you to define behaviors that inherit
      # stacks form their parents, configure them, without affecting the
      # parents stack object.
      [:use, :delete, :insert, :insert_after, :insert_before, :swap].each do |methud|
        module_eval <<-METHOD
          def #{methud.to_s}(*args)
            self.stack.#{methud.to_s} *args
          end
        METHOD
      end
      
      private ##############
      
        # @private
        def self_mixes_behaviors?
          self.superclass and self.superclass.ancestors.include?(::Circuit::Behavior)
        end

    end
  end
end
