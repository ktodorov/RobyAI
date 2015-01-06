module SpecialWords
  class MeaninglessWords < Constants
    MeaninglessWords.add_item :please, "please"
    MeaninglessWords.add_item :tell_me, "tell me"
    MeaninglessWords.add_item :would_you, "would you"
    MeaninglessWords.add_item :could_you, "could you"
    MeaninglessWords.add_item :fullstop, "."
    MeaninglessWords.add_item :dash, "-"
    MeaninglessWords.add_item :colon, ":"
    MeaninglessWords.add_item :semicolon, ";"
    MeaninglessWords.add_item :comma, ","
    MeaninglessWords.add_item :exclamation, "!"
    MeaninglessWords.add_item :question, "?"
    # MeaninglessWords.add_item :hello, "hello" !!!
  end

  class AbbreviationWords < Constants
    AbbreviationWords.add_item "'s", " is"
    AbbreviationWords.add_item "'ve'", " have"
  end

  class QuestionWords < Constants
    QuestionWords.add_item :how, "how"
    QuestionWords.add_item :when, "when"
    QuestionWords.add_item :where, "where"
    QuestionWords.add_item :why, "why"
  end

  class PositiveWords < Constants
    PositiveWords.add_item :yes, "yes"
    PositiveWords.add_item :yeap, "yeap"
    PositiveWords.add_item :yup, "yup"
    PositiveWords.add_item :yeah, "yeah"
    PositiveWords.add_item :ye, "ye"
    PositiveWords.add_item :of_course, "of course"
  end

  class NegativeWords < Constants
    NegativeWords.add_item :no, "no"
    NegativeWords.add_item :nope, "nope"
    NegativeWords.add_item :nah, "nah"
    NegativeWords.add_item :nay, "nay"
    NegativeWords.add_item :noo, "noo"
    NegativeWords.add_item :of_course_not, "of course not"
  end
end