module Behaviors
  class MountByFragmentOrRemap
    include ::Circuit::Behavior

    def self.remap_by_fragment
      true
    end

  end
end
