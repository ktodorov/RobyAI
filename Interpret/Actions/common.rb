module CommonActions
  def display_current_time()
    time = Time.new
    "#{ time.hour }:#{ time.min }:#{ time.sec }"
  end

  def display_current_date()
    date = Time.new
    "#{ date.day }/#{ date.month }/#{ date.year }"
  end
end