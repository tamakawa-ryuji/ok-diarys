class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.string :aftergoal1
      t.string :aftergoal2
      t.string :aftergoal3      
      t.string :progress1
      t.string :progress2
      t.string :progress3
      t.string :achivement
      t.string :improvement
      t.date :day1
      t.references  :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
