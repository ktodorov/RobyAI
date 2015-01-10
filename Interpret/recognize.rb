class Recognize
  include Entities
  include ActionsModule

  def Recognize.check_answer(answer)
    answer = remove_meaningless_chars(answer)
    return true if PositiveWords.values.include? answer

    return false if NegativeWords.values.include? answer
    
    nil
  end
  
  def Recognize.recognize_input(input)
    input = remove_meaningless_chars(input)
    
    check_action(input)
  end

  def self.remove_meaningless_chars(input)
    AbbreviationWords.each { |constant_key, constant_value| input.gsub!(constant_key, constant_value) }

    MeaninglessWords.values.each do |value|
      input.gsub!(" #{ value } ", " ")
    end

    MeaninglessSymbols.values.each do |value|
      input.gsub!(value, " ")
    end

    input = input.squeeze(' ').lstrip.rstrip.downcase
    
    input
  end
  
  def self.check_action(input)
    actions = Actions.new.all
    
    first_words = input.split(' ')[0..2]
    first_words.each_with_index do |word, index|
      # Тук целта е такава:
      # Ако срещнем дума, която е действие увеличаваме брояча и
      # Важно е, обаче, позицията на която е тази дума
      # Считаме, че ако е най-отпред, значи е "най-важна"
      match = actions.detect { |key, value| key.include? word }
      actions[match[0]] += (3 / (index + 1)) * 1 if match != nil
    end

    non_zero_actions = actions.select { |key, value| value > 0 }
    action = non_zero_actions.max_by { |key, value| value }[0].first if !non_zero_actions.empty?
    case action
    when "show"
      Show.parse(input)
    when "tell"
      nil
    when "add"
      nil
    when "delete"
      nil
    when "exit"
      return nil
    else
      printn "Sorry, I could not understand.", "Try again..."
    end
  end

end