# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

#require 'envcrypt/version'

Gem::Specification.new do |s|
  s.name        = "envcrypt"
  s.version     = Envcrypt::VERSION
  s.authors     = ["Sterling Paramore"]
  s.email       = ["gnilrets@gmail.com"]
  s.homepage    = "https://github.com/gnilrets"
  s.license     = "MIT"
  s.summary     = "Simple secure encryption/decryption of secret data"
  s.description = "Simple secure encryption/decryption of secret data (passwords)"
  s.rubyforge_project = "envcrypt"

  s.required_ruby_version = '~> 2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
