require "InstApi"

class Instagram
	attr_reader :hashtag, :parsed_data, :start_date, :end_date

	def initialize(hashtag)
		@hashtag = hashtag
		@start_date = Date.parse("2016-05-09").to_time.to_i
		@end_date = Date.parse("2016-06-12").to_time.to_i
		@parsed_data = InstApi::POSTS.posts(@hashtag, @start_date, @end_date)
	end

	def create_instagram_collection
		create_collection
		process_paginated_data
	end

	private

	def create_collection
		@collection = Collection.new
		@collection.tag = Tag.find_or_create_by(hashtag: hashtag)
		@collection.save if !@collection.persisted?
	end

	def process_paginated_data
		loop do
			create_posts
			break if pagination_is_done?
			process_next_page
		end
	end

	def create_posts
		@parsed_data['data'].each do |post|
			@current_post = Post.find_by(instagram_id: post['id']) 
			if !@current_post
				@current_post = Post.create(file_type: post['type'], caption: post['caption'], username: post['user']['username'], instagram_id: post['id'], video: post['videos'], image: post['images'])
			end
			check_tag_associations(post)
		end
	end

	def check_tag_associations(post)
		if !@current_post.tags.include?(@collection.tag)
			tagged_post = PostTag.new(post_id: @current_post.id, tag_id: @collection.tag.id)
			tagged_post.tag_time = get_tag_time(post)
			tagged_post.save if !tagged_post.persisted?
		end
	end

	def get_tag_time(post)
		if post['caption'] && post['caption']['text'].downcase.include?('#'+hashtag)
			return post['caption']['created_time'].to_i
		else
			comments = InstApi::COMMENTS.comments(post['id'])
			return comments['data'].find {|x| x['text'].downcase.include?('#'+@hashtag) && x['from']['username'] == post['user']['username']}['created_time']
		end
	end

	def process_next_page
		return @parsed_data = InstApi::POSTS.posts(@hashtag, @start_date, @end_date, "&max_tag_id=#{@parsed_data['pagination']['next_max_tag_id']}")
	end

	def pagination_is_done?
		return @parsed_data['pagination']['next_max_tag_id'] == nil
	end
end