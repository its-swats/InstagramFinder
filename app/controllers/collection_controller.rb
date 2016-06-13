class CollectionController < ApplicationController
	protect_from_forgery

	def index
		@hashtag = Tag.find_or_create_by(hashtag: params[:request][:hashtag])
		start_date = Date.parse(params[:request][:start_date]).to_time.to_i
		end_date = (Date.parse(params[:request][:end_date]).to_time.to_i + 86400)		


		@all_posts = @hashtag.posts.where("tag_time < ?", end_date).where("tag_time > ?", start_date)
		@cover = @all_posts[0]
		@pages = @all_posts[1..-1]
		if @cover == nil
			flash[:errors] = "No entries for #{@hashtag.hashtag} found - please scrape first."
			redirect_to root_path
		end
	end

	def create
		collection = Instagram.new(params[:request][:hashtag], params[:request][:start_date], params[:request][:end_date])
		collection.create_instagram_collection
		redirect_to root_path
	end

end
