require 'fileutils'
require_relative 'file_writer'
require_relative 'message_writer'

class BasicEnv
  def initialize
    @title = ARGV.first
    @file_writer = FileWriter.new(ARGV)
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
    @file_writer.write
  end

  def commit_and_checkout
    `git add .`
    system("git commit -m 'Initial commit'")
    system("git checkout -b dev")
  end

  def run_test
    require "./test/#{ARGV.last}_test.rb"
  end

  def confirmation_message
    MessageWriter.new(@title).write
  end
end
