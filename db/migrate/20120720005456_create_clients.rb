class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :last_name
      t.string :first_name
      t.string :gender
      t.string :ethnicity
      t.string :marital_status
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.boolean :gov_assistance
      t.boolean :is_employed
      t.boolean :is_veteran
      t.boolean :active

      t.timestamps
    end
  end
end
