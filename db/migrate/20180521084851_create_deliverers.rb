class CreateDeliverers < ActiveRecord::Migration[5.1]
  def change
    create_table :deliverers do |t|
      t.string :name
      t.integer :vehicle
      t.integer :phone
      t.boolean :active

      t.timestamps
    end
  end
end
