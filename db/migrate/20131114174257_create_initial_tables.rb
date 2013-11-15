class CreateInitialTables < ActiveRecord::Migration
  def change
    create_table :instagram_images do |t|
      t.string :link
      t.integer :latitude
      t.integer :longitude
      t.integer :likes
      t.string :created
      t.string :thumsbnail

      t.timestamps
    end
  
    create_table :tags do |t|
      t.string :label

      t.timestamps

    end

    create_table :instagram_images_tags do |t|
      t.belongs_to :instagram_image
      t.belongs_to :tag
    end
  end
end


