class CreateInitialTables < ActiveRecord::Migration
  def change
    create_table :instagram_images do |t|
      t.string :link
      t.string :latitude
      t.string :longitude
      t.integer :likes
      t.string :created
      t.string :thumbnail

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


