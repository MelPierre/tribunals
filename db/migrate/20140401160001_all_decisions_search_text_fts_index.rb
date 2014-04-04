class AllDecisionsSearchTextFtsIndex < ActiveRecord::Migration
  disable_ddl_transaction!
  
  def up
    execute "CREATE INDEX CONCURRENTLY all_decisions_search_text_fts_index 
            ON all_decisions 
            using gin(to_tsvector('english', search_text::text))"
  end

  def down
    execute "DROP INDEX all_decisions_search_text_fts_index"
  end
end
