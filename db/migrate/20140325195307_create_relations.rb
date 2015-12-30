class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
    add_index :relations, :user_id
    add_index :relations, :project_id
    add_index :relations, [:user_id, :project_id], :unique => true
  end
end
