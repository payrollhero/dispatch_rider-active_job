# -*- encoding: utf-8 -*-

require File.expand_path('../lib/dispatch_rider/active_job/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "dispatch_rider-active_job"
  gem.version       = DispatchRider::ActiveJob::VERSION
  gem.summary       = %q{TODO: Summary}
  gem.description   = %q{TODO: Description}
  gem.license       = "MIT"
  gem.authors       = ["Piotr Banasik"]
  gem.email         = "piotr.banasik@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/dispatch_rider-active_job"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']


end
