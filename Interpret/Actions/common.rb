require_relative '../../Entities/records.rb'
require_relative '../../IO/roby_io.rb'

module ActionsModule
  def display_time(time = nil)
    return "It is now #{ Time.new.strftime "%H:%M" }" if !time
    time.strftime "%H:%M"
  end

  def display_date(date = nil)
    return "Today is #{ Time.new.strftime "%d/%m/%Y" }" if !date
    date.strftime "%d/%m/%Y"
  end

  def display_date_time(datetime = nil)
    return "It is now #{ Time.new.strftime "%d/%m/%Y %H:%M" }" if !datetime
    datetime.strftime "%d/%m/%Y %H:%M"
  end

  def display_appointments()
  	user_appointments = Records.Appointments.select { |app| app.UserId == $current_user.Id }.sort { |x, y| x.StartDate <=> y.StartDate }
  	return "It looks like you have no appointments saved" if user_appointments.empty?
    appointments_string = ""
  	user_appointments.each do |appointment|
      appointments_string += "\n---------------------\n".bold if !appointments_string.empty?
  		appointments_string += appointment_to_s(appointment)
  	end
  	"Here are your appointments:\n#{ appointments_string }"
  end

  def appointment_to_s(appointment)
    return nil if !appointment
    appointments_string  = "#{ appointment.Subject }".blue.bold
    appointments_string += "\nfrom #{ display_date_time(appointment.StartDate) }".blue if appointment.StartDate != nil
    appointments_string += "\nto   #{ display_date_time(appointment.EndDate)   }".blue if appointment.EndDate != nil
    appointments_string += "\nat   #{ appointment.Address                      }".blue if appointment.Address   != nil
    appointments_string += "\nDescription: ".blue.bold + "#{ appointment.Description }".blue if appointment.Description != nil
    appointments_string
  end

  def get_record_subject()
    printn "Okay, what's the subject?"
    subject = gets
    subject.rstrip # Махане на новия ред
  end

  def get_record_start_date()
    printn "When is it?"
    start_date = recognize_date(gets)
    while !start_date
      printn "Sorry, but this is invalid date for me.\nTry again"
      start_date = recognize_date(gets)
    end
    start_date
  end

  def get_record_end_date(start_date)
    printn "How long is it in hours?"
    value = gets
    start_date + (value.to_f * 3600) # 3600 = 60х60 (от секунди в часове)
  end

  def get_record_address()
    printn "Where is it?"
    address = gets
    address.rstrip # Махане на новия ред
  end

  def get_record_description()
    printn "Enter some description about it"
    description = gets
    description.rstrip # Махане на новия ред
  end

  def select_appointment()
    printn display_appointments(), "\nWhich one do you want to edit?"

    words = Actions.new.edit_words
    input_words = gets.squeeze(' ').rstrip.lstrip.split(' ').reject { |word| words.include? word }
    selected_appointment = nil

    user_appointments = Records.Appointments.select { |app| app.UserId == $current_user.Id }.sort { |x, y| x.StartDate <=> y.StartDate }
    user_appointments.each_with_index do |appointment, index|
      if (input_words.include? (index + 1).ordinalize and input_words.size > 0 and input_words.size < 4)
        selected_appointment = appointment
      end
    end

    if !selected_appointment
      printn "I'm sorry but I can't find such appointment"
      return
    end

    selected_appointment
  end
end