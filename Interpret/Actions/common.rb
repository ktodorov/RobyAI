require_relative '../../Entities/records.rb'

module ActionsModule
  def display_time(time = Time.new)
    "#{ time.hour }:#{ time.min }:#{ time.sec }"
  end

  def display_date(date = Time.new)
    "#{ date.day }/#{ date.month }/#{ date.year }"
  end

  def display_date_time(datetime = Time.new)
    "#{ datetime.day }/#{ datetime.month }/#{ datetime.year }, #{ datetime.hour }:#{ datetime.min }:#{ datetime.sec }"
  end

  def appointments()
  	user_appointments = Records.Appointments.select { |app| app.UserId == $current_user_id }.sort { |x, y| x.StartDate <=> y.StartDate }
  	appointments_string = ""
  	user_appointments.each do |appointment|
  		appointments_string += "\n\n" if !appointments_string.empty?
  		appointments_string += "#{ appointment.Subject }\n"
  		appointments_string += "from #{ display_date_time(appointment.StartDate) } to #{ display_date_time(appointment.EndDate) }\n" if appointment.StartDate != nil
  		appointments_string += "at #{ appointment.Address }\n" if appointment.Address != nil
  		appointments_string += "Description: #{ appointment.Description }" if appointment.Description != nil
  	end

  	appointments_string
  end
end