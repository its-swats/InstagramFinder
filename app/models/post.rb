class Post < ActiveRecord::Base
	has_many :tagged_posts, class_name: 'PostTag'
	has_many :tags, through: :tagged_posts
	has_many :collected_posts, class_name: 'CollectionPost'
	has_many :collections, through: :collected_posts

	serialize :video
	serialize :image
	serialize :caption
end
