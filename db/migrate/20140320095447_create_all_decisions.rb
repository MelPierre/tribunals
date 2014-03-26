class CreateAllDecisions < ActiveRecord::Migration
  def change
    create_table :all_decisions do |t|
      t.text :claimant
      t.string :respondent

      t.string :doc_file
      t.string :pdf_file
      
      t.text :text
      t.text :html
      t.text :search_text
 
      t.string :slug

      t.text :notes

      t.date :promulgation_date
      t.date :hearing_date
      t.date :decision_date
      t.date :upload_date
      t.date :publication_date

      t.string :neutral_citation_number
      t.string :file_number
      t.string :reported_number
      t.string :appeal_number

      t.boolean :starred
      t.boolean :reported
      t.boolean :published
      t.boolean :country_guideline

      t.string :country
      t.string :case_name

      t.json :other_metadata

      t.references :tribunal
      t.timestamps      
    end
  end
end
