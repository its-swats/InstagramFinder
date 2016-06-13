require 'spec_helper'
require 'ErrorHandling'
require 'Date' 

describe ErrorHandling do 
	let (:valid_params) { {start_date: "2016-06-01", end_date: "2016-06-07", hashtag: 'gameofthrones'}} 
	let (:start_after_end) {{ start_date: "2016-06-09", end_date: "2016-03-01", hashtag: 'gameofthrones' }}
	let (:start_date_invalid) {{ start_date: '0', end_date: "2016-03-01", hashtag: 'gameofthrones' }}
	let (:end_date_invalid) {{ start_date: "2016-06-09", end_date: '0', hashtag: 'gameofthrones' }}
	let (:hashtag_missing) {{ start_date: "2016-06-09", end_date: "2016-03-01", hashtag: nil }}
	let (:the_future) {{start_date: "2016-06-01", end_date: "2025-06-07", hashtag: 'gameofthrones'}}
	describe 'ErrorHandling#verify_form_params' do 
		it 'returns true if all params are valid' do 
			expect(ErrorHandling.verify_form_params(valid_params)).to be_truthy
		end
		it 'returns false if the start date is after the finish date' do 
			expect(ErrorHandling.verify_form_params(start_after_end)).to be_falsey
		end
		it 'returns false if the start date is missing' do 
			expect{ErrorHandling.verify_form_params(start_date_invalid)}.to raise_error(ArgumentError)
		end
		it 'returns false if the end date is missing' do 
			expect{ErrorHandling.verify_form_params(end_date_invalid)}.to raise_error(ArgumentError)
		end
		it 'returns false if the hashtag is missing' do 
			expect(ErrorHandling.verify_form_params(hashtag_missing)).to be_falsey
		end
		it 'returns false if the end date is in the future' do 
			expect(ErrorHandling.verify_form_params(the_future)).to be_falsey
		end
	end
end