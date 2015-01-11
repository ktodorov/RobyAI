module ActionsModule
  class ShowAction
    include Entities
    extend RobyIO
    
    def ShowAction.parse(input)
      words = Actions.new.show_words
      question_words = QuestionWords.all.values

      input_words = input.squeeze(' ').rstrip.lstrip.split(' ')
      input_words.reject! { |word| words.include? word or question_words.include? word }

      if input_words.empty?
        printn "Sorry, I did not understand", "Try again.."
        return true # Ако върнем nil, програмата ще мисли, че потребителят иска да излезе
      elsif input_words.size == 1
        recognized = recognize_word_and_display(input_words[0])
      elsif input_words.size == 2
        recognized = recognize_two_words_and_display(input_words[0], input_words[1])
      elsif input_words.size > 2
        recognized = try_to_recognize(input_words)
      end
      recognized
    end

    def self.recognize_word_and_display(word)
      case recognize_word(word)
      when "time"
        printn "It is now #{ display_current_time() }"
      when "date"
        printn "Today is #{ display_current_date() }"
      else
        false
      end
    end

    def self.recognize_two_words_and_display(first_word, second_word)
      recognized_word = recognize_word(first_word) + recognize_word(second_word)

      case recognized_word
      when "datetime", "timedate"
        printn "It is now #{ display_current_time() }, #{ display_current_date() }"
      else
        false
      end
    end

    def self.recognize_word(word)
      if word.starts_with? "time" and word.length < "time".length + 3
        return "time"
      elsif word.starts_with? "date" and word.length < "date".length + 3
        return "date"
      end
    end

    def self.display_current_time()
      time = Time.new
      "#{ time.hour }:#{ time.min }:#{ time.sec }"
    end

    def self.display_current_date()
      date = Time.new
      "#{ date.day }/#{ date.month }/#{ date.year }"
    end
  end
end