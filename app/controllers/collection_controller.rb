require 'ErrorHandling'

class CollectionController < ApplicationController
	protect_from_forgery

	def index
		if ErrorHandling.verify_form_params(params[:request])
			@hashtag = Tag.find_or_create_by(hashtag: params[:request][:hashtag].downcase.gsub(/[^0-9a-z]/i, '')) 
			@all_posts = @hashtag.posts.where("tag_time < ?", (Date.parse(params[:request][:end_date]).to_time.to_i + 86400))
																 .where("tag_time > ?", Date.parse(params[:request][:start_date]).to_time.to_i)
			@cover = @all_posts[0]
			@pages = @all_posts[1..-1]
			if @cover == nil
				flash[:errors] = "No entries for #{@hashtag.hashtag} found - please scrape first."
				redirect_to root_path, status: 204
			else
				render status: 200
			end
		else
			flash[:errors] = "Your search terms were not valid, please try again."
			redirect_to root_path, status: 400
		end
	end

	def create
		if ErrorHandling.verify_form_params(params[:request])
			collection = Instagram.new(params[:request][:hashtag].gsub(/[^0-9a-z]/i, ''), 
																 params[:request][:start_date], params[:request][:end_date])
			collection.create_instagram_collection
			redirect_to root_path, status: 200
		else
			flash[:errors] = "Your search terms were not valid, please try again."
			redirect_to root_path, status: 400
		end
	end
end


