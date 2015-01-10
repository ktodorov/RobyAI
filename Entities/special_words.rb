module Entities
  class SpecialWords < ActiveRecord::Base
    self.table_name = "dbo.SpecialWords"
    self.primary_key = "Id"
    has_one :SpecialWordsType, :foreign_key => :Id, :primary_key => :TypeId

    # Different types of SpecialWords
    def SpecialWords.Meaningless
      SpecialWords.where({ TypeId: 1 })
    end

    def SpecialWords.Abbreviation
      SpecialWords.where({ TypeId: 2 })
    end

    def SpecialWords.Question
      SpecialWords.where({ TypeId: 3 })
    end

    def SpecialWords.Positive
      SpecialWords.where({ TypeId: 4 })
    end

    def SpecialWords.Negative
      SpecialWords.where({ TypeId: 5 })
    end

    def SpecialWords.MeaninglessSymbols
      SpecialWords.where({ TypeId: 6 })
    end
  end

  # Sub-entities of SpecialWords
  class MeaninglessWords < Constants
    SpecialWords.Meaningless.each do |object|
      if object.Meaning == nil
        MeaninglessWords.add_item object.Word.to_sym, object.Word
      else
        MeaninglessWords.add_item object.Word, object.Meaning
      end
    end
  end

  class AbbreviationWords < Constants
    SpecialWords.Abbreviation.each do |object|
      if object.Meaning == nil
        AbbreviationWords.add_item object.Word.to_sym, object.Word
      else
        AbbreviationWords.add_item object.Word, object.Meaning
      end
    end
  end

  class QuestionWords < Constants
    SpecialWords.Question.each do |object|
      if object.Meaning == nil
        QuestionWords.add_item object.Word.to_sym, object.Word
      else
        QuestionWords.add_item object.Word, object.Meaning
      end
    end
  end

  class PositiveWords < Constants
    SpecialWords.Positive.each do |object|
      if object.Meaning == nil
        PositiveWords.add_item object.Word.to_sym, object.Word
      else
        PositiveWords.add_item object.Word, object.Meaning
      end
    end
  end

  class NegativeWords < Constants
    SpecialWords.Negative.each do |object|
      if object.Meaning == nil
        NegativeWords.add_item object.Word.to_sym, object.Word
      else
        NegativeWords.add_item object.Word, object.Meaning
      end
    end
  end

  class MeaninglessSymbols < Constants
    SpecialWords.MeaninglessSymbols.each do |object|
      if object.Meaning == nil
        MeaninglessSymbols.add_item object.Word.to_sym, object.Word
      else
        MeaninglessSymbols.add_item object.Word, object.Meaning
      end
    end
  end

  # The type of the SpecialWord
  # The Id is related to TypeId of SpecialWords table
  class SpecialWordsType < ActiveRecord::Base
    self.table_name = "dbo.SpecialWordsType"
    self.primary_key = "Id"
    belongs_to :SpecialWords, :foreign_key => :Id, :primary_key => :TypeId
  end
end