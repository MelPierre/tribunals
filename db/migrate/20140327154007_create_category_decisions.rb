class CreateCategoryDecisions < ActiveRecord::Migration
  def change
    create_table :category_decisions do |t|
      t.references :all_decision
      t.references :category
      t.references :subcategory

      t.timestamps
    end
  end
end
