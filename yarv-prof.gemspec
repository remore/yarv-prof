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
  s.description = 'A DTrace-based YARV profiler'
  s.license = 'MIT'

  s.add_dependency "enumerable-statistics"
end
