class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.string :file_type
    	t.text :caption
    	t.string :username
    	t.text :image
      t.text :video
    	t.string :instagram_id

      t.timestamps null: false
    end
  end
end
