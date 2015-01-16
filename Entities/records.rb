require_relative '../Settings/local_settings.rb'

module Entities
  class Records < ActiveRecord::Base
    self.table_name = "dbo.Records"
    self.primary_key = "Id"
    has_one :RecordsType, :foreign_key => :Id, :primary_key => :RecordTypeId

    # Different types of the Records
    def Records.Appointments
      Records.where({ RecordTypeId: 1 })
    end

    def Records.Reminders
      Records.where({ RecordTypeId: 2 })
    end
  end

  # The type of the Record
  # The Id is related to RecordTypeId of Records table
  class RecordsType < ActiveRecord::Base
    self.table_name = "dbo.RecordsType"
    self.primary_key = "Id"
    belongs_to :Records, :foreign_key => :Id, :primary_key => :RecordTypeId
  end
end