require_relative '../Entities/operations.rb'
require_relative '../IO/roby_io.rb'
require_relative 'listen.rb'

module Greet
  include Entities::Operations
  include RobyIO
  include Listen
  include Recognize

  def check_user_info()
    printn "What's your name?"
      user_info = get_user_info(gets)
      if user_info == nil
        printn "Sorry, but I didn't found anything for you :(", "Do you want to try typing your name again?"
        recognized_answer =	check_answer(gets)
        if recognized_answer
          printn "Okay. "
          check_user_info()
        elsif recognized_answer != nil
          printn "As you wish. I hope you come back and talk to me again one day.", "Goodbye!"
          return
        else
          printn "I'm sorry, could not understand. Try again, please."
          check_user_info()
        end
      else
        $current_user_id = user_info["id"]
        printn "I found you, #{ user_info["first_name"] } #{ user_info["last_name"] }", "What do you want to do?"
        update_login(user_info["username"])
        start_listening()
      end
  end
  
  # Поздравяваме потребителя и питаме дали вече е регистриран
  # Ако отговори положително, преглеждаме името, което подаде в базата данни
  # Ако съществува, продължаваме, а ако не - опитваме пак с ново име
  def greet_user()
    printn "Hello, I am Roby.."
    recent_login = check_recent_logins()
    if !recent_login
      find_user()
    elsif
      printn "Hello again, #{ recent_login.FirstName } #{ recent_login.LastName }", "What do you want to do?"
      update_login(recent_login.Username)
      $current_user_id = recent_login.Id
      start_listening()
    end
  end

  def find_user()
    printn "Do we know each other?"
    answer = check_answer(gets)

    if answer
      printn "Great! "
      check_user_info()
    
    elsif answer == false
      result = create_user()
      if not result
        printn "Sorry but something broke!"
        return
      end
      printn "Great!", "I remembered you."
      start_listening()
    
    else
      printn "Sorry, I did not understand.", "Try again"
      find_user()
    end
  end
end