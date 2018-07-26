
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "redis_batch_push/version"

Gem::Specification.new do |spec|
  spec.name          = "redis_batch_push"
  spec.version       = RedisBatchPush::VERSION
  spec.authors       = ["Manoel Quirino Neto"]
  spec.email         = ["manoelifpb@gmail.com"]

  spec.summary       = %q{Provide a easy way to queue some messages and push them in batches.}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "mock_redis", "~> 0.18"
  spec.add_development_dependency "redis", "~> 4.0"
end
