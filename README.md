# EzGen

**EzGen is a Ruby Gem to help you quickly create a template based environment to write and test Ruby code.**

EzGen takes two command line arguments, *project name* and *class name*. It will then generate a git repository as *project name* and create a Ruby class template as *class name* along with a corresponding test template. Additional generated files include a Rakefile, README template, and Pull Request template.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ez_gen'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ez_gen

## Usage
From your root project folder, in the command line run:

    $ ez_gen <project_name> <class_name>

EzGen generates this file structure:
```
<project_name>
├── lib
│   └── <class_name>.rb
├── test
│   ├── <class_name>_test.rb
│   └── test_helper.rb
├── README.md
├── Rakefile
└── pull_request_template.md

```
With an empty class template:

``` ruby
class ClassName

end
```
And a test template:

``` ruby
require './test/test_helper.rb'
require './lib/class_name.rb'

class ClassNameTest < Minitest::Test
  def setup
    @class_name = ClassName.new
  end

  def test_it_exists
    assert_instance_of ClassName, @class_name
  end
end
```
*EzGen writes your `initial commit` and then checks out a new branch `dev`.*

**After you `cd` into the new project folder, you will have access to a few `rake` commands:**

    $ rake test
*runs all test files in the project*
***

    $ rake test_class

*takes one argument, **class name**, and runs the corresponding test file, ex: `rake test_class class_name`*
***
    $ rake g

*takes one argument, **class name**, and generates a new class template file and corresponding test file, ex: `rake g class_name`*
***

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tylerpporter/ez_gen.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
