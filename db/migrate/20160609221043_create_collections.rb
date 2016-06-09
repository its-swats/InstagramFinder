class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
    	t.integer :tag_id
  		

      t.timestamps null: false
    end
  end
end
