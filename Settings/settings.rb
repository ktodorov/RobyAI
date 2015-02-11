class Settings
  
  # ActiveRecord настройки към базата
  gem 'activerecord-sqlserver-adapter', '~> 4.1.0'

  require 'active_record'
  require 'active_support/core_ext/integer/inflections'

  ActiveRecord::Base.pluralize_table_names = false
  ActiveRecord::Base.default_timezone = :local
  ActiveRecord::Base.time_zone_aware_attributes = false

  ActiveRecord::Base.establish_connection(
      :adapter => "sqlserver",
      :host => "HOME-PC",
      :database => "RobyAI",
      :username => "sa1",
      :password => "sa"
  )
end