require_relative '../../Entities/actions.rb'
require_relative '../../Entities/special_words.rb'
require_relative '../../Entities/phrases.rb'
require_relative '../../IO/roby_io.rb'
require_relative 'common.rb'

module ActionsModule
  module ShowAction
    include Entities
    include RobyIO

    def ShowAction.parse(input)
      words = Actions.new.show_words
      question_words = QuestionWords.all.values

      input_words = input.squeeze(' ').rstrip.lstrip.split(' ')
      input_words.reject! { |word| words.include? word or question_words.include? word }

      if input_words.size == 1
        recognized = recognize_word_and_display(input_words[0])
      elsif input_words.size == 2
        recognized = recognize_two_words_and_display(input_words[0], input_words[1])
      else
        recognized = try_to_recognize(input_words)
      end
      recognized
    end

    # Специфични функции
    private 
    
    def self.recognize_word_and_display(word)
      case recognize_word(word)
      when "time"
        printn "It is now #{ display_time() }"
      when "date"
        printn "Today is #{ display_date() }"
      when "appointment"
        printn display_appointments()
      when "joke"
        printn Jokes.get_one
      else
        return false
      end
      true
    end

    def self.recognize_two_words_and_display(first_word, second_word)
      recognized_word = recognize_word(first_word).to_s + recognize_word(second_word).to_s
      case recognized_word
      when "datetime", "timedate"
        printn "It is now #{ display_date_time() }"
      else
        recognized   = recognize_word_and_display(first_word)
        recognized ||= recognize_word_and_display(second_word)
        return recognized
      end
      true
    end

    def self.try_to_recognize(words)
      recognized = false
      recognized_words = []

      # Обикаляме думите по двойки: 1 с 2, 1 с 3 и така до 1 с n
      # След това продължаваме с 2 с 3, 2 с 4 и т.н.
      # Ако успеем да разпознаем дадена двойка думи, отбелязваме думите така че да не повторим същите.
      # Отбелязваме и че сме разпознали нещо за да не изведем съобщение за грешка
      words.each_with_index do |word, index|
        words.drop(index + 1).each do |second_word|
          if !recognized_words.include? word and !recognized_words.include? second_word
            # Ако веднъж сме разпознали нещо, не трябва да променяме променливата при следващо неуспешно разпознаване
            recognized_now = recognize_two_words_and_display(word, second_word)
            recognized ||= recognized_now
            recognized_words << word << second_word if recognized_now
          end
        end
      end

      # Тук обикаляме думите, които не са били разпознати в миналото итериране
      # Ако успеем да разпознаем някоя, я добавяме към разпознатите за да не я повторим
      words.each do |word|
        if !recognized_words.include? word
          recognized_now = recognize_word_and_display(word)
          recognized_words << word if recognized_now
          recognized ||= recognized_now
        end
      end

      if not recognized
        printn "I did not understand.\nWhat do you want me to show you?"
        input = Recognize.remove_meaningless_chars(gets)
        recognized = ShowAction.parse(input)
      end

      recognized
    end
  end
end