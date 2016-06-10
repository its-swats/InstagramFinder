class Instagram
	attr_reader :hashtag, :parsed_data, :start_date, :end_date

	def initialize(hashtag)
		@hashtag = hashtag
		@start_date = Date.parse("2016-6-01").to_time.to_i
		@end_date = Date.parse("2016-06-12").to_time.to_i
		@parsed_data = get_data_from_api


	end

	def create_instagram_collection
		create_collection
		create_posts
	end

	private

	def get_data_from_api(pagination = '')
		JSON.parse(HTTParty.get("https://api.instagram.com/v1/tags/#{@hashtag}/media/recent?access_token=#{SECRET_KEY}&min_timestamp=#{@start_date}&max_timestamp=#{@end_date}#{pagination}").body)
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
