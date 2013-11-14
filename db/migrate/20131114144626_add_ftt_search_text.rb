class AddFttSearchText < ActiveRecord::Migration
  def change
    add_column :ftt_decisions, :search_text, :text
  end
end
