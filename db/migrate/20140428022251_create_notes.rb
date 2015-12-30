class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :key
      t.text :content

      t.timestamps
    end
  end
end
