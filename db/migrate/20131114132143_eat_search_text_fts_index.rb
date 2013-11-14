class EatSearchTextFtsIndex < ActiveRecord::Migration
  disable_ddl_transaction!
  
  def up
    execute "CREATE INDEX CONCURRENTLY eat_search_text_fts_index 
            ON eat_decisions 
            using gin(to_tsvector('english', search_text::text))"
  end

  def down
    execute "DROP INDEX eat_search_text_fts_index"
  end
end
