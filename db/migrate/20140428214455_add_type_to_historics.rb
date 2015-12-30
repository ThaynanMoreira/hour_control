class AddTypeToHistorics < ActiveRecord::Migration
  def change
    add_column :historics, :type_id, :integer
  end
end
