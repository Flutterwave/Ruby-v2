
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rave_ruby/version"

Gem::Specification.new do |spec|
  spec.name          = "rave_ruby"
  spec.version       = RaveRuby::VERSION
  spec.authors       = ["Iphytech"]
  spec.email         = ["ifunanyaikemma@gmail.com"]
  spec.date        = '2019-01-19'
  spec.summary       = %q{Ruby Gem For Rave Payments By Flutterwave.}
  spec.description   = %q{This is the official Ruby Gem For Rave Payments which includes Card, Account, Transfer, Subaccount, Subscription, Mpesa, Ghana Mobile Money, Ussd, Payment Plans, and Transfer payment methods.}
  spec.homepage      = "https://github.com/Iphytech/rave-ruby"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
    spec.metadata["changelog_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0.6"
  spec.add_development_dependency "rspec", "~> 3.2"
  #add dotenv
  spec.add_development_dependency "dotenv", "~> 2.8.1"

  # Dependencies
  spec.required_ruby_version = ">= 2.5.3"
  spec.add_runtime_dependency 'httparty', '~> 0.21.0'
end
