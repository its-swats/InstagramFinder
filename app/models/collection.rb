class Collection < ActiveRecord::Base
	belongs_to :tag
	has_many :collection_posts
	has_many :posts, through: :collection_posts

	# def self.form_collection(hashtag)
	# 	@hashtag = hashtag
	# 	@collection = Collection.new
	# 	@parsed_data = self.parse_data_from_api
	# 	@collection.associate_tag
	# 	@collection.save
	# end

end
