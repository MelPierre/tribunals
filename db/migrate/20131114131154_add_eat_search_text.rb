class AddEatSearchText < ActiveRecord::Migration
  def change
    add_column :eat_decisions, :search_text, :text
  end
end
