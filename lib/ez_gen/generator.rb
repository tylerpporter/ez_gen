require 'fileutils'
require 'pastel'

# file/class name
title = ARGV.first
lower_name = ARGV.last
upper_name = lower_name.split('_').map{|word| word.capitalize}.join

# create the directories
%w(lib test .scripts).each {|dir| FileUtils.mkdir_p "#{title}/#{dir}"}

# cd into new directory
Dir.chdir "#{title}"

# initialize git
`git init`

#write Rakefile
rake = File.open("Rakefile", "w")
rake.write(
'require "rake/testtask"

Rake::TestTask.new do |task|
  task.pattern = "test/*_test.rb"
end

desc "Run single test file based on class name, ex: rake test_class person"
task :test_class do
  ARGV.each { |arg| task arg.to_sym do ; end }
  eval File.read("./test/#{ARGV.last}_test.rb")
end

desc "Generate new class and test, ex: rake g person"
task :g do
  ARGV.each { |arg| task arg.to_sym do ; end }
  ruby "./.scripts/generate.rb #{ARGV.last}"
end
'
)
rake.close

# write test helper
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

# write class template
class_file = File.open("lib/#{lower_name}.rb", 'w')
class_file.write("class #{upper_name}\n\nend")
class_file.close

# write test template
test_file = File.open("test/#{lower_name}_test.rb", 'w')
test_file.write(
"require './test/test_helper.rb'
require './lib/#{lower_name}.rb'

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

# write generator
generator = File.open("./.scripts/generate.rb", 'w')
generator.write(
'lower_name = ARGV.first
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
'
)
generator.close

# write README
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

# write pr template
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

# write gitignore
ignore = File.open(".gitignore", "w")
ignore.write("coverage/")
ignore.close

# git
`git add .`
system("git commit -m 'Initial commit'")
system("git checkout -b dev")

# run the test
eval File.read(test_file)

# confirmation message
pastel = Pastel.new
message = {
  spacing1: " " * 10,
  spacing2: " " * 15,
  title: pastel.bold.magenta("#{title}"),
  repo: pastel.italic.cyan("Created new repository: "),
  branch: pastel.italic.cyan("Switched to new branch: "),
  dev: pastel.bold.magenta("dev"),
  run: pastel.italic.cyan("Run: "),
  cd: pastel.magenta.bold("cd #{title}"),
  rake: pastel.magenta.bold("rake --tasks "),
  options: pastel.italic.cyan("to see available rake tasks"),
  then: pastel.italic.cyan("then..."),
  instructions: pastel.cyan.bold("INSTRUCTIONS:")
}
4.times do
  puts ""
end
puts message[:spacing1] + message[:repo] + message[:title]
puts ""
puts message[:spacing1] + message[:branch] + message[:dev]
puts ""
puts message[:spacing2] + message[:instructions]
puts ""
puts message[:spacing1] + message[:run] + message[:cd]
puts ""
puts message[:spacing1] + message[:then]
puts ""
puts message[:spacing1] + message[:run] + message[:rake] + message[:options]
4.times do
  puts ""
end
