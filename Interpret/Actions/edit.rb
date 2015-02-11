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

    def self.recognize_two_words_and_display(first_word, second_word)
      recognized_word = recognize_word(first_word).to_s + recognize_word(second_word).to_s
      case recognized_word
      when "datetime", "timedate"
        return false
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
        printn "I did not understand.\nWhat do you want to edit?"
        input = Recognize.remove_meaningless_chars(gets)
        recognized = EditAction.parse(input)
      end

      recognized
    end

    def self.edit_appointment(edit_appointment: nil, subject: nil, start_date: nil,
                         end_date: nil, address: nil, description: nil)
      if !edit_appointment
        printn display_appointments(), "\nWhich one do you want to edit?"

        input = gets
        words = Actions.new.edit_words
        input_words = input.squeeze(' ').rstrip.lstrip.split(' ')
        input_words.reject! { |word| words.include? word }
        edit_appointment = nil

        user_appointments = Records.Appointments.select { |app| app.UserId == $current_user.Id }.sort { |x, y| x.StartDate <=> y.StartDate }
        user_appointments.each_with_index do |appointment, index|
          if (input_words.include? (index + 1).ordinalize and input_words.size > 0 and input_words.size < 4)
            edit_appointment = appointment
          end
        end

        if !edit_appointment
          printn "I'm sorry but I can't find such appointment"
          return
        end
      end

      if subject == true
        printn "Okay, what's the new subject?"
        subject = gets
        subject = subject.rstrip # Махане на новия ред
        edit_appointment.Subject = subject
      end
      if start_date == true
        duration = (edit_appointment.EndDate - edit_appointment.StartDate) if edit_appointment.EndDate
        printn "When is it?"
        start_date = recognize_date(gets)
        while !start_date
          printn "Sorry, but this is invalid date for me.\nTry again"
          start_date = recognize_date(gets)
        end
        edit_appointment.StartDate = start_date
        edit_appointment.EndDate = start_date + duration if duration
      end
      if end_date == true
        printn "How long is it in hours?"
        value = gets
        end_date = start_date + (value.to_f * 3600) # 3600 = 60х60 (от секунди в часове)
        edit_appointment.EndDate = end_date
      end
      if address == true
        printn "Where is it?"
        address = gets
        address = address.rstrip # Махане на новия ред
        edit_appointment.Address = address
      end
      if description == true
        printn "Enter some description about it"
        description = gets
        description = description.rstrip # Махане на новия ред
        edit_appointment.Description = description
      end
      printn "Okay, here's what I got:", appointment_to_s(edit_appointment)
      printn "What do you want to edit?", "You can change the subject, start date, duration, description and address"
      printn "You can also save it the way it is at the moment"
      
      exit_words = Actions.new.exit_words

      input = remove_meaningless_chars(gets)
      if check_answer(input) or input.include? 'save' and input.length <= 16 # "save appointment"
        edit_appointment.save
        printn "I saved it!\n#{ display_appointments() }"
        return true
      elsif exit_words.any? { |exit_word| input.include? exit_word} and input.length < 10
        return true
      end
      subject = true if input.include? 'subject'
      start_date = true if input.include? 'start date'
      address = true if input.include? 'address'
      description = true if input.include? 'description'
      end_date = true if input.include? 'duration'
      edit_appointment(edit_appointment: edit_appointment, subject: subject, start_date: start_date, end_date: end_date, description: description, address: address)
    end
  end
end