module Behaviors
  class RenderOK
    include ::Circuit::Behavior

    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        [200, {"Content-Type" => "text/plain"}, ["ok"]]
      end
    end

    use Middleware
  end
end
