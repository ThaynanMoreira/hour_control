class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.integer :type_id
      t.integer :hours_amount
      t.integer :hours_completed
      t.integer :project_id

      t.timestamps
    end
    add_index :timetables, :project_id
    add_index :timetables, :type_id
  end
end
