class AddOriginalNameToAllJudges < ActiveRecord::Migration
  def change
    [:original_name, :suffix, :prefix, :surname].each do |name|
      add_column :all_judges, name, :string
    end

    rename_column :all_judges, :name, :old_name
  end
end
