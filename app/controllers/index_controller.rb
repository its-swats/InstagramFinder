class IndexController < ApplicationController

	def index
		@data = Tag.all.order(updated_at: :desc).limit(10)
	end
	
end
