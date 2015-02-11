require_relative '../../Entities/records.rb'
require_relative '../../IO/roby_io.rb'

module ActionsModule
  def display_time(time = nil)
    
    return "It is now #{ Time.new.strftime "%H:%M" }" if !time
    time.strftime "%H:%M"
  end

  def display_date(date = nil)
    "Today is #{ Time.new.strftime "%d/%m/%Y" }" if !date
    date.strftime "%d/%m/%Y"
  end

  def display_date_time(datetime = nil)
    "It is now #{ Time.new.strftime "%d/%m/%Y %H:%M" }" if !datetime
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
end