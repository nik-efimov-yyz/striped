$:.push File.expand_path("../lib", __FILE__)
require "striped/version"

Gem::Specification.new do |s|
  s.name          = "striped"
  s.version       = Striped::VERSION
  s.author        = "Portfolio Den"
  s.email         = "dev@portfolioden.com"
  s.summary       = "Striped-based SaaS platform for Rails"

  s.require_paths  = ["lib"]

  s.add_development_dependency("rails", ">= 3.2.13", "< 5")
  s.add_development_dependency "rspec"

end