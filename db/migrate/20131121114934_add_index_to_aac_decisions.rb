class AddIndexToAacDecisions < ActiveRecord::Migration
  def change
    add_index :aac_decisions, :slug, unique: true
  end
end
