class IacSearchTextFtsIndex < ActiveRecord::Migration
  disable_ddl_transaction!
  
  def up
    execute "CREATE INDEX CONCURRENTLY iac_search_text_fts_index 
            ON decisions 
            using gin(to_tsvector('english', search_text::text))"
  end

  def down
    execute "DROP INDEX iac_search_text_fts_index"
  end
end
