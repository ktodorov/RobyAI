require_relative "../Interpret/listen.rb"
require_relative '../Settings/local_settings.rb'
require_relative '../Interpret/recognize.rb'

class DummyClass
end

describe Listen do
  before :all do
    @dummy = DummyClass.new
    @dummy.extend Listen
    @dummy.extend Recognize
  end

  describe "Leaves" do
    it "returns nil when goodbye" do
      allow(@dummy).to receive(:gets) { "Goodbye" }
      expect(@dummy.start_listening).to eql(nil)
    end
  end
end