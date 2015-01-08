class Greet
  extend Entities::Operations
  extend RobyIO

  def self.check_user_info()
    printn "What's your name?"
      user_info = user_info(gets)
      if user_info == nil
        printn "Sorry, but I didn't found anything for you :(\nDo you want to try typing your name again?"
        recognized_answer =	Recognize.check_answer(gets)
        if recognized_answer
          printn "\nOkay. "
          check_user_info()
        elseif recognized_answer != nil
          printn "As you wish. I hope you come back and talk to me again one day.\nGoodbye!"
          return
        else
          printn "I'm sorry, could not understand. Try again, please."
          check_user_info()
        end
      end

      printn "I found you, #{ user_info["first_name"] } #{ user_info["last_name"] }"

      Listen.start_listening()
  end
  
  # Поздравяваме потребителя и питаме дали вече е регистриран
  # Ако отговори положително, преглеждаме името, което подаде в базата данни
  # Ако съществува, продължаваме, а ако не - опитваме пак с ново име
  def Greet.greet()
    printn "Hello, I am Roby.."
    find_user
  end

  def self.find_user()
    printn "Do we know each other?"
    answer = Recognize.check_answer(gets)

    if answer
      printn "\nGreat! "
      check_user_info()
    
    elseif answer == false
      result = create_user()
      if not result
        printn "Sorry but something broke!"
        return
      end
      printn "Great! I remembered you."
      Listen.start_listening()
    
    else
      printn "Sorry, I did not understand.\nTry again"
      find_user()
    end
  end
end