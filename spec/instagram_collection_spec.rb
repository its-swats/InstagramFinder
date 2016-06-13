require 'rails_helper'
require 'InstApi'

RSpec.describe Instagram do
	describe 'Instagram#closest_start' do
		it 'finds the closest time' do
			PostTag.create(tag: 'gameofthrones', tag_time: 456, pointer: 'first')
			PostTag.create(tag: 'gameofthrones', tag_time: 1000, pointer: 'second')
			# test = Instagram.new()
		end
	end
end