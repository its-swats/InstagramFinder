class CollectionController < ApplicationController
	# require 'httparty'

	def index
		p params
		# @response = HTTParty.get("https://api.instagram.com/v1/tags/#{params[:request][:hashtag]}/media/recent?access_token=#{SECRET_KEY}")
		# {"request"=>{"hashtag"=>"", "start_date"=>"2016-06-07", "end_date"=>"2016-06-22"}, "controller"=>"collection", "action"=>"index"}
	end

	def show

	end

	def create
		Instagram.new(params[:request][:hashtag])
		# @response = 
	end

	def delete

	end

end
