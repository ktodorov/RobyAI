require_relative 'Actions/add.rb'
require_relative 'Actions/delete.rb'
require_relative 'Actions/show.rb'
require_relative '../Entities/users.rb'
require_relative '../Entities/special_words.rb'
require_relative '../Entities/operations.rb'
require_relative '../Entities/actions.rb'
require_relative '../IO/roby_io.rb'

require 'date'
require 'time'

module Recognize
  include Entities
  include ActionsModule
  include RobyIO

  def check_answer(answer)
    answer = remove_meaningless_chars(answer)
    return true if PositiveWords.values.include? answer

    return false if NegativeWords.values.include? answer
    
    nil
  end

  def recognize_word(word)
    if word.starts_with? "time" and word.length < "time".length + 3
      return "time"
    elsif word.starts_with? "date" and word.length < "date".length + 3
      return "date"
    elsif word.starts_with? "appointment" and word.length < "appointment".length + 3
      return "appointment"
    end
  end

  def recognize_date(word)
    begin
      Time.parse(word)
    rescue ArgumentError # Вдига се при невалидна дата ("tommorow", "yesterday" и др.)
      word = remove_meaningless_chars(word)
      if word.eql? 'tommorow'
        return Time.parse (Date.today + 1).to_s
      elsif word.eql? 'yesterday'
        return Time.parse (Date.today - 1).to_s
      else
        false
      end
    end
  end
  
  def recognize_input(input)
    # От резултата от тази функция зависи как ще продължи програмата:
    # При false - не е интерпретиран успешно входа на потребителя
    # При true  - успешно интерпретиран и изпълнена съответната операция
    # При nil   - потребителят е изявил желание да напусне програмата
    input = remove_meaningless_chars(input)
    
    recognized = check_action(input)
    recognized
  end

  def remove_meaningless_chars(input)
    AbbreviationWords.each { |constant_key, constant_value| input.gsub!(constant_key, constant_value) }

    MeaninglessSymbols.values.each do |value|
      input.gsub!(value, " ")
    end

    # Първо взимаме изразите "без значение" (тези от записите, които съдържат в себе си интервал)
    # Това се прави с цел да се предотврати евентуално премахване на "me" преди "to me",
    # защото тогава "to" ще остане в изречението и няма да бъде изчистено
    meaningless_double_words = MeaninglessWords.all.values.select { |word| word.include? ' ' }
    meaningless_double_words.each do |word|
      input.gsub!(word, " ")
    end

    meaningless_words = MeaninglessWords.all.values.select { |word| !word.include? ' ' }
    input_split = input.split(' ')

    input_split.reject! { |word| meaningless_words.include? word }
    input = input_split.join(' ').squeeze(' ').lstrip.rstrip.downcase
    input
  end

  private
  
  def check_action(input)
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
    when "add"
      recognized = AddAction.parse(input)
    when "delete"
      recognized = DeleteAction.parse(input)
    when "exit"
      return nil
    else
      recognized = try_to_recognize(input)
    end
    recognized
  end

  def try_to_recognize(input)
    recognized = ShowAction.parse(input)
    recognized = AddAction.parse(input) if recognized == false
    recognized = DeleteAction.parse(input) if recognized == false
    recognized
  end

end