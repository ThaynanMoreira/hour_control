class RemoveHoursCompletedFromTimetable < ActiveRecord::Migration
  def change
    remove_column :timetables,:hours_completed
    rename_column :timetables, :hours_completed2,:hours_completed
  end
end
