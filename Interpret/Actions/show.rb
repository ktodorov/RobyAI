module ActionsModule
  class Show
    include Entities
    extend RobyIO
    
    def Show.parse(input)
      words = Actions.new.show_words

      input_words = input.squeeze(' ').rstrip.lstrip.split(' ')
      input_words.reject! { |word| words.include? word }

      if input_words.empty?
        printn "Sorry, I did not understand", "Try again.."
      elsif input_words.size == 1
        recognize_word_and_display(input_words[0])
      elsif input_words.size == 2
        recognize_two_words_and_display(input_words[0], input_words[1])
      elsif input_words.size > 2
        try_to_recognize(input_words)
      end
    end

    def self.recognize_word_and_display(word)
      case recognize_word(word)
      when "time"
        printn "It is now #{ display_current_time() }"
      when "date"
        printn "Today is #{ display_current_date() }"
      end
    end

    def self.recognize_two_words_and_display(first_word, second_word)
      recognized_word = recognize_word(first_word) + recognize_word(second_word)

      case recognized_word
      when "datetime", "timedate"
        printn "It is now #{ display_current_time() }, #{ display_current_date() }"
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