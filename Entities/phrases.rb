require_relative '../Settings/local_settings.rb'

module Entities
  class Phrases < ActiveRecord::Base
    self.table_name = "dbo.Phrases"
    self.primary_key = "Id"
    has_one :PhrasesType, :foreign_key => :Id, :primary_key => :TypeId

    # Different types of Phrases
    def Phrases.Questions
      Phrases.where({ TypeId: 1 })
    end

    def Phrases.Answers
      Phrases.where({ TypeId: 2 })
    end
  end

  # Jokes are sub-entities of Phrases
  class Jokes
    @jokes = []
    Phrases.Answers.where({ ParentId: 4 }).each do |joke|
      @jokes << joke.Text
    end

    def self.get_one()
      @jokes.sample
    end
  end

  # The type of the Phrase
  # The Id is related to TypeId of Phrases table
  class PhrasesType < ActiveRecord::Base
    self.table_name = "dbo.PhrasesType"
    self.primary_key = "Id"
    belongs_to :Phrases, :foreign_key => :Id, :primary_key => :TypeId
  end
end