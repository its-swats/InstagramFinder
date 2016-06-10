class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.string :file_type
    	t.string :caption
    	t.string :username
    	t.string :image
      t.string :video
    	t.string :instagram_id

      t.timestamps null: false
    end
  end
end
