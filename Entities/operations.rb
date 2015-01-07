module Entities
  module Operations
    def user_info(name)
  	  name = name.squeeze(' ').lstrip.rstrip.downcase
  	  match = {}
      Users.all.each do |user|
        if user.Username.eql? name or user.FirstName.downcase.eql? name or user.LastName.downcase.eql? name or (user.FirstName + user.LastName).downcase.eql? name
          match["username"] = user.Username
          match["first_name"] = user.FirstName
          match["last_name"] = user.LastName
          match["birth_date"] = user.BirthDate
          match["birth_place"] = user.BirthPlace
          return match
        end
      end
    
      nil
    end

    def create_user()
      puts "\nOkay, let me learn something about you.\n\nWhat's your username?"
      username = gets
      puts "\nWhat's your full name?"
      full_name = gets.squeeze(' ').lstrip.rstrip.split(' ')
      first_name = full_name.first
      last_name = full_name[1..-1].join(" ")
      puts "\nFinally, where are you born?"
      birth_place = gets
      puts "\nAnd when?"
      birth_date = gets
      Users.create(Id: Users.all.last.Id + 1, Username: username, FirstName: first_name, LastName: last_name, BirthDate: birth_date, BirthPlace: birth_place)
    end
  end
end