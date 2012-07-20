class CreateDeacons < ActiveRecord::Migration
  def change
    create_table :deacons do |t|
      t.string :last_name
      t.string :first_name
      t.string :email
      t.string :password
      t.string :password_hash
      t.string :phone
      t.string :gender
      t.string :role
      t.boolean :active

      t.timestamps
    end
  end
end
