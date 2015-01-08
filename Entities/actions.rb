# Actions не са свързани с базата данни

module Entities
  class Actions
    # Целта е действията да се създадат като хеш,
    # който съдържа различните действия, 
    # обединени в масиви според значението им като ключове
    # и при среща на дадена дума, стойността,
    # която е число се увеличава според логиката
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
       "wipe"] => 0
    }

    def Actions.all()
      @actions
    end

    def Actions.show_words()
      @actions.keys[0]
    end

    def Actions.tell_words()
      @actions.keys[1]
    end

    def Actions.add_words()
      @actions.keys[2]
    end

    def Actions.delete_words()
      @actions.keys[3]
    end
  end
end