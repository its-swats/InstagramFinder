class IndexController < ApplicationController

	def index
		# flash[:errors] = ['Something broke', 'Something else broke']
		@data = Tag.all
	end
	
end
