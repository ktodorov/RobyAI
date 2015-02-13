require_relative "../Interpret/Actions/common.rb"
require_relative '../Interpret/recognize.rb'

require 'active_support/core_ext/kernel/reporting'

include ActionsModule

describe "CommonActions" do
  describe 'display_time' do
    it 'displays current time when given nil' do
      expect(display_time(nil)).to include(Time.now.strftime "%H:%M")
    end
    it 'displays given time' do
      expect(display_time(Time.new(2002))).to include(Time.new(2002).strftime "%H:%M")
    end
  end

  describe 'display_date' do
    it 'displays current date when given nil' do
      expect(display_date(nil)).to include(Time.now.strftime "%d/%m/%Y")
    end
    it 'displays given date' do
      expect(display_date(Time.new(2002))).to include(Time.new(2002).strftime "%d/%m/%Y")
    end
  end
  
  describe 'display_date_time' do
    it 'displays current date_time when given nil' do
      expect(display_date_time(nil)).to include(Time.now.strftime "%d/%m/%Y %H:%M")
    end
    it 'displays given date_time' do
      expect(display_date_time(Time.new(2002))).to include(Time.new(2002).strftime "%d/%m/%Y %H:%M")
    end
  end

  describe 'display_appointments' do
    after :each do
      $current_user = nil
    end
    it 'returns no appointments if the user does not have any' do
      $current_user = Users.new(Id: 0)
      expect(display_appointments.count("\n")).to be < 2 
    end
    it 'returns appointments if the user has any' do
      $current_user = Users.where({ Username: "test_user" }).first
      test_appointment = Records.create(Id: Records.all.last.Id + 1, Subject: "testing", UserId: $current_user.Id, RecordTypeId: 1)
      test_appointment.save
      expect(display_appointments).to include test_appointment.Subject
      expect(display_appointments.count("\n")).to be > 1
      test_appointment.destroy
    end
  end

  describe 'appointment_to_s' do
    it 'returns nil for nil appointment' do
      expect(appointment_to_s(nil)).to be nil
    end
    it 'returns string for appointment' do
      test_appointment = Records.Appointments.first
      expect(appointment_to_s(test_appointment)).to be_a String
    end
  end
end