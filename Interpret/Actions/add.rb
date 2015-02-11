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

    # Специфични функции
    private 
    
    def self.recognize_word_and_display(word)
      case recognize_word(word)
      when "appointment"
        create_appointment()
      else
        false
      end
    end

    def self.recognize_two_words_and_display(first_word, second_word)
      recognized_word = recognize_word(first_word).to_s + recognize_word(second_word).to_s
      case recognized_word
      when "datetime", "timedate"
        #printn "It is now #{ display_date_time() }"
      else
        recognized   = recognize_word_and_display(first_word)
        recognized ||= recognize_word_and_display(second_word)
        recognized
      end
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
        printn "I did not understand.\nWhat do you want to add?"
        input = Recognize.remove_meaningless_chars(gets)
        recognized = AddAction.parse(input)
      end

      recognized
    end

    def self.create_appointment(subject: nil, start_date: nil,
                                end_date: nil, description: nil, address: nil)
      if !subject
        printn "Okay, what's the subject?"
        subject = gets
        subject = subject.rstrip # Махане на новия ред
      end
      if !start_date
        printn "When is it?"
        start_date = recognize_date(gets)
        while !start_date
          printn "Sorry, but this is invalid date for me.\nTry again"
          start_date = recognize_date(gets)
        end
      end
      if end_date == true
        printn "How long is it in hours?"
        value = gets
        end_date = start_date + (value.to_f * 3600) # 3600 = 60х60 (от секунди в часове)
      end
      if address == true
        printn "Where is it?"
        address = gets
        address = address.rstrip # Махане на новия ред
      end
      if description == true
        printn "Enter some description about it"
        description = gets
        description = description.rstrip # Махане на новия ред
      end
      printn "Okay, here's what I got:"

      appointment_info =  "#{ subject }\n".blue.bold
      appointment_info += "from #{ display_date_time(start_date) }\n".blue
      appointment_info += "to   #{ display_date_time(end_date) }\n".blue if end_date
      appointment_info += "at   #{ address }\n".blue if address
      appointment_info += "Description: ".blue.bold + "#{ description }".blue if description
      printn appointment_info
      printn "Should I save it?\nYou can add duration, address or description for the event."
      
      exit_words = Actions.new.exit_words

      input = remove_meaningless_chars(gets)
      if check_answer(input) or input.include? 'save' and input.length <= 16 # "save appointment"
        record_type_id = 1
        add_appointment(subject, start_date, end_date, description, address, record_type_id)
        printn "I created it!\n#{ display_appointments() }"
        return true
      elsif exit_words.any? { |exit_word| input.include? exit_word} and input.length < 10
        return true
      end
      address = true if input.include? 'address'
      description = true if input.include? 'description'
      end_date = true if input.include? 'duration'
      create_appointment(subject: subject, start_date: start_date, end_date: end_date, description: description, address: address)
    end
  end
end