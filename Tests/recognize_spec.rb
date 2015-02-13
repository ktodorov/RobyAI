require_relative '../Settings/local_settings.rb'
require_relative '../Interpret/recognize.rb'

require 'active_support/core_ext/kernel/reporting'
require 'rspec/mocks'

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

  describe "answers" do
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

  describe "important_sentences" do
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

  describe "word_recognizing" do
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

  describe "date_recognizing" do
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
end