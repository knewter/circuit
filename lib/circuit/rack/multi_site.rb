module Circuit
  module Rack
    class MultiSite

      def initialize(app)
        @app = app
      end

      def call(env)
        host, port = env["HTTP_HOST"].split(":")
        site = ::Site.where(domain: host).first || ::Site.where(domain: remap(host)).first
        unless site
          if Circuit.default_host
            return [301, {'Location' => "http://#{Circuit.default_host}"}, ["you are being redirected"]]
          else
            return [404, {}, ["not found"]]
          end
        end

        env[Behavioral::ENV_CURRENT_SITE] = site
        @app.call(env)
      end

      def remap(host)
        host_preregex = host.gsub('.', '\\.').gsub('*', '.+')
        host_regex    = /^#{host_preregex}$/
        return Circuit.default_host if Circuit.default_host and Circuit.default_host[host_regex]

        matching_key, matching_remap = match_with(host_regex)
        (matching_remap && matching_remap['to']) || Circuit.default_host || host
      end

      def match_with(regex)
        Circuit.hosts.detect do |pair|
          pair.first =~ regex
        end
      end

    end
  end
end
