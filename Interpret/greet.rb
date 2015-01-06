class Greet

  def self.check_user_info()
    puts "What's your name?"
      user_info = DbOperations.check_if_user_exists(gets)
      if user_info == nil
      	puts "Sorry, but I didn't found anything for you :(\nDo you want to try typing your name again?"
      	if Recognize.check_answer(gets)
      		puts "\nOkay. "
    	    check_user_info()
    	  else
    	  	puts "As you wish. I hope you come back and talk to me again one day.\nGoodbye!"
    	  	return
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

    end
  end
end