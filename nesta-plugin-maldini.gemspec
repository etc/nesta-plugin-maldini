# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nesta-plugin-maldini/version"

Gem::Specification.new do |s|
  s.name        = "nesta-plugin-maldini"
  s.version     = Nesta::Plugin::Maldini::VERSION
  s.authors     = ["Brad Weslake"]
  s.email       = ["brad.weslake@gmail.com"]
  s.homepage    = "http://bweslake.org/research/resources/maldini"
  s.summary     = %q{BibTeX citations and reference lists for Nesta}
  s.description = <<-EOF
  Maldini is a plugin for Nesta to generate citations and reference lists from BibTeX files.  
  EOF

  s.rubyforge_project = "nesta-plugin-maldini"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # DEPENDENCIES
  s.add_development_dependency("rake")

  s.add_dependency("nesta", ">= 0.9.10")
  s.add_dependency("bibtex-ruby", ">= 1.3.12")

  # For now, Maldini does not depend on citeproc-ruby
  # s.add_dependency("citeproc-ruby", ">= 0.0.2")

end
