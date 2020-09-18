module Templatable
  def rake_template
    <<~HEREDOC
      require "rake/testtask"

      Rake::TestTask.new do |task|
        task.pattern = "test/*_test.rb"
      end

      desc "Run single test file based on class name, ex: rake test_class person"
      task :test_class do
        ARGV.each { |arg| task arg.to_sym do ; end }
        eval File.read("./test/\#{ARGV.last}_test.rb")
      end

      desc "Generate new class and test, ex: rake g person"
      task :g do
        ARGV.each { |arg| task arg.to_sym do ; end }
        ruby "./.scripts/generate.rb \#{ARGV.last}"
      end
    HEREDOC
  end

  def test_helper_template
    <<~HEREDOC
      require 'simplecov'
      SimpleCov.start
      require 'minitest/autorun'
      require 'minitest/pride'
      require 'mocha/minitest'
    HEREDOC
  end

  def class_template(class_name)
    <<~HEREDOC
      class #{class_name}

      end
    HEREDOC
  end

  def test_template(lower_name, upper_name)
    <<~HEREDOC
      require './test/test_helper.rb'
      require './lib/#{lower_name}.rb'

      class #{upper_name}Test < Minitest::Test
        def setup
          @#{lower_name} = #{upper_name}.new
        end

        def test_it_exists
          assert_instance_of #{upper_name}, @#{lower_name}
        end
      end
    HEREDOC
  end

  def generator_template
    <<~'HEREDOC'
      lower_name = ARGV.first
      upper_name = lower_name.split("_").map{|word| word.capitalize}.join

      class_file = File.open("lib/#{lower_name}.rb", "w")
      class_file.write("class #{upper_name}\n\nend")
      class_file.close

      test_file = File.open("test/#{lower_name}_test.rb", "w")
      test_file.write(
      "require \'./test/test_helper.rb\'
      require \'./lib/#{lower_name}.rb\'

      class #{upper_name}Test < Minitest::Test
        def setup
          @#{lower_name} = #{upper_name}.new
        end

        def test_it_exists
          assert_instance_of #{upper_name}, @#{lower_name}
        end
      end"
      )
      test_file.close
      eval File.read(test_file)
      puts ""
      puts "Created \'lib/#{lower_name}.rb\' and \'test/#{lower_name}_test.rb\'"
      puts ""
      HEREDOC
  end

  def readme_template
    <<~HEREDOC
      # Title

      *Description*

      ## Table of Contents:
      - [Running Locally](#running-locally)
      - [Tech Stack](#tech-stack)
      - [Contributors](#contributors)

      ***
      ## Running Locally
      [top](#table-of-contents)
      * Instructions to run locally

      ***
      ## Tech Stack
      [top](#table-of-contents)
      * Language version
      * Framework, gems, etc.

      ***
      ## Contributors
      [top](#table-of-contents)
      * [<NAME HERE>](<LINK TO GITHUB>)
    HEREDOC
  end

  def pr_template
    <<~HEREDOC
      ## Description

      ## Type of change
      - [ ] Bug fix (non-breaking change which fixes an issue)
      - [ ] Refactor (non-breaking change which maintains existing functionality)
      - [ ] New feature (non-breaking change which adds functionality)
      - [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
      ## Notes

      ## Test Results
      ```

      ```
    HEREDOC

  end
end
