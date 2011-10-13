# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hatch_postcode_anywhere/version"
require 'bundler'

Gem::Specification.new do |s|
  s.name        = "hatch_postcode_anywhere"
  s.version     = Hatch::VERSION
  s.authors     = ["Kevin Edwards"]
  s.email       = ["kev@thisishatch.co.uk"]
  s.homepage    = ""
  s.summary     = %q{Interface to the postcode anywhere API}
  s.description = %q{Interface to the postcode anywhere API}

  s.rubyforge_project = "hatch_elements"

  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('httparty', '>=0.8.1')
end
