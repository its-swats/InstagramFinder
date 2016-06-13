require "InstApi"

class Instagram
	attr_reader :hashtag, :parsed_data, :start_date, :end_date

	def initialize(hashtag, start_date, end_date)
		@hashtag = Tag.find_or_create_by(hashtag: hashtag)
		@start_date = Date.parse(start_date).to_time.to_i
		@end_date = (Date.parse(end_date).to_time.to_i + 86400)
		@parsed_data = InstApi::POSTS.posts(hashtag, @start_date, @end_date, closest_start)
	end

	def create_instagram_collection
		create_posts
	end

	private

	def closest_start
		closest = @hashtag.tagged_posts.where("tag_time > ?", end_date).order(tag_time: :asc).first
		return closest.pointer if closest
		return nil
	end

	def create_posts
		parsed_data.each do |post| 
			@tagged_post = PostTag.new(tag_id: @hashtag.id)
			@tagged_post.tag_time = get_tag_time(post)
			if within_time_range
				@current_post = Post.find_by(instagram_id: post['id']) || 
				Post.new(
					file_type: post['type'], 
					caption: post['caption'], 
					username: post['user']['username'], 
					instagram_id: post['id'], 
					video: post['videos'], 
					image: post['images'],
					link: post['link']
					)
				create_or_update_tag_associations(post)
			end
		end
	end

	def create_or_update_tag_associations(post)
		if !@current_post.tags.include?(@hashtag)
			@tagged_post.pointer = post['pointer']
			@current_post.save				
			@tagged_post.post_id = @current_post.id
			@tagged_post.save
		end				
	end

	def tagged_in_caption(post)
		return post['caption'] && post['caption']['text'].downcase.include?('#'+@hashtag.hashtag)
	end

	def get_tag_time(post)
		if tagged_in_caption(post)
			return post['caption']['created_time'].to_i
		else
			comments = InstApi::COMMENTS.comments(post['id'])
			matches = comments['data'].find {|comment| comment['from']['username'] == post['user']['username'] && comment['text'].downcase.include?('#'+@hashtag.hashtag)}
			matches ? (return matches['created_time']) : nil
		end
	end

	def within_time_range
		return @tagged_post.tag_time < @end_date && @tagged_post.tag_time > @start_date if @tagged_post.tag_time
	end

end
