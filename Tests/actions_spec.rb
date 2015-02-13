require_relative "../Interpret/Actions/add.rb"
require_relative "../Interpret/Actions/delete.rb"
require_relative "../Interpret/Actions/edit.rb"
require_relative "../Interpret/Actions/show.rb"
load '../Interpret/recognize.rb'

include ActionsModule

RSpec.configure do |c|
  c.before { allow($stdout).to receive(:puts) }
end

describe ActionsModule do
	describe AddAction do
		it 'returns false when not recognized' do
			@dummy = AddAction
			@dummy.extend Recognize
			expect(@dummy.parse("add something great but not implemented yet")).to be false
		end
	end

	describe ShowAction do
		before :all do
			@dummy = ShowAction
			@dummy.extend Recognize
	  end
		it 'returns false when not recognized' do
			expect(@dummy.parse("show something great but not implemented yet")).to be false
		end
		it 'displays the time' do
			expect(@dummy.parse("show me the time, please")).to be true
			expect { @dummy.parse("show me the time, please") }.to output(/#{ Time.now.strftime "%H:%M" }/).to_stdout
		end
		it 'displays the date' do
			expect(@dummy.parse("show me the date, please")).to be true
			expect { @dummy.parse("show me the date, please") }.to output(/#{ Time.now.strftime "%d/%m/%Y" }/).to_stdout
		end
		it 'displays both the date and time' do
			test_string = "show me the date and time or i'll take your electronics out!"
			expect(@dummy.parse(test_string)).to be true
			expect { @dummy.parse(test_string) }.to output(/#{ Time.now.strftime "%d/%m/%Y %H:%M" }/).to_stdout
		end
		it 'displays the appointments of the user' do
			$current_user = Users.where({ Username: 'test_user' }).first
			first_appointment = Records.where({ UserId: $current_user.Id, RecordTypeId: 1 }).first
			expect { @dummy.parse("show me my appointments") }.to output(/#{ first_appointment.Subject }/).to_stdout
			$current_user = nil
		end
		it 'tells a joke' do
			expect { @dummy.parse("tell me a joke") }.to output.to_stdout
		end
	end

	describe EditAction do
		it 'returns false when not recognized' do
			@dummy = EditAction
			@dummy.extend Recognize
			expect(@dummy.parse("edit something great but not implemented yet")).to be false
		end
	end

	describe DeleteAction do
		it 'returns false when not recognized' do
			@dummy = DeleteAction
			@dummy.extend Recognize
			expect(@dummy.parse("delete something great but not implemented yet")).to be false
		end
	end
end