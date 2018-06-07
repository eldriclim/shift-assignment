class ChangeDelivererPhoneToString < ActiveRecord::Migration[5.1]
  def change
    change_column :deliverers, :phone, :string
  end
end
