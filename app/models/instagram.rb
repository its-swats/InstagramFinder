require "InstApi"

class Instagram
	attr_reader :hashtag, :parsed_data, :start_date, :end_date

	def initialize(hashtag, start_date, end_date)
		@hashtag = Tag.find_or_create_by(hashtag: hashtag)
		@start_date = Date.parse(start_date).to_time.to_i
		@end_date = Date.parse(end_date).to_time.to_i
		# @start_date = Date.parse("2016-03-01").to_time.to_i
		# @end_date = Date.parse("2016-05-25").to_time.to_i
		@parsed_data = InstApi::POSTS.posts(hashtag, @start_date, @end_date, closest_start)
	end

	def create_instagram_collection
		create_posts
	end

	private

	def closest_start
		closest = PostTag.where("tag_time > ?", end_date).order(tag_time: :asc).first
		p closest
		return closest.pointer if closest
		return nil
	end

	def create_posts
		parsed_data.each do |post| 
			@current_post = Post.find_by(instagram_id: post['id']) || 
				Post.create(
					file_type: post['type'], 
					caption: post['caption'], 
					username: post['user']['username'], 
					instagram_id: post['id'], 
					video: post['videos'], 
					image: post['images']
				)
			create_or_update_tag_associations(post)
		end
	end

	def create_or_update_tag_associations(post)
		if !@current_post.tags.include?(@hashtag)
			tagged_post = PostTag.new(post_id: @current_post.id, tag_id: @hashtag.id)
			tagged_post.tag_time = get_tag_time(post)
			tagged_post.pointer = post['pointer']
			tagged_post.save
		elsif @current_post.tagged_posts.find_by(tag_id: @hashtag.id).tag_time == nil
			tagged_post.tag_time = get_tag_time(post)
			tagged_post.save if !tagged_post.persisted?
		end
	end

	def get_tag_time(post)
		if post['caption'] && post['caption']['text'].downcase.include?('#'+@hashtag.hashtag)
			return post['caption']['created_time'].to_i
		else
			comments = InstApi::COMMENTS.comments(post['id'])
			return comments['data'].find {|x| x['text'].downcase.include?('#'+@hashtag.hashtag) && x['from']['username'] == post['user']['username']}['created_time']
		end
	end
end