class AacJudgesFtsIndex < ActiveRecord::Migration
  disable_ddl_transaction!
  
  def up
    execute "CREATE INDEX CONCURRENTLY aac_judges_fts_index 
            ON judges 
            using gin(to_tsvector('english', name::text))"
  end

  def down
    execute "DROP INDEX aac_judges_fts_index"
  end
end
