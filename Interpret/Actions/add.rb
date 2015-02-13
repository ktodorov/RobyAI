require_relative '../../Entities/actions.rb'
require_relative '../../Entities/special_words.rb'
require_relative '../../IO/roby_io.rb'
require_relative 'common.rb'

module ActionsModule
  module AddAction
    include Entities
    include RobyIO

    def AddAction.parse(input)
      words = Actions.new.add_words
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

    def self.create_appointment(subject: nil, start_date: nil, end_date: nil, description: nil, address: nil)
      appointment_to_save = Records.new
      appointment_to_save.RecordTypeId = 1

      subject = get_record_subject() if !subject
      start_date = get_record_start_date() if !start_date
      
      end_date = get_record_end_date(start_date) if end_date == true
      address = get_record_address() if address == true
      description = get_record_description() if description == true

      appointment_to_save.Subject = subject
      appointment_to_save.StartDate = start_date
      appointment_to_save.EndDate = end_date if end_date
      appointment_to_save.Address = address if address
      appointment_to_save.Description = description if description

      printn "Okay, here's what I got:", appointment_to_s(appointment_to_save)
      printn "Should I save it?", "You can add duration, address or description for the event."
      
      exit_words = Actions.new.exit_words

      input = remove_meaningless_chars(gets)
      if check_answer(input) or input.include? 'save' and input.length <= 16 # "save appointment"
        record_type_id = 1
        add_appointment(subject, start_date, end_date, description, address, record_type_id)
        printn "I created it!\n#{ display_appointments() }"
        return true
      elsif exit_words.any? { |exit_word| input.include? exit_word} and input.length < 10 # "just exit"
        return true
      end

      address = true if input.include? 'address'
      description = true if input.include? 'description'
      end_date = true if input.include? 'duration'
      create_appointment(subject: subject, start_date: start_date, end_date: end_date, description: description, address: address)
    end

    # Специфични функции
    private 
    
    def self.recognize_word_and_display(word)
      case recognize_word(word)
      when "appointment"
        create_appointment()
      else
        return false
      end
      true
    end

    def self.recognize_two_words_and_display(first_word, second_word, should_recognize_deeper = true)
      recognized_word = recognize_word(first_word).to_s + recognize_word(second_word).to_s
      case recognized_word
      when nil
        nil
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

      return false if !recognized
      recognized
    end
  end
end