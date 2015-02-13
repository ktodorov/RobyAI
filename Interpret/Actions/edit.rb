require_relative '../../Entities/actions.rb'
require_relative '../../Entities/special_words.rb'
require_relative '../../Entities/phrases.rb'
require_relative '../../IO/roby_io.rb'
require_relative 'common.rb'

module ActionsModule
  module EditAction
    include Entities
    include RobyIO

    def EditAction.parse(input)
      words = Actions.new.edit_words
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

    def self.edit_appointment(edit_appointment: nil, subject: nil, start_date: nil,
                         end_date: nil, address: nil, description: nil)
      edit_appointment = select_appointment if !edit_appointment
      return if !edit_appointment

      edit_appointment.Subject = get_record_subject() if subject

      if start_date
        duration = (edit_appointment.EndDate - edit_appointment.StartDate) if edit_appointment.EndDate
        start_date = get_record_start_date()
        edit_appointment.StartDate = start_date
        edit_appointment.EndDate = start_date + duration if duration
      end
      
      edit_appointment.EndDate = get_record_end_date() if end_date
      edit_appointment.Address = get_record_address() if address
      edit_appointment.Description = get_record_description() if description

      printn "Okay, here's what I got:", appointment_to_s(edit_appointment)
      printn "What do you want to edit?", "You can change the subject, start date, duration, description and address"
      printn "You can also save it the way it is at the moment"
      
      exit_words = Actions.new.exit_words

      # Проверяваме дали потребителя иска да запише, да редактира допълнително или да излезе
      input = remove_meaningless_chars(gets)
      if check_answer(input) or input.include? 'save' and input.length <= 16 # "save appointment"
        edit_appointment.save
        printn "I saved it!\n#{ display_appointments() }"
        return true
      elsif exit_words.any? { |exit_word| input.include? exit_word} and input.length < 10
        return true
      end
      subject = input.include? 'subject'
      start_date = input.include? 'start date'
      address = input.include? 'address'
      description = input.include? 'description'
      end_date = input.include? 'duration'
      edit_appointment(edit_appointment: edit_appointment, subject: subject, start_date: start_date, end_date: end_date, description: description, address: address)
    end

    # Специфични функции
    private 
    
    def self.recognize_word_and_display(word)
      case recognize_word(word)
      when "appointment"
        edit_appointment()
      else
        return false
      end
      true
    end

    def self.recognize_two_words_and_display(first_word, second_word, should_recognize_deeper = true)
      recognized_word = recognize_word(first_word).to_s + recognize_word(second_word).to_s
      case recognized_word
      when "appointment"
        printn "You can only edit one appointment at a time.", "Let's start with it, shall we?"
        edit_appointment()
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
        printn "I did not understand.\nWhat do you want to edit?"
        return false
      end
      recognized
    end
  end
end