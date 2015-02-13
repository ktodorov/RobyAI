require_relative '../../Entities/actions.rb'
require_relative '../../Entities/special_words.rb'
require_relative '../../IO/roby_io.rb'
require_relative 'common.rb'

module ActionsModule
  module DeleteAction
    include Entities
    include RobyIO

    def DeleteAction.parse(input)
      words = Actions.new.delete_words
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

    def self.delete_appointment()
      printn "Okay", display_appointments(), "\nWhich one?"

      input = gets
      words = Actions.new.delete_words
      input_words = input.squeeze(' ').rstrip.lstrip.split(' ')
      input_words.reject! { |word| words.include? word }

      user_appointments = Records.Appointments.select { |app| app.UserId == $current_user.Id }.sort { |x, y| x.StartDate <=> y.StartDate }
      user_appointments.each_with_index do |appointment, index|
        if (input_words.include? (index + 1).ordinalize and input_words.size > 0 and input_words.size < 4)
          printn "Are you sure you want to delete the #{ (index + 1).ordinalize } appointment in the list?"
          if check_answer(gets)
            appointment.destroy
            printn "The appointment was deleted"
          else
            printn "Okay then"
            return true
          end
        end
      end
    end

    # Специфични функции
    private 
    
    def self.recognize_word_and_display(word)
      case recognize_word(word)
      when "appointment"
        delete_appointment()
      else
        false
      end
    end

    def self.recognize_two_words_and_display(first_word, second_word, should_recognize_deeper = true)
      recognized_word = recognize_word(first_word).to_s + recognize_word(second_word).to_s
      case recognized_word
      when "appointment"
        printn "You can only delete one appointment at a time.", "Let's start with it, shall we?"
        delete_appointment()
      else
        return false if !should_recognize_deeper
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
            recognized_now = recognize_two_words_and_display(word, second_word, false)
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
        printn "I did not understand.", "What do you want to delete?"
        return false
      end
      recognized
    end
  end
end