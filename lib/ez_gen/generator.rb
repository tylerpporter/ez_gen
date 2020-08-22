require 'fileutils'
require 'pastel'
require 'file_writer'

# file/class name
title = ARGV.first
writer = FileWriter.new(ARGV)

# create the directories
%w(lib test .scripts).each {|dir| FileUtils.mkdir_p "#{title}/#{dir}"}

# cd into new directory
Dir.chdir "#{title}"

# write template files
writer.write_rake
writer.write_test_helper
writer.write_class_template
test_file = writer.write_test_file
writer.write_generator
writer.write_readme
writer.write_pr_template
writer.write_gitignore

# git
`git init`
system("git checkout -b base_repo")
`git add .`
system("git commit -m 'Initial commit'")

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

puts "\n" * 4
puts message[:spacing1] + message[:repo] + message[:title],""
puts message[:spacing1] + message[:branch] + message[:dev],""
puts message[:spacing2] + message[:instructions],""
puts message[:spacing1] + message[:run] + message[:cd],""
puts message[:spacing1] + message[:then],""
puts message[:spacing1] + message[:run] + message[:rake] + message[:options],""
puts "\n" * 4
