require_relative "../Entities/actions.rb"
require_relative "../Entities/operations.rb"
require_relative "../Entities/phrases.rb"
require_relative "../Entities/records.rb"
require_relative "../Entities/special_words.rb"
require_relative "../Entities/users.rb"
require_relative '../Settings/local_settings.rb'

include Entities
include Entities::Operations

describe Entities do

  describe Actions do
    before :each do
      @test = Actions.new
    end

    after :each do
      @test = nil
    end

    it "has actions hash" do
      expect(@test.all).to_not be nil
      expect(@test.all).to be_a(Hash)
    end
    it "has 'show' words as array" do
      expect(@test.show_words).to_not be nil
      expect(@test.show_words).to be_a(Array)
    end
    it "has 'add' words as array" do
      expect(@test.add_words).to_not be nil
      expect(@test.add_words).to be_a(Array)
    end
    it "has 'delete' words as array" do
      expect(@test.delete_words).to_not be nil
      expect(@test.delete_words).to be_a(Array)
    end
    it "has 'exit' words as array" do
      expect(@test.exit_words).to_not be nil
      expect(@test.exit_words).to be_a(Array)
    end
    it "has 'edit' words as array" do
      expect(@test.edit_words).to_not be nil
      expect(@test.edit_words).to be_a(Array)
    end
  end

  describe Operations do
    before :all do
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
      @test_user.LastLogin = nil
      @test_user.save
    end

    describe 'get_user_info' do
      it 'returns user by username' do
        expect(get_user_info(@test_user.Username)).to be_a(Users)
      end
      it 'returns user by first name' do
        expect(get_user_info(@test_user.FirstName)).to be_a(Users)
      end
      it 'returns user by last name' do
        expect(get_user_info(@test_user.LastName)).to be_a(Users)
      end
      it 'returns user by first and last name' do
        expect(get_user_info(@test_user.FirstName + " " + @test_user.LastName)).to be_a(Users)
      end
      it 'does not return user when there is no such user' do
        expect(get_user_info('testingtestertesterov-but_there_is_no_such_user?')).to_not be_a(Users)
      end
    end

    describe 'update_login' do
      it "changes user's last login field" do
        update_login(@test_user.Username)
        expect(@test_user.LastLogin.strftime "%d/%m/%Y %H:%M").to be > (Time.new - 1)
        expect(@test_user.LastLogin).to_not be nil
      end
    end

    describe 'check_recent_logins' do
      it 'returns the user who logged last' do
        update_login(@test_user.Username)
        expect(check_recent_logins()).to_not be nil
        expect(check_recent_logins()).to eq @test_user
      end
      it "does not return test_user if he didn't logged recently" do
        @test_user.LastLogin = nil
        @test_user.save
        expect(check_recent_logins()).to_not eq @test_user
      end
    end
  end
end