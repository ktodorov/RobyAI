module RobyIO
  def printn(input, *args)
    puts "\n", "\033[36m#{input}\033[0m"
    args.each do |arg|
      puts "\n", "\033[36m#{arg}\033[0m"
    end
  end
end