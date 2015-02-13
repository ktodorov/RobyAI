require_relative 'recognize.rb'

module Listen
  extend RobyIO

  def start_listening()
    printn "\n#{ ContinueWords.get_one() }"
    
    input = gets
    
    if is_important(input)
      start_listening()
      return
    end

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