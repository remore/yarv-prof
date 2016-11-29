lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yarv-prof/version'

Gem::Specification.new do |s|
  s.name = 'yarv-prof'
  s.version = YarvProf::VERSION
  s.homepage = 'https://github.com/remore/yarv-prof'

  s.authors = 'Kei Sawada(@remore)'
  s.email   = 'k@swd.cc'

  s.files = `git ls-files`.split("\n")
  s.bindir = 'bin'
  s.executables = 'yarv-prof'

  s.summary = 'A DTrace-based YARV profiler'
  s.description = "yarv-prof does nothing special to profile YARV behavior, just heavily depends on Ruby's DTrace probes support. If you are looking for something useful to utilize Ruby's DTrace feature, yarv-prof may work for you."
  s.license = 'MIT'

  s.add_dependency "enumerable-statistics"
end
