module SpecialWords
  load 'constants.rb'

  class Meaningless_words < Constants
    Meaningless_words.add_item :please, "please"
    Meaningless_words.add_item :tell_me, "tell me"
    Meaningless_words.add_item :would_you, "would you"
    Meaningless_words.add_item :could_you, "could you"
    Meaningless_words.add_item :fullstop, "."
    Meaningless_words.add_item :dash, "-"
    Meaningless_words.add_item :colon, ":"
    Meaningless_words.add_item :semicolon, ";"
    Meaningless_words.add_item :comma, ","
    Meaningless_words.add_item :exclamation, "!"
    Meaningless_words.add_item :question, "?"
    # Meaningless_words.add_item :hello, "hello" !!!
  end

  class Abbreviation_words < Constants
    Abbreviation_words.add_item "'s", " is"
    Abbreviation_words.add_item "'ve'", " have"
  end

  class Question_words < Constants
    Question_words.add_item :how, "how"
    Question_words.add_item :when, "when"
    Question_words.add_item :where, "where"
    Question_words.add_item :why, "why"
  end

  class Positive_words < Constants
    Positive_words.add_item :yes, "yes"
    Positive_words.add_item :yeap, "yeap"
    Positive_words.add_item :yup, "yup"
    Positive_words.add_item :yeah, "yeah"
    Positive_words.add_item :ye, "ye"
    Positive_words.add_item :of_course, "of course"
  end

  class Negative_words < Constants
    Negative_words.add_item :no, "no"
    Negative_words.add_item :nope, "nope"
    Negative_words.add_item :nah, "nah"
    Negative_words.add_item :nay, "nay"
    Negative_words.add_item :noo, "noo"
    Negative_words.add_item :of_course_not, "of course not"
  end
end