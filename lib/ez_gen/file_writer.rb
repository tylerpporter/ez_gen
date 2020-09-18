require_relative 'templatable'

class FileWriter
  include Templatable
  def initialize(args)
    @lower_name = args.last
    @upper_name = @lower_name.split('_').map(&:capitalize).join
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
    rake.write(rake_template)
    rake.close
  end

  def write_test_helper
    test_helper = File.open("test/test_helper.rb", "w")
    test_helper.write(test_helper_template)
    test_helper.close
  end

  def write_class_template
    class_file = File.open("lib/#{@lower_name}.rb", 'w')
    class_file.write(class_template(@upper_name))
    class_file.close
  end

  def write_test_file
    test_file = File.open("test/#{@lower_name}_test.rb", 'w')
    test_file.write(test_template(@lower_name, @upper_name))
    test_file.close
  end

  def write_generator
    generator = File.open("./.scripts/generate.rb", 'w')
    generator.write(generator_template)
    generator.close
  end

  def write_readme
    readme = File.open("README.md", 'w')
    readme.write(readme_template)
    readme.close
  end

  def write_pr_template
    pr = File.open("pull_request_template.md", "w")
    pr.write(pr_template)
    pr.close
  end

  def write_gitignore
    ignore = File.open(".gitignore", "w")
    ignore.write("coverage/")
    ignore.close
  end
end
