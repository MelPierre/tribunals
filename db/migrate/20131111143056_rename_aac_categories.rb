class RenameAacCategories < ActiveRecord::Migration
  def change
    rename_table :aac_decision_categories, :aac_categories
    rename_table :aac_decision_subcategories, :aac_subcategories
  end
end
