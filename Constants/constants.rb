class Constants
  def Constants.add_item(key,value)
  	@CONSTANTS ||= {}
    @CONSTANTS[key] = value
  end

  def Constants.const_missing(key)
    @CONSTANTS[key]
  end

  def Constants.all()
    @CONSTANTS
  end

  def Constants.each
    @CONSTANTS.each { |key,value| yield(key,value) }
  end

  def Constants.values
    @CONSTANTS.values || []
  end

  def Constants.keys
    @CONSTANTS.keys || []
  end

  def Constants.[](key)
    @CONSTANTS[key]
  end
end