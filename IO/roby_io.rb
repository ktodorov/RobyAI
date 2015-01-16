module RobyIO
  def printn(input, color: "cyan", **args)
    puts "\n", colorize(color, input)
    args.each do |arg|
      puts "\n", colorize(color, arg)
    end
  end

  private

  def colorize(color, text)
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