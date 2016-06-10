class Tag < ActiveRecord::Base
	has_many :tagged_posts, class_name: 'PostTag'
	has_many :posts, through: :tagged_posts
end
