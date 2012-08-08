class ChangeZipToString < ActiveRecord::Migration
  def change
    change_table :clients do |t|
    	t.change :zip, :string
    end
  end
end
