require_relative "../Interpret/greet.rb"
require_relative '../Settings/local_settings.rb'
require_relative '../Entities/users.rb'
require 'database_cleaner'

include Entities

class DummyClass
end

RSpec.configure do |c|
  c.before { allow($stdout).to receive(:puts) }
end

  
describe Greet do
  before :all do
    DatabaseCleaner.strategy = :transaction # за изчистване на базата данни след тестовете
    DatabaseCleaner.start

    @dummy = DummyClass.new
    @dummy.extend Greet

    @test_user = Users.where({ Username: "test_user" }).first
    if !@test_user
      @test_user = Users.new
      @test_user.Id = Users.all.last.Id + 1
      @test_user.Username = "test_user"
      @test_user.FirstName = "Test"
      @test_user.LastName = "Tester"
      @test_user.BirthPlace = "Test, Test"
      @test_user.BirthDate = "2000-01-01"
      @test_user.save			
    end
  end

  after :all do
    DatabaseCleaner.clean
    $current_user = nil
  end

  describe "Recently logged user" do
    describe "Console output" do
      it "greets user" do
        expect { @dummy.greet_recent_user(@test_user, false) }.to output(/#{ @test_user.FirstName } #{ @test_user.LastName }/).to_stdout
      end
    end
  
    describe "Recent users" do
    	it "changes current user global variable" do
    		@dummy.greet_recent_user(@test_user, false)
    	  expect(@test_user).to eql($current_user)
      end
    end
  end

  describe "User operations" do
    describe "Logs user" do
      before :each do
        @dummy.log_user(@test_user)
      end

      it "changes current user global variable" do
        expect(@test_user).to eql($current_user)
      end

      it "outputs info to user" do
        expect { @dummy.log_user(@test_user) }.to output(/I found you, #{ @test_user.FirstName } #{ @test_user.LastName }/).to_stdout
      end
    end
  end
end