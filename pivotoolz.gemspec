
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pivotoolz/version"

Gem::Specification.new do |spec|
  spec.name          = "pivotoolz"
  spec.version       = Pivotoolz::VERSION
  spec.authors       = ["Sufyan Adam"]
  spec.email         = ["sufyan@sealmail.net"]

  spec.summary       = %q{Tools to save you time when working with Pivotal Tracker stories}
  spec.description   = %q{Auto-deliver your finished stories upon successful deployment, find out which stories went out in the last deployment, get a list of pivotal tracker story ids that went out in the last deployment.}
  spec.homepage      = "https://github.com/sufyanadam/pivotoolz"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client', "~> 2.0.2"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
