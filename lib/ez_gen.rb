require 'ez_gen/version'
require 'ez_gen/basic_env.rb'

module EzGen
  class Generator
    def self.generate_basic_env
      BasicEnv.new.generate
    end
  end
end
