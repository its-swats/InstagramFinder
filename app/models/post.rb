class Post < ActiveRecord::Base
	has_many :tagged_posts, class_name: 'PostTag'
	has_many :tags, through: :tagged_posts
end
