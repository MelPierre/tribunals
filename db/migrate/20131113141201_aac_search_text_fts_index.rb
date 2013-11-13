class AacSearchTextFtsIndex < ActiveRecord::Migration
  disable_ddl_transaction!
  
  def up
    execute "CREATE INDEX CONCURRENTLY aac_search_text_fts_index 
            ON aac_decisions 
            using gin(to_tsvector('english', search_text::text))"
  end

  def down
    execute "DROP INDEX aac_search_text_fts_index"
  end
end
