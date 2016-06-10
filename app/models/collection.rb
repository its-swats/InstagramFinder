class Collection < ActiveRecord::Base
	belongs_to :tag
	has_many :collection_posts
	has_many :posts, through: :collection_posts
end
