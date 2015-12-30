class AddObservationToTimetables < ActiveRecord::Migration
  def change
    add_column :timetables, :observation, :string
    add_column :timetables, :month, :integer
    add_column :timetables, :year, :integer
  end
end
