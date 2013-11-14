class FttSearchTextFtsIndex < ActiveRecord::Migration
  disable_ddl_transaction!
  
  def up
    execute "CREATE INDEX CONCURRENTLY ftt_search_text_fts_index 
            ON ftt_decisions 
            using gin(to_tsvector('english', search_text::text))"
  end

  def down
    execute "DROP INDEX ftt_search_text_fts_index"
  end
end
