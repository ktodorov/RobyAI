require_relative 'recognize.rb'

module Listen
  extend RobyIO

  def start_listening()
    input = gets
    
    recognized = recognize_input(input)

    if recognized == false
      printn "Sorry, could not understand, try again"
    elsif recognized == nil
      printn "Goodbye!"
      return
    end

    start_listening()
  end
end