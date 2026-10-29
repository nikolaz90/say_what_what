# frozen_string_literal: true

require_relative "lib/say_what_what/version"

Gem::Specification.new do |spec|
  spec.name        = "say_what_what"
  spec.version     = SayWhatWhat::VERSION
  spec.authors     = ["Nikolaz Stacey"]
  spec.email       = ["nikolazstacey@hotmail.co.uk"]
  spec.homepage    = "https://github.com/nikolaz90/say_what_what"
  spec.summary     = "Summary of SayWhatWhat."
  spec.description = "Description of SayWhatWhat."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.require_paths = ["lib"]

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "pagy", "~> 43.7"
  spec.add_dependency "rails", ">= 8.1.3"
end
