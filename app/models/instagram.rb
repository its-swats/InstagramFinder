class Instagram
	attr_reader :hashtag, :parsed_data

	def initialize(hashtag)
		@hashtag = hashtag
		@parsed_data = get_data_from_api
	end

	def create_instagram_collection
		create_collection
		create_posts
	end

	private

	def get_data_from_api
		JSON.parse(HTTParty.get("https://api.instagram.com/v1/tags/#{@hashtag}/media/recent?access_token=#{SECRET_KEY}").body)['data']
	end

	def create_collection
		@collection = Collection.new
		@collection.tag = Tag.find_or_create_by(hashtag: hashtag)
		@collection.save
	end

	def create_posts
		@parsed_data.each do |post|
			new_post = Post.new(file_type: post['type'], caption: post['caption'], username: post['user']['username'], instagram_id: post['id'])
			if post['images']
				new_post.image_url = post['images']['standard_resolution']['url']
			else
				new_post.video_url = post['videos']['standard_resolution']['url']
			end
			new_post.collections << @collection
			new_post.tags << @collection.tag
			new_post.save
		end
	end
end