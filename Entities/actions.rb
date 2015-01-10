# Actions не са свързани с базата данни

module Entities
  class Actions
    # Целта е действията да се създадат като хеш,
    # който съдържа различните действия, 
    # обединени в масиви според значението им като ключове
    # и при среща на дадена дума, стойността,
    # която е число се увеличава според логиката
    def initialize()
      @actions = {
        # Показвам
        ["show",
         "display",
         "present",
         "give"] => 0,
  
        # Казвам
        ["tell",
         "say"] => 0,
  
        # Добавям
        ["add",
         "put",
         "insert"] => 0,
  
        # Изтривам
        ["delete",
         "erase",
         "wipe"] => 0,
  
        # Излизам
        ["exit",
         "goodbye",
         "bye"] => 0
      }
    end

    def all()
      @actions
    end

    def show_words()
      @actions.keys[0]
    end

    def tell_words()
      @actions.keys[1]
    end

    def add_words()
      @actions.keys[2]
    end

    def delete_words()
      @actions.keys[3]
    end

    def exit_words()
      @actions.keys[4]
    end
  end
end