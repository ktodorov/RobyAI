# Settings
load 'Settings/local_settings.rb'

# Constants
load 'Constants/constants.rb'

# Entities
load 'Entities/users.rb'
load 'Entities/special_words.rb'
load 'Entities/operations.rb'
load 'Entities/actions.rb'

# IO Module
load 'IO/roby_io.rb'

# Actions
load 'Interpret/Actions/add.rb'
load 'Interpret/Actions/delete.rb'
load 'Interpret/Actions/show.rb'
load 'Interpret/Actions/tell.rb'

# Interpretation
load 'Interpret/recognize.rb'
load 'Interpret/listen.rb'
load 'Interpret/greet.rb'

# Main
Greet.greet()