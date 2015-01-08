class Listen
  def Listen.start_listening()
    input = gets
    
    recognized_input = Recognize.recognize_input(input)
    
    if recognized_input == false
      printn "Sorry, could not understand, try again"
    elseif recognized_input == nil
      printn "Goodbye!"
      return
    end

    start_listening()
  end
end