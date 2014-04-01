class CreateDecisionsJudges < ActiveRecord::Migration
  def change
    create_table :decisions_judges, id: false do |t|
      t.references :all_decision
      t.references :all_judge
    end
    add_index :decisions_judges, [:all_decision_id, :all_judge_id]
  end
end
