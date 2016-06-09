class CreateCollectionPosts < ActiveRecord::Migration
  def change
    create_table :collection_posts do |t|
    	t.integer :collection_id
    	t.integer :post_id


      t.timestamps null: false
    end
  end
end
