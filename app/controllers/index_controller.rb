class IndexController < ApplicationController

	def index
		@data = Tag.all		
	end
	
end
