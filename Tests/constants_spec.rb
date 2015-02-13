require_relative "../Constants/constants.rb"

class DummyInheritableClass < Constants
end

describe Constants do
  before :each do
    @dummy = DummyInheritableClass
  end

  it "can add items" do
    @dummy.add_item("key", "value")
    expect(@dummy.all).to be_a Hash
    expect(@dummy.all).not_to be_empty
  end
  it "returns the keys" do
    @dummy.add_item("key", "value")
    expect(@dummy.keys.count).to eql 1
    expect(@dummy.keys[0]).to eql "key"
  end
  it "returns the values" do
    @dummy.add_item("key", "value")
    expect(@dummy.values.count).to eql 1
    expect(@dummy.values[0]).to eql "value"
  end
  it "works with the [] operator" do
    @dummy.add_item("key", "value")
    expect(@dummy["key"]).to eql "value"
  end
end