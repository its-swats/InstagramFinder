class InstagramController < ApplicationController
	# require 'httparty'

	def index
		# @response = HTTParty.get("https://api.instagram.com/v1/tags/#{params[:request][:hashtag]}/media/recent?access_token=#{SECRET_KEY}")
		@response = JSON.parse(HTTParty.get("https://api.instagram.com/v1/tags/#{params[:request][:hashtag]}/media/recent?access_token=#{SECRET_KEY}").body)['data']
	end

	def show

	end

	def create

	end

	def delete

	end

end
