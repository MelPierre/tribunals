class AddIndexToEatDecisons < ActiveRecord::Migration
  def change
    add_index :eat_decisions, :slug, unique: true
  end
end
