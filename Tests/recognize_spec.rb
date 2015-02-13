require_relative '../Settings/local_settings.rb'
require_relative '../Interpret/recognize.rb'

class DummyClass
end

describe Recognize do
  before :all do
    @dummy = DummyClass.new
    @dummy.extend Recognize
  end

  after :all do
    $current_user = nil
  end

  after :each do
    test_string = nil
  end

  describe "check_answer" do
    it "returns true for 'yes'" do
      expect(@dummy.check_answer("yes")).to be true
    end
    it "returns false for 'no'" do
      expect(@dummy.check_answer("no")).to be false
    end
    it "returns nil for 'test'" do
      expect(@dummy.check_answer("test")).to be nil
    end
  end

  describe "is_important" do
    it "returns true for 'who are you?'" do
      expect(@dummy.is_important("who are you?")).to be true
    end

    it "returns false for 'blabla'" do
      expect(@dummy.is_important("blabla")).to be false
    end

    it "is not true for 'to test or not to test?'" do
      expect(@dummy.is_important("to test or not to test?")).to_not be true
    end

    it "is false for 'i am not user-test' when user-test is not the current user" do
      $current_user = Users.where({ Username: 'test_user' }).first
      expect(@dummy.is_important("i am not user-test")).to be false
    end
  end

  describe "recognize_word" do
    it "returns 'time' for 'time'" do
      expect(@dummy.recognize_word("time")).to eql("time")
    end
    it "doesn't return 'time' for 'trime'" do
      expect(@dummy.recognize_word("trime")).to_not eql("time")
    end

    it "returns 'date' for 'date'" do
      expect(@dummy.recognize_word("date")).to eql("date")
    end
    it "doesn't return 'date' for 'drate'" do
      expect(@dummy.recognize_word("drate")).to_not eql("date")
    end

    it "returns 'appointment' for 'appointment'" do
      expect(@dummy.recognize_word("appointment")).to eql("appointment")
    end
    it "doesn't return 'appointment' for 'approintment'" do
      expect(@dummy.recognize_word("approintment")).to_not eql("appointment")
    end

    it "returns 'joke' for 'joke'" do
      expect(@dummy.recognize_word("joke")).to eql("joke")
    end
    it "doesn't return 'joke' for 'hajoke'" do
      expect(@dummy.recognize_word("hajoke")).to_not eql("joke")
    end

    it "returns 'joke' for 'funny'" do
      expect(@dummy.recognize_word("funny")).to eql("joke")
    end
    it "doesn't return 'joke' for 'hafunny'" do
      expect(@dummy.recognize_word("hafunny")).to_not eql("joke")
    end
  end

  describe "recognize_date" do
    it "returns Time variable for '15/5/2015'" do
      expect(@dummy.recognize_date("15/5/2015")).to be_a(Time)
    end
    it "returns current time for Time.now.to_s" do
      expect(@dummy.recognize_date(Time.now.to_s).strftime "%d/%m/%Y %H:%M").to eq(Time.now.strftime "%d/%m/%Y %H:%M")
    end
    it "returns next day for 'tommorow'" do
      expect(@dummy.recognize_date("tommorow")).to eq(Time.parse (Date.today + 1).to_s)
    end
    it "returns previous day for 'yesterday'" do
      expect(@dummy.recognize_date("yesterday")).to eq(Time.parse (Date.today - 1).to_s)
    end
    it "returns false for 'blahblah'" do
      expect(@dummy.recognize_date("blahblah")).to be false
    end
  end

  describe "recognize_sentence" do
    it "returns false for 'test sentence'" do
      expect(@dummy.recognize_sentence('test sentence', 'test sentence')).to be false
    end
    it "does not return true for 'i am test_user' if test_user is the current user" do
      $current_user = Users.where({ Username: 'test_user' })
      expect(@dummy.recognize_sentence('i am', 'i am test_user')).to_not be true
    end
    it "raises ArgumentError if only input given" do
      expect { @dummy.recognize_sentence('i am not test_user') }.to raise_error(ArgumentError)
    end
  end

  describe 'remove_meaningless_chars' do
    it "leaves show, delete, edit, exit, tell, display intact as key words" do
      expect(@dummy.remove_meaningless_chars('show, delete, edit, exit, tell, display')).to eql('show delete edit exit tell display')
    end
    it "does not remove the key words in full sentence" do
      test_string = "show me this and that, and of course - you must exit after that but first, tell and edit all which is on the display"
      expect(@dummy.remove_meaningless_chars(test_string)).to include ('show')
      expect(@dummy.remove_meaningless_chars(test_string)).to include ('exit')
      expect(@dummy.remove_meaningless_chars(test_string)).to include ('tell')
      expect(@dummy.remove_meaningless_chars(test_string)).to include ('edit')
      expect(@dummy.remove_meaningless_chars(test_string)).to include ('display')
    end
    it "removes meaningless words and symbols" do
      first_ten_meaningless = MeaninglessSymbols.values[0.. 10]
      expect(@dummy.remove_meaningless_chars(first_ten_meaningless.join(' '))).to be_empty
    end
    it "removes abbreviation words" do
      test_string = "i'm really strange and would've eaten that"
      expect(@dummy.remove_meaningless_chars(test_string)).to_not include("'m")
      expect(@dummy.remove_meaningless_chars(test_string)).to_not include("i am")
      expect(@dummy.remove_meaningless_chars(test_string)).to_not include("'ve")
    end
  end

  describe 'find_most_called_action' do
    it "returns nil for sentence without key words" do
      expect(@dummy.find_most_called_action('test')).to be nil
    end
    it "returns the key word correctly" do
      expect(@dummy.find_most_called_action('show me everything about me, noooow!')).to eql("show")
    end
    it "returns the most matched key word" do
      test_string = 'tell me - show me edit me show me edit me like one of your french girls'
      expect(@dummy.find_most_called_action(test_string)).to eql("show")
    end
    it "returns exit for 'goodbye' in the sentence" do
      test_string = 'i want you to leave when i write goodbye okay?!'
      expect(@dummy.find_most_called_action(test_string)).to eql("exit")
    end
  end
end