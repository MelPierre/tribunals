class AddSearchTextToAacDecisions < ActiveRecord::Migration
  def change
    add_column :aac_decisions, :search_text, :text
  end
end
