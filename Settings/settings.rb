class Settings
  
  # ActiveRecord настройки към базата
  gem 'activerecord-sqlserver-adapter', '~> 4.1.0'

  require 'active_record'

  ActiveRecord::Base.pluralize_table_names = false

  ActiveRecord::Base.establish_connection(
      :adapter => "sqlserver",
      :host => "HOME-PC",
      :database => "RobyAI",
      :username => "sa1",
      :password => "sa"
  )
end