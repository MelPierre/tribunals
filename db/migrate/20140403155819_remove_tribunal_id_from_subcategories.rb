class RemoveTribunalIdFromSubcategories < ActiveRecord::Migration
  def change
    remove_column :subcategories, :tribunal_id, :integer
  end
end
