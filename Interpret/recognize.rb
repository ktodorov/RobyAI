class Recognize
  include Entities
  include ActionsModule
  extend RobyIO

  def Recognize.check_answer(answer)
    answer = Recognize.remove_meaningless_chars(answer)
    return true if PositiveWords.values.include? answer

    return false if NegativeWords.values.include? answer
    
    nil
  end
  
  def Recognize.recognize_input(input)
    # От резултата от тази функция зависи как ще продължи програмата:
    # При false - не е интерпретиран успешно входа на потребителя
    # При true  - успешно интерпретиран и изпълнена съответната операция
    # При nil   - потребителят е изявил желание да напусне програмата
    input = Recognize.remove_meaningless_chars(input)
    
    recognized = check_action(input)
    recognized
  end

  def Recognize.remove_meaningless_chars(input)
    AbbreviationWords.each { |constant_key, constant_value| input.gsub!(constant_key, constant_value) }

    MeaninglessSymbols.values.each do |value|
      input.gsub!(value, " ")
    end

    meaningless_words = MeaninglessWords.all.values
    input_split = input.split(' ')

    input_split.reject! { |word| meaningless_words.include? word }
    input = input_split.join(' ').squeeze(' ').lstrip.rstrip.downcase
    input
  end
  
  def self.check_action(input)
    actions = Actions.new.all
    
    input_words = input.split(' ')
    input_words.each_with_index do |word, index|
      # Тук целта е такава:
      # Ако срещнем дума, която е действие увеличаваме брояча и
      # Важно е, обаче, позицията на която е тази дума
      # Считаме, че ако е най-отпред, значи е "най-важна"
      match = actions.detect { |key, value| key.include? word }
      actions[match[0]] += (input_words.size / (index + 1)) if match != nil
    end

    non_zero_actions = actions.select { |key, value| value > 0 }
    action = non_zero_actions.max_by { |key, value| value }[0].first if !non_zero_actions.empty?
    case action
    when "show"
      recognized = ShowAction.parse(input)
    when "tell"
      nil
    when "add"
      nil
    when "delete"
      nil
    when "exit"
      return nil
    else
      recognized = try_to_recognize(input)
      printn "Sorry, I could not understand.", "Try again..." if recognized == false
    end
    recognized
  end

  def self.try_to_recognize(input)
    recognized = ShowAction.parse(input)
    # recognized = TellAction.parse(input) if recognized == false
    # recognized = AddAction.parse(input) if recognized == false
    # recognized = DeleteAction.parse(input) if recognized == false
    recognized
  end

end