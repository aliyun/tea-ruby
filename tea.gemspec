# frozen_string_literal: true

lib = 'tea_core'
lib_file = File.expand_path("../lib/#{lib}.rb", __FILE__)
File.read(lib_file) =~ /\bVERSION\s*=\s*["'](.+?)["']/
version = Regexp.last_match(1)

Gem::Specification.new do |s|
  s.name    = lib
  s.version = version
  s.platform           = Gem::Platform::RUBY
  s.authors            = ['Alibaba Cloud SDK']
  s.email              = ['sdk-team@alibabacloud.com']
  s.description        = 'Tea Core SDK for Ruby'
  s.homepage           = 'http://www.alibabacloud.com/'
  s.summary            = 'Tea Core SDK for Ruby'
  s.rubyforge_project  = 'tea'
  s.license            = 'MIT'
  s.files              = `git ls-files -z lib`.split("\0")
  s.files += %w[README.md]
  s.test_files         = `git ls-files -z spec`.split("\0")
  s.require_paths      = ['lib']

  s.add_development_dependency 'codecov', '~> 0.1', '>= 0.1.10'
  s.add_development_dependency 'rspec', '~> 3.8', '>= 3.8.0'
  s.add_development_dependency 'simplecov', '~> 0.16', '>= 0.16.1'
end
