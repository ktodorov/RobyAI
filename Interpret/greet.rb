class Greet
  extend Entities::Operations
  extend RobyIO

  def self.check_user_info()
    printn "What's your name?\n"
      user_info = user_info(gets)
      if user_info == nil
        printn "Sorry, but I didn't found anything for you :(\nDo you want to try typing your name again?\n"
        recognized_answer =	Recognize.check_answer(gets)
        if recognized_answer
          printn "\nOkay. "
          check_user_info()
        elsif recognized_answer != nil
          printn "As you wish. I hope you come back and talk to me again one day.\nGoodbye!"
          return
        else
          printn "I'm sorry, could not understand. Try again, please."
          check_user_info()
        end
      elsif
        printn "I found you, #{ user_info["first_name"] } #{ user_info["last_name"] }"
        update_login(user_info["username"])
        Listen.start_listening()
      end
  end
  
  # Поздравяваме потребителя и питаме дали вече е регистриран
  # Ако отговори положително, преглеждаме името, което подаде в базата данни
  # Ако съществува, продължаваме, а ако не - опитваме пак с ново име
  def Greet.greet()
    printn "Hello, I am Roby.."
    recent_login = check_recent_logins()
    if !recent_login
      find_user()
    elsif
      printn "Hello again, #{ recent_login.FirstName } #{ recent_login.LastName }"
      update_login(recent_login.Username)
      Listen.start_listening()
    end
  end

  def self.find_user()
    printn "Do we know each other?\n"
    answer = Recognize.check_answer(gets)

    if answer
      printn "\nGreat! "
      check_user_info()
    
    elsif answer == false
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