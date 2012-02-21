require 'active_support/concern'

module SpecHelpers
  module MultiSiteHelper
    extend ActiveSupport::Concern

    included do

    end

    def setup_site!(domain='www.example.org', behavior=::Behaviors::RenderOK)
      return ::Site.where(domain: domain).first || ::Site.make!(domain: domain, behavior: behavior)
    end

    def stub_app_with_circuit_site(my_site, middleware_klass=set_site_middleware)
      Rack::Builder.app do
        use middleware_klass, my_site
        use Circuit::Rack::Behavioral
        run Proc.new {|env| [404, {}, ["downstream #{env['PATH_INFO']}"]] }
      end
    end

    def set_site_middleware()
      (Class.new do
        def initialize(app, site)
          @app  = app
          @site = site
        end

        def call(env)
          env[Circuit::Rack::Behavioral::ENV_CURRENT_SITE] = @site
          @app.call(env)
        end
      end)
    end

    module ClassMethods

      def get(*args)
        before do
          super(*args) if respond_to?(:super)
          get *args
        end
      end

    end
  end
end
