class AddPassworddigestToDeacons < ActiveRecord::Migration
  def change
    add_column :deacons, :password_digest, :string

  end
end
