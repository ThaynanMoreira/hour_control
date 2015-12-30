class RemoveHoursUsedFromHistorics < ActiveRecord::Migration
  def up
    remove_column :historics,:hours_used
    rename_column :historics, :hours_used2,:hours_used
  end
end
