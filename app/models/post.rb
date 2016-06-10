class Post < ActiveRecord::Base
	has_many :collection_posts
	has_many :collections, through: :collection_posts
	has_many :tagged_posts, class_name: 'PostTag'
	has_many :tags, through: :tagged_posts
end
