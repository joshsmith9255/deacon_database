class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :deacon_id
      t.integer :client_id
      t.date :start_date
      t.date :end_date
      t.string :exit_notes

      t.timestamps
    end
  end
end
