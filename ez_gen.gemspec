require_relative 'lib/ez_gen/version'

Gem::Specification.new do |spec|
  spec.name          = "ez_gen"
  spec.version       = EzGen::VERSION
  spec.authors       = ["Tyler Porter"]
  spec.email         = ["tylerpporter@gmail.com"]
  spec.summary       = %q{Quickly create an environment to write and test Ruby code.}
  spec.description   = %q{Enter a project name and the name of the class you'd like to create. EzGen will generate a new git repo, class template, corresponding test template, PR template, README template, and Rakefile.}
  spec.homepage      = "https://github.com/tylerpporter/ez_gen"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tylerpporter/ez_gen"
  spec.files         = ['lib/ez_gen.rb', 'lib/ez_gen/version.rb', 'lib/ez_gen/basic_env.rb', 'lib/ez_gen/file_writer.rb', 'lib/ez_gen/message_writer.rb']
  spec.executables   = ['ez_gen']
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency('pastel', '~> 0.8')
  spec.add_runtime_dependency('simplecov', '~> 0.19')
end
