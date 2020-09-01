require_relative 'template'

class FileWriter
  attr_reader :test_file
  def initialize(args)
    @lower_name = args.last
    @upper_name = @lower_name.split('_').map(&:capitalize).join
    @test_file = nil
  end

  def write
    write_rake
    write_test_helper
    write_class_template
    write_test_file
    write_generator
    write_readme
    write_pr_template
    write_gitignore
  end

  private

  def write_rake
    rake = File.open("Rakefile", "w")
    rake.write(Template.rake_template)
    rake.close
  end

  def write_test_helper
    test_helper = File.open("test/test_helper.rb", "w")
    test_helper.write(Template.test_helper_template)
    test_helper.close
  end

  def write_class_template
    class_file = File.open("lib/#{@lower_name}.rb", 'w')
    class_file.write(Template.class_template(@upper_name))
    class_file.close
  end

  def write_test_file
    test_file = File.open("test/#{@lower_name}_test.rb", 'w')
    test_file.write(Template.test_template(@lower_name, @upper_name))
    test_file.close
    @test_file = test_file
  end

  def write_generator
    generator = File.open("./.scripts/generate.rb", 'w')
    generator.write(Template.generator_template)
    generator.close
  end

  def write_readme
    readme = File.open("README.md", 'w')
    readme.write(Template.readme_template)
    readme.close
  end

  def write_pr_template
    pr = File.open("pull_request_template.md", "w")
    pr.write(Template.pr_template)
    pr.close
  end

  def write_gitignore
    ignore = File.open(".gitignore", "w")
    ignore.write("coverage/")
    ignore.close
  end
end
