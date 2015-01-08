module ActionsModule
  class Show
    include Entities
    extend RobyIO
    
    def Show.parse(input)
      words = Actions.show_words
      # Show me the time
      #time = Time.new
      #printn "#{ time.hour }:#{ time.min }:#{ time.sec }"
    end
  end
end