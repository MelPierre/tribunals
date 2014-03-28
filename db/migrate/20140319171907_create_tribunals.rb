class CreateTribunals < ActiveRecord::Migration
  def change
    create_table :tribunals do |t|
      t.string :name
      t.string :code
      t.string :title
      t.string :category_label, default: 'Category'
      t.string :subcategory_label, default: 'Sub-category'
      t.json :filters, default: []
      t.json :sort_by, default: []
      t.json :results_columns, default: []
      
      t.timestamps
    end
    add_index :tribunals, :code
  end
end
