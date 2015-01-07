class Greet
  extend Entities::Operations
  
  def self.check_user_info()
    puts "What's your name?"
      user_info = user_info(gets)
      if user_info == nil
      	puts "Sorry, but I didn't found anything for you :(\nDo you want to try typing your name again?"
      	recognized_answer =	Recognize.check_answer(gets)
      	if recognized_answer
      		puts "\nOkay. "
    	    check_user_info()
    	  elseif recognized_answer != nil
    	  	puts "As you wish. I hope you come back and talk to me again one day.\nGoodbye!"
    	  	return
    	  else
    	  	puts "I'm sorry, could not understand. Try again, please."
    	  	check_user_info()
      	end
      end

      puts "I found you! #{ user_info["username"] }, #{ user_info["first_name"] } #{ user_info["last_name"] }, #{ user_info["birth_date"] }, #{ user_info["birth_place"] }"
  end
  
  # Поздравяваме потребителя и питаме дали вече е регистриран
  # Ако отговори положително, преглеждаме името, което подаде в базата данни
  # Ако съществува, продължаваме, а ако не - опитваме пак с ново име
  def Greet.greet()
    puts "Hello, I am Roby..\n\nDo we know each other?"
    
    if Recognize.check_answer(gets)
    	puts "\nGreat! "
    	check_user_info()
    else
      result = create_user()
      if not result
        puts "Sorry but something broke!"
        return
      end

      puts "Great! I remembered you."
    end
  end
end