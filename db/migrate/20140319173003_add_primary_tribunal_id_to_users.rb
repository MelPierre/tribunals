class AddPrimaryTribunalIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :primary_tribunal_id, :integer
  end
end
