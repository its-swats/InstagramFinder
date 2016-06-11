class CollectionController < ApplicationController
	# require 'httparty'
	protect_from_forgery

	def index
		p params
	end

	def show

	end

	def create
		test = Instagram.new(params[:request][:hashtag], params[:request][:start_date], params[:request][:end_date])
		test.create_instagram_collection
		redirect_to root_path
	end

	def delete

	end

end
