if Object.const_defined?(:Rails)
  require "circuit/railtie"
end

module Circuit
  autoload :Behavior, 'circuit/behavior'
  autoload :Site,     'circuit/site'
  autoload :Tree,     'circuit/tree'

  module Rack
    autoload :Behavioral, 'circuit/rack/behavioral'
    autoload :MultiSite,  'circuit/rack/multi_site'
  end

  def self.hosts
    @hosts || {}
  end

  def self.default_host
    @default_host
  end
  
  def self.load_hosts!(config_path="#{Rails.root}/config/circuit_hosts.yml")
    raw_file      = File.read(File.expand_path(config_path))
    hosts         = YAML.load(raw_file)[Rails.env]
    @default_host = hosts.delete("default")
    @hosts        = hosts
  end
  
end

module Behaviors
  autoload :Forward,                'behaviors/forward'
  autoload :MountByFragmentOrRemap, 'behaviors/mount_by_fragment_or_remap'
  autoload :RenderOK,               'behaviors/render_ok'
end
