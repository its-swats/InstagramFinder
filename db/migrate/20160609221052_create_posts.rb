class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.string :type
    	t.string :caption
    	t.string :username
    	t.string :image_url


      t.timestamps null: false
    end
  end
end
