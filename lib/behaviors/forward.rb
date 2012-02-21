module Behaviors
  class Forward
    include ::Circuit::Behavior

    def self.remap_by_fragment
      true
    end
  end
end
