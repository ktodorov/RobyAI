# Settings
load 'settings.rb'

# Constants
load 'Constants/constants.rb'
load 'Constants/special_words.rb'

# Entities
load 'Entities/users.rb'
load 'Entities/operations.rb'

# Interpretation
load 'Interpret/recognize.rb'
load 'Interpret/greet.rb'

# Main
Greet.greet()