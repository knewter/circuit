# constructs 2 different trees of routing for our examples purposes.
#
#     + root
#       + child
#         + grandchild
#           + great_grandchild
#
# And a more complex version:
#
#     + root_1
#       + child_1
#         + grandchild_1
#         + grandchild_2
#           + great_grandchild_1
#           + great_grandchild_2
#       + child_2
#         + grandchild_3
#           + great_grandchild_3
#     + root_2
#
# This include doesn't take into account any slug information(as they are generated
# by the route blueprint already).  Also, each of these is persisted, so if you want
# something faster or don't require routing tree, you should consider using a stub or
# `route_class.make` to generate a non-persisted record.
#
require 'active_support/concern'

module SpecHelpers
  module BaseRoutes
    extend ActiveSupport::Concern

    included do
      let(:route_class)               { Route                                     }
      let(:root_1)                    { route_class.make!                         }
        let(:child_1)                 { route_class.make! :parent => root_1       }
          let(:grandchild_1)          { route_class.make! :parent => child_1      }
          let(:grandchild_2)          { route_class.make! :parent => child_1      }
            let(:great_grandchild_1)  { route_class.make! :parent => grandchild_2 }
            let(:great_grandchild_2)  { route_class.make! :parent => grandchild_2 }
        let(:child_2)                 { route_class.make! :parent => root_1       }
          let(:grandchild_3)          { route_class.make! :parent => child_2      }
            let(:great_grandchild_3)  { route_class.make! :parent => grandchild_3 }
      let(:root_2)                    { route_class.make!                         }

      let(:root)                      { route_class.make!                         }
      let(:child)                     { route_class.make! :parent => root         }
      let(:grandchild)                { route_class.make! :parent => child        }
      let(:great_grandchild)          { route_class.make! :parent => grandchild   }
    end
  end
end
