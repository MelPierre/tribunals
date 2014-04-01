class CreateSubcategory < ActiveRecord::Migration
  def change
    create_table :subcategories do |t|
      t.string :name
      t.references :category
      t.references :tribunal
      t.timestamps
    end
  end
end
