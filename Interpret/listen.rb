class Listen
  extend RobyIO
  def Listen.start_listening()
    input = gets
    
    recognized = Recognize.recognize_input(input)

    if recognized == false
      printn "Sorry, could not understand, try again"
    elsif recognized == nil
      printn "Goodbye!"
      return
    end

    start_listening()
  end
end