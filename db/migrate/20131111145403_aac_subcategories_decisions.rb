class AacSubcategoriesDecisions < ActiveRecord::Migration
  def change
    create_table :aac_subcategories_decisions do |t|
      t.belongs_to :aac_subcategory
      t.belongs_to :aac_decision

      t.timestamps
    end
  end
end
