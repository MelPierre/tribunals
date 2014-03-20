class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :type, :string
    remove_column :users, :admin
    add_index :users, :type
  end
end
