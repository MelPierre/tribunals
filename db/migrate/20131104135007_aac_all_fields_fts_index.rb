class AacAllFieldsFtsIndex < ActiveRecord::Migration
  disable_ddl_transaction!
  
  def up
    execute "CREATE INDEX CONCURRENTLY aac_all_fields_combined_fts_index 
            ON aac_decisions 
            using gin(to_tsvector('english', coalesce(ncn::text, '') || ' ' || 
            coalesce(ncn_year::text, '') || ' ' ||
            coalesce(ncn_code1::text, '') || ' ' ||
            coalesce(ncn_citation::text, '') || ' ' ||
            coalesce(ncn_code2::text, '') || ' ' ||
            coalesce(file_number::text, '') || ' ' || 
            coalesce(file_no_1::text, '') || ' ' || 
            coalesce(file_no_2::text, '') || ' ' || 
            coalesce(file_no_3::text, '') || ' ' ||             
            coalesce(reported_number::text, '') || ' ' || 
            coalesce(claimant::text, '') || ' ' || 
            coalesce(respondent::text, '') || ' ' || 
            coalesce(keywords::text, '') || ' ' || 
            coalesce(notes::text, '') || ' ' || 
            coalesce(text::text, '')))"
  end

  def down
    execute "DROP INDEX aac_all_fields_combined_fts_index"
  end
end
