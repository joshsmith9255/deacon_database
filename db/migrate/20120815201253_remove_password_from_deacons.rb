class RemovePasswordFromDeacons < ActiveRecord::Migration
  def up
    remove_column :deacons, :password
        remove_column :deacons, :password_hash
      end

  def down
    add_column :deacons, :password_hash, :string
    add_column :deacons, :password, :string
  end
end
