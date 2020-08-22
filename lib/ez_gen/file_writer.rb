class FileWriter
  def initialize(args)
    @args = args
    @lower_name = args.last
    @upper_name = @lower_name.split('_').map(&:capitalize).join
  end

  def write_rake
    rake = File.open("Rakefile", "w")
    rake.write(
    'require "rake/testtask"

    Rake::TestTask.new do |task|
      task.pattern = "test/*_test.rb"
    end

    desc "Run single test file based on class name, ex: rake test_class person"
    task :test_class do
      @args.each { |arg| task arg.to_sym do ; end }
      eval File.read("./test/#{@lower_name}_test.rb")
    end

    desc "Generate new class and test, ex: rake g person"
    task :g do
      @args.each { |arg| task arg.to_sym do ; end }
      ruby "./.scripts/generate.rb #{@lower_name}"
    end
    '
    )
    rake.close
  end

  def write_test_helper
    test_helper = File.open("test/test_helper.rb", "w")
    test_helper.write(
    "require 'simplecov'
    SimpleCov.start
    require 'minitest/autorun'
    require 'minitest/pride'
    require 'mocha/minitest'
    "
    )
    test_helper.close
  end

  def write_class_template
    class_file = File.open("lib/#{@lower_name}.rb", 'w')
    class_file.write("class #{@upper_name}\n\nend")
    class_file.close
  end

  def write_test_file
    test_file = File.open("test/#{@lower_name}_test.rb", 'w')
    test_file.write(
    "require './test/test_helper.rb'
    require './lib/#{@lower_name}.rb'

    class #{@upper_name}Test < Minitest::Test
      def setup
        @#{@lower_name} = #{@upper_name}.new
      end

      def test_it_exists
        assert_instance_of #{@upper_name}, @#{@lower_name}
      end
    end"
    )
    test_file.close
    test_file
  end

  def write_generator
    generator = File.open("./.scripts/generate.rb", 'w')
    generator.write(
    'lower_name = ARGV.first
    upper_name = lower_name.split("_").map{|word| word.capitalize}.join

    class_file = File.open("lib/#{@lower_name}.rb", "w")
    class_file.write("class #{@upper_name}\n\nend")
    class_file.close

    test_file = File.open("test/#{@lower_name}_test.rb", "w")
    test_file.write(
    "require \'./test/test_helper.rb\'
    require \'./lib/#{@lower_name}.rb\'

    class #{@upper_name}Test < Minitest::Test
      def setup
        @#{@lower_name} = #{@upper_name}.new
      end

      def test_it_exists
        assert_instance_of #{@upper_name}, @#{@lower_name}
      end
    end"
    )
    test_file.close
    eval File.read(test_file)
    puts ""
    puts "Created \'lib/#{@lower_name}.rb\' and \'test/#{@lower_name}_test.rb\'"
    puts ""
    '
    )
    generator.close
  end

  def write_readme
    readme = File.open("README.md", 'w')
    readme.write(
    '# Title

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
    '
    )
    readme.close
  end

  def write_pr_template
    pr = File.open("pull_request_template.md", "w")
    pr.write(
    "## Description

    ## Type of change
    - [ ] Bug fix (non-breaking change which fixes an issue)
    - [ ] Refactor (non-breaking change which maintains existing functionality)
    - [ ] New feature (non-breaking change which adds functionality)
    - [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
    ## Notes

    ## Test Results
    ```

    ```
    "
    )
    pr.close
  end

  def write_gitignore
    ignore = File.open(".gitignore", "w")
    ignore.write("coverage/")
    ignore.close
  end
end
