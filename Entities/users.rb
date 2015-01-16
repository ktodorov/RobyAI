require_relative '../Settings/local_settings.rb'

module Entities
  class Users < ActiveRecord::Base
    self.table_name = "dbo.Users"
    self.primary_key = "Id"
  end
end