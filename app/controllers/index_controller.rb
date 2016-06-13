class IndexController < ApplicationController

	def index
		# flash[:errors] = ['Something broke', 'Something else broke']
		@data = Tag.all.order(updated_at: :desc).limit(10)
	end
	
end
