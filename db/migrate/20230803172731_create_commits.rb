class CreateCommits < ActiveRecord::Migration[7.0]
  def change
    create_table :commits do |t|
      t.string :title
      t.string :category
      t.string :link
      t.string :description
      t.string :author
      t.integer :likes
      t.integer :dislikes
      t.boolean :deleted

      t.timestamps
    end
  end
end
