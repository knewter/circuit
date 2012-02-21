module Circuit
  module Rack
    class Behavioral
      ENV_SCRIPT_NAME     = 'rack.circuit.script_name'
      ENV_PATH_INFO       = 'rack.circuit.path_info'
      ENV_CURRENT_SITE    = 'rack.circuit.site'
      ENV_CURRENT_ROUTE   = 'rack.circuit.current_route'
      ENV_ROUTE_ANCESTORS = 'rack.circuit.route_ancestors'

      def initialize(app)
        @app = app
      end

      def call(env)
        raise unless env[ENV_CURRENT_SITE]

        setup_request!(env)
        response = remap_by_fragment!(env)
        return @app.call(env) if response == :not_found

        behavior = env[ENV_CURRENT_ROUTE].behavior

        response = rewrite_env_with_behavior! behavior, env
        return @app.call(env) if response == :rewrite_failed

        use = behavior.stack.to_a
        use = use.map { |middleware| proc { |app| middleware.new(app) } }
        use.reverse.inject(@app) { |a,e| e[a] }.call(env)
      end

      def remap_by_fragment!(env)
        behavior  = env[ENV_CURRENT_ROUTE].behavior
        fragments = env[ENV_PATH_INFO].gsub(/^\//,'').split(/\/+/).compact

        return :route_determined unless remapable_behavior?(behavior)
        return :route_determined if     fragments.empty?

        next_fragment = fragments.shift
        child_route = env[ENV_ROUTE_ANCESTORS].last.find_child_by_fragment(next_fragment)

        return :not_found unless child_route

        env[ENV_ROUTE_ANCESTORS] << child_route
        env[ENV_CURRENT_ROUTE] = child_route

        env[ENV_SCRIPT_NAME] << "/" << next_fragment
        env[ENV_PATH_INFO] = "/" << fragments.join("/")

        remap_by_fragment!(env)
      end

      def rewrite_env_with_behavior!(behavior, env)
        return :rewrite_not_configured unless behavior.respond_to?(:rewrite_env_as!)
        old_path = env["PATH_INFO"]
        behavior.rewrite_env_as! env
        Rails.logger.info("REROUTING: '#{old_path}'->'#{env['PATH_INFO']}'")
        :rewritten
      rescue ::Circuit::Behavior::RewriteException => ex
        Rails.logger.info("REROUTING: [ERROR] #{ex.inspect}")
        return :rewrite_failed
      end

      def setup_request!(env)
        env[ENV_PATH_INFO]       ||= env['PATH_INFO']
        env[ENV_SCRIPT_NAME]     ||= env['SCRIPT_NAME']
        env[ENV_CURRENT_ROUTE]   ||= env[ENV_CURRENT_SITE]
        env[ENV_ROUTE_ANCESTORS] ||= [env[ENV_CURRENT_ROUTE]]
      end

      def remapable_behavior?(behavior)
        behavior.respond_to?(:remap_by_fragment) && behavior.remap_by_fragment
      end
    end
  end
end
