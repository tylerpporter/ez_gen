require 'pastel'

class MessageWriter
  PASTEL = Pastel.new

  def initialize(title)
    @title = title
    @message = {}
  end

  def write
    stylize
    message 
  end

  private

  def message
    puts "\n" * 4
    puts spacing[:spacing1] + @message[:repo] + @message[:title],""
    puts spacing[:spacing1] + @message[:branch] + @message[:dev],""
    puts spacing[:spacing2] + @message[:instructions],""
    puts spacing[:spacing1] + @message[:run] + @message[:cd],""
    puts spacing[:spacing1] + @message[:then],""
    puts spacing[:spacing1] + @message[:run] + @message[:rake] + @message[:options],""
    puts "\n" * 4
  end

  def spacing
    {
      spacing1: " " * 10,
      spacing2: " " * 15,
    }
  end

  def cyan_italic
    {
      repo: "Created new repository: ",
      branch: "Switched to new branch: ",
      run: "Run: ",
      options: "to see available rake tasks",
      then: "then..."
    }
  end

  def magenta_bold
    {
      title: @title,
      dev: "dev",
      cd: "cd #{@title}",
      rake: "rake --tasks "
    }
  end

  def cyan_bold
    {
      instructions: "INSTRUCTIONS:"
    }
  end

  def stylize
    cyan_italic.each { |k,v| @message[k] = PASTEL.italic.cyan(v) }
    magenta_bold.each { |k,v| @message[k] = PASTEL.bold.magenta(v) }
    cyan_bold.each { |k,v| @message[k] = PASTEL.bold.cyan(v) }
  end
end
