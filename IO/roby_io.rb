module RobyIO
  def printn(input, *args, color: "cyan")
    puts colorize_string(color, input)
    args.each do |arg|
      puts colorize_string(color, arg)
    end
    # puts "\n"
  end
  
  def colorize_string(color, text)
  	case color
  	when "black"
      "\033[30m#{text}\033[0m"
    when "red"
      "\033[31m#{text}\033[0m"
    when "green"
      "\033[32m#{text}\033[0m"
    when "brown"
      "\033[33m#{text}\033[0m"
    when "blue"
      "\033[34m#{text}\033[0m"
    when "magenta"
      "\033[35m#{text}\033[0m"
    when "cyan"
      "\033[36m#{text}\033[0m"
    when "gray"
      "\033[37m#{text}\033[0m"
    when "bg_black"
      "\033[40m#{text}\033[0m"
    when "bg_red"
      "\033[41m#{text}\033[0m"
    when "bg_green"
      "\033[42m#{text}\033[0m"
    when "bg_brown"
      "\033[43m#{text}\033[0m"
    when "bg_blue"
      "\033[44m#{text}\033[0m"
    when "bg_magenta"
      "\033[45m#{text}\033[0m"
    when "bg_cyan"
      "\033[46m#{text}\033[0m"
    when "bg_gray"
      "\033[47m#{text}\033[0m"
    when "bold"
      "\033[1m#{text}\033[22m"
    end
  end
end

class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def brown;          "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\033[0m" end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
end

class Object
  def gets
    print "\n"
    result = super()
    print "\n"
    result
  end
end