require 'active_support/concern'
require 'mongoid/tree'

module Circuit
  module Tree
    extend  ActiveSupport::Concern
    include Mongoid::Document
    include Mongoid::Tree
    include Mongoid::Tree::Ordering
    include Mongoid::Tree::Traversal

    included do
      field :slug
      field :behavior_klass

      validates_presence_of     :behavior_klass
      validates_presence_of     :slug
      validates_uniqueness_of   :slug, :scope => :parent_id

      # TODO: add a test
      before_destroy :nullify_children
    end

    # # Attempts to fetch the behavior from a parent class or returns value.
    # # when passed a single option it will set the behavior to the current
    # # value.
    # #
    # # @overload behavior
    # #   @returns [Class, nil] returns current behavior, or nil if unset or
    # #                         uninheritable.
    # # @overload behavior(new_behavior)
    # #   @param [Class]        new_behavior
    # #   @returns [Class, nil] returns new_behavior
    # def behavior(*args)
    #   return @behavior if args.empty? and @behavior
    #   if superclass.respond_to?(:behavior) and not superclass.behavior.nil?
    #     @behavior ||= super || nil
    #   end
    # end

    def behavior
      return nil if self.behavior_klass.blank?
      behavior_klass.constantize
    end

    def behavior=(klass)
      self.behavior_klass = klass.to_s
    end

    def find_child_by_fragment(fragment)
      children.where(slug: fragment).first
    end
  end
end
