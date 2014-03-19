class AddPrimaryTribunalIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :primary_tribunal_id, :integer
    add_index :users, :primary_tribunal_id
  end
end
