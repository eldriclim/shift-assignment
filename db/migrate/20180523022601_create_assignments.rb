class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.integer :deliverer_id
      t.integer :shift_id

      t.timestamps
    end
  end
end
