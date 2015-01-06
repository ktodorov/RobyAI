class Recognize
  def Recognize.check_answer(answer)
  	answer = answer.squeeze(' ').lstrip.rstrip.downcase
    if answer.eql? "yes"
    	true
    else
    	false
    end
  end
end