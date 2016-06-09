class CollectionPost < ActiveRecord::Base
	belongs_to :collection
	belongs_to :post
end
