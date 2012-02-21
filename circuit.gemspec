# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "circuit/version"

Gem::Specification.new do |s|
  s.name        = "circuit"
  s.version     = Circuit::VERSION
  s.authors     = ["Blake Chambers", "Maxmedia"]
  s.email       = ["chambb1@gmail.com"]
  s.homepage    = "https://github.com/maxmedia/circuit"
  s.summary     = %q{dynamic rack routing platform}
  s.description = %q{dynamic rack routing platform}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency "mongoid",      "~> 2.3"
  s.add_runtime_dependency "mongoid-tree", "~> 0.6"
  s.add_runtime_dependency "bson_ext",     "~> 1.4"
  # see Gemfile for development dependencies
end