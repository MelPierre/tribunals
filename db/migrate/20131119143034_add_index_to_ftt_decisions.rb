class AddIndexToFttDecisions < ActiveRecord::Migration
  def change
    add_index :ftt_decisions, :slug, unique: true
  end
end
