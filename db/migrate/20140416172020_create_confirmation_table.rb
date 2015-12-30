class CreateConfirmationTable < ActiveRecord::Migration
  def change
    create_table :confirmations do |t|
      t.integer :user_id
      t.boolean :confirm, :default => false
    end
  end
end
