class Post < ActiveRecord::Base
	has_many :collection_posts
	has_many :collections, through: :collection_posts
	has_many :post_tags
	has_many :tags, through: :post_tags
end
