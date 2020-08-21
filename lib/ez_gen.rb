require "ez_gen/version"

module EzGen
  class Template
    def self.generate
      require 'ez_gen/generator.rb'
    end
  end
end
