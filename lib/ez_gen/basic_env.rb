require 'fileutils'
require_relative 'file_writer'
require_relative 'message_writer'

class BasicEnv
  def initialize
    @title = ARGV.first
    @writer = FileWriter.new(ARGV)
    @test_file = ''
  end

  def generate
    create_directories
    cd_new_directory
    initialize_git
    write_template_files
    commit_and_checkout
    run_test
    confirmation_message
  end

  private

  def create_directories
    %w(lib test .scripts).each {|dir| FileUtils.mkdir_p "#{@title}/#{dir}"}
  end

  def cd_new_directory
    Dir.chdir "#{@title}"
  end

  def initialize_git
    `git init`
  end

  def write_template_files
    @writer.write_rake
    @writer.write_test_helper
    @writer.write_class_template
    @test_file = @writer.write_test_file
    @writer.write_generator
    @writer.write_readme
    @writer.write_pr_template
    @writer.write_gitignore
  end

  def commit_and_checkout
    `git add .`
    system("git commit -m 'Initial commit'")
    system("git checkout -b dev")
  end

  def run_test
    eval File.read(@test_file)
  end

  def confirmation_message
    MessageWriter.new(@title).write
  end
end
