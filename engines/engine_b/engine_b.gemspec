require_relative "lib/engine_b/version"

Gem::Specification.new do |spec|
  spec.name        = "engine_b"
  spec.version     = EngineB::VERSION
  spec.authors     = [ "SaaS Template" ]
  spec.email       = [ "dev@example.test" ]
  spec.summary     = "SaaS Template admin shell engine"
  spec.description = "Tenant-aware Rails engine that serves the generic React admin shell"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.3"
end
