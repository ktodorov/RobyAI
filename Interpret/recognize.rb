class Recognize
  def Recognize.check_answer(answer)
  	answer = remove_meaningless_chars(answer)
    return true if PositiveWords.values.include? answer
    	
    return false if NegativeWords.values.include? answer
    
    nil
  end

  def self.remove_meaningless_chars(input)
    AbbreviationWords.each { |constant_key, constant_value| input.gsub!(constant_key, constant_value) }

  	MeaninglessWords.values.each do |value|
      input.gsub!(value, " ")
    end

    input = input.squeeze(' ').lstrip.rstrip.downcase
    
    input
  end

end