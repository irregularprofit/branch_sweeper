# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'branch_sweeper/version'

Gem::Specification.new do |spec|
  spec.name          = "branch_sweeper"
  spec.version       = BranchSweeper::VERSION
  spec.authors       = ["Jimmy Hsu"]
  spec.email         = ["irregular.profit@gmail.com"]
  spec.summary       = %q{Scan for inactive branches in a specified repository. And offer to clean them up.}
  spec.description   = %q{Provides a command line tool
                          to scan a repository for branches
                          that have not been active for an year.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_dependency('methadone', '~> 1.7.0')
  spec.add_dependency('netrc')
  spec.add_dependency('octokit', '~> 3.0')
  spec.add_dependency('colorize')
  spec.add_dependency('highline')
end
