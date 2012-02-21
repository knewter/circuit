require 'active_support/concern'
require 'mongoid/tree'
require 'circuit/site/class_methods'

module Circuit
  module Site

    extend ActiveSupport::Concern

    included do
      field :domain
      field :behavior_klass

      validates_presence_of     :behavior_klass
      validates_presence_of     :domain
      validates_format_of       :domain, :with => /^[a-z0-9\-\.]{6,}$/, :message => "is invalid"
      validates_uniqueness_of   :domain, :scope => :parent_id
    end

    def behavior
      return nil if self.behavior_klass.blank?
      behavior_klass.constantize
    end

    def behavior=(klass)
      self.behavior_klass = klass.to_s
    end

  end
end
