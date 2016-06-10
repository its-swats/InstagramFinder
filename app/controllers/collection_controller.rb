class InstagramController < ApplicationController
	# require 'httparty'

	def index
		# @response = HTTParty.get("https://api.instagram.com/v1/tags/#{params[:request][:hashtag]}/media/recent?access_token=#{SECRET_KEY}")
		
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
