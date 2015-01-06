module DbOperations
	include Entities

  def DbOperations.user_info(name)
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
end