require_relative "../IO/roby_io.rb"

include RobyIO

describe RobyIO do
  describe "printn" do
  	it "outputs colorized text by default" do
  	  expect{ printn "testing" }.to output("\033[36mtesting\033[0m\n").to_stdout
    end

  	it "outputs bolded and colored text" do
  	  expect { printn "testing".bold, color: "black" }.to output("\033[30m\033[1mtesting\033[22m\033[0m\n").to_stdout
    end
  end
end