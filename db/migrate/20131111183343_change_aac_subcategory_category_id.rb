class ChangeAacSubcategoryCategoryId < ActiveRecord::Migration
  def change
    rename_column :aac_subcategories, :aac_decision_category_id, :aac_category_id
  end
end
