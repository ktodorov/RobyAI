module RobyIO
  def printn(input, *args)
    puts "\n", input
    args.each do |arg|
      puts "\n", arg
    end
  end
end