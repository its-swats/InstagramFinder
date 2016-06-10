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

	def get_data_from_api(pagination = '')
		JSON.parse(HTTParty.get("https://api.instagram.com/v1/tags/#{@hashtag}/media/recent?access_token=#{SECRET_KEY}#{pagination}").body)
	end

	def create_collection
		@collection = Collection.new
		@collection.tag = Tag.find_or_create_by(hashtag: hashtag)
		@collection.save if !@collection.persisted?
	end

	def create_posts
		@parsed_data['data'].each do |post|
			new_post = Post.find_by(instagram_id: post['id']) || Post.new(file_type: post['type'], caption: post['caption'], username: post['user']['username'], instagram_id: post['id'], video: post['videos'], image: post['images'])		
			new_post.collections << @collection
			new_post.tags << @collection.tag
			new_post.save if !new_post.persisted?
		end

		handle_pagination if @parsed_data['pagination']['next_url']
	end

	def handle_pagination
			@parsed_data = get_data_from_api("&max_tag_id=#{@parsed_data['pagination']['next_max_tag_id']}")
			create_posts
	end
end
