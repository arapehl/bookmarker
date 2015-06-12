class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :uri
      t.string :title
      t.text :excerpt
      t.string :image_path
      t.references :account, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
