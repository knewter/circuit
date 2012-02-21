require 'active_support/concern'
require 'circuit/behavior/class_methods'

module Circuit
  module Behavior
    extend ActiveSupport::Concern

    class RewriteException < Exception ; end

    included do

    end

  end
end
