# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ancestry_uniqueness/version'

Gem::Specification.new do |spec|
  spec.name          = "ancestry_uniqueness"
  spec.version       = Ancestry::Uniqueness::VERSION
  spec.authors       = ["Flauwekeul"]
  spec.email         = ["flauwekeul@gmail.com"]
  spec.description   = %q{Uniqueness validator when using the ancestry gem.}
  spec.summary       = %q{Provides a uniqueness validator for objects that are ordered in a tree using the ancestry gem.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"

  spec.add_dependency "ancestry", "~> 2.0"
  spec.add_dependency "activerecord", "~> 4.0"
end
