class AddLegacyIdsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :legacy_id, :integer, null: true
    add_column :subcategories, :legacy_id, :integer, null: true
  end
end