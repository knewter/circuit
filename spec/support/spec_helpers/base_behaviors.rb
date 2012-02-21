require 'active_support/concern'

module SpecHelpers
  module BaseBehaviors
    extend ActiveSupport::Concern

    included do

      class ::StatusOkBehavior
        include Decks::Behavior

        def self.call_with_downstream_app(env, app)
          [200, {'Content-Type' => 'text/plain'}, ["OK"]]
        end
      end

    end

  end
end
