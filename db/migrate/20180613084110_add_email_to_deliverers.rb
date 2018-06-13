class AddEmailToDeliverers < ActiveRecord::Migration[5.1]
  def self.up
    add_column :deliverers, :email, :string

    # Populate new column with phone to ensure uniqueness
    Deliverer.find_each do |deli|
      deli.update(email: "#{deli.phone}@email.com")
    end
  end

  def self.down
    remove_column :deliverers, :email, :string
  end
end
