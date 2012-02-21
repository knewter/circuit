##
# Template::Stacks
# ----------------
#
# Template stacks are stacks of blocks that are inherited.
# See http://guides.rubyonrails.org/rails_on_rack.html for some method examples.
#
# This code is originally pulled from rails middleware configs
# https://github.com/rails/rails/raw/master/actionpack/lib/action_dispatch/middleware/stack.rb
require 'active_support/inflector/methods'
require 'active_support/dependencies'
require 'monitor'

module Circuit
  module Behavior
    class Stack
      class NoSuchObjectError < Exception ;; end

      include Enumerable

      attr_accessor :objects

      def initialize(*args, &block)
        @monitor = Monitor.new
        @objects ||= []
        configure &block
        @objects.uniq!
      end

      # duplicates stack and it's objects
      def dup
        self.class.new.tap{|obj| obj.initialize_copi self }
      end

      def empty?
        objects.empty?
      end

      def configure(*args)
        @monitor.synchronize {
          yield(self) if block_given?
        }
      end

      def each
        @objects.each { |x| yield x }
      end

      def size
        objects.size
      end

      def last
        objects.last
      end

      def insert(index, block_klass, &block)
        index = assert_index(index, :before)
        template = block_klass
        objects.insert(index, template)
      end

      alias_method :insert_before, :insert

      def insert_after(index, *args, &block)
        index = assert_index(index, :after)
        insert(index + 1, *args, &block)
      end

      def swap(target, *args, &block)
        insert_before(target, *args, &block)
        delete(target)
      end

      def delete(target)
        objects.delete target
      end

      alias_method :skip, :delete

      def use(block_klass, &block)
        template = block_klass
        objects.push(template)
      end

      def clear
        objects.replace []
      end

    protected #######################################################################

      def initialize_copi(other)
        self.objects = other.objects.dup
      end

      def assert_index(index, where)
        i = index.is_a?(Integer) ? index : objects.index(index)
        raise NoSuchObjectError, "No such stack object to insert #{where}: #{index.inspect}" unless i
        i
      end
    end
  end
end
