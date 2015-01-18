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
          match["last_login"] = user.LastLogin
          return match
        end
      end
    
      nil
    end

    def update_login(username)
      user = Users.where(["Username = :username", { username: username }]).first
      Users.update(user.Id, :LastLogin => Time.now.localtime)
    end

    def check_recent_logins()
      last_user = Users.order('LastLogin DESC').first
      return false if last_user.LastLogin == nil
      difference_in_minutes = (Time.now.localtime - last_user.LastLogin) / 60
      return false if difference_in_minutes > 60
      return last_user
    end

    def create_user()
      printn "\nOkay, let me learn something about you.\n\nWhat's your username?"
      username = gets
      printn "\nWhat's your full name?"
      full_name = gets.squeeze(' ').lstrip.rstrip.split(' ')
      first_name = full_name.first
      last_name = full_name[1..-1].join(" ")
      printn "\nFinally, where are you born?"
      birth_place = gets
      printn "\nAnd when?"
      birth_date = gets
      current_time = Time.now.localtime
      Users.create(Id: Users.all.last.Id + 1, Username: username, FirstName: first_name, LastName: last_name, BirthDate: birth_date, BirthPlace: birth_place, LastLogin: current_time)
      $current_user_id = Users.all.last.Id
    end

    def add_appointment(subject, start_date, end_date, description, address, record_type_id)
      Records.create(Id: Records.all.last.Id + 1, Subject: subject, StartDate: start_date, EndDate: end_date,
                     Description: description, Address: address, UserId: $current_user_id, RecordTypeId: record_type_id)
    end
  end
end