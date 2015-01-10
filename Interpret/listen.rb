class Listen
  extend RobyIO
  def Listen.start_listening()
    input = gets
    
    recognized_input = Recognize.recognize_input(input)

    if recognized_input == false
      printn "Sorry, could not understand, try again"
    elsif recognized_input == nil
      printn "Goodbye!"
      return
    end

    start_listening()
  end
end