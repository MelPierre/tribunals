class ChangeAacDecisionCategoryColumnName < ActiveRecord::Migration
  def change
    rename_column :aac_decisions, :aac_decisions_category_id, :aac_decision_category_id
  end
end
