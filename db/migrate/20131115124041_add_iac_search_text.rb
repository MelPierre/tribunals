class AddIacSearchText < ActiveRecord::Migration
  def change
    add_column :decisions, :search_text, :text
  end
end
