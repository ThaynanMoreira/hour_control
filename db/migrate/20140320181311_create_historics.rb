class CreateHistorics < ActiveRecord::Migration
  def change
    create_table :historics do |t|
      t.integer :user_id
      t.integer :hours_used
      t.integer :timetable_id

      t.timestamps
    end
    add_index :historics, :user_id
    add_index :historics, :timetable_id
    add_index :historics, :project_id
  end
end
