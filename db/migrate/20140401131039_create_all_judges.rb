class CreateAllJudges < ActiveRecord::Migration
  def change
    create_table :all_judges do |t|
      t.string :name      
      t.integer :legacy_id
      t.references :tribunal, index: true
      t.timestamps
    end
  end
end
