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

    def Phrases.Sentences
      Phrases.where({ TypeId: 3 })
    end

    def self.get_answer(question_id)
      answers = {}
      Phrases.Answers.each do |answer|
        answers[answer.ParentId] = [] if !answers.has_key? answer.ParentId
        answers[answer.ParentId] << answer.Text
      end

      return nil if !answers.has_key? question_id
      answers[question_id].sample
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