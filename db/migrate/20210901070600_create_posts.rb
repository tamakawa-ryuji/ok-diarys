class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :goal1
      t.string :goal2
      t.string :goal3
      t.string :content
      t.string :feeling1
      t.string :feeling2
      t.date :day
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
