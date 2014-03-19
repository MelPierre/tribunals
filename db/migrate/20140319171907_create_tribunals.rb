class CreateTribunals < ActiveRecord::Migration
  def change
    create_table :tribunals do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_index :tribunals, :code

    create_table :tribunals_users, id: false do |t|
      t.references :user
      t.references :tribunal
    end

    add_index :tribunals_users, [:user_id, :tribunal_id]

    Tribunal.create([
      {name:'Immigration and Aslyum Chamber' , code:'utiac'},
      {name:'First Tier Tribunal ' , code:'ftt' },
      {name:'Administrative Appeals Chamber' , code:'aac'}
    ])
  end
end
