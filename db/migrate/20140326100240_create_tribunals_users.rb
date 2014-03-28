class CreateTribunalsUsers < ActiveRecord::Migration
  def change
    create_table :tribunals_users, id: false do |t|
      t.references :user
      t.references :tribunal
    end

    add_index :tribunals_users, [:user_id, :tribunal_id]
  end
end
