class CreateAllDecisions < ActiveRecord::Migration
  def change
    create_table :all_decisions do |t|
      t.string :claimant
      t.string :respondent

      t.string :doc_file
      t.string :pdf_file
      
      t.text :text
      t.text :html
      t.text :search_text
 
      t.string :slug

      t.string :notes

      t.json :dates, :default =>[
                                  {
                                  type: "promulgation",
                                  value: nil
                                  },
                                  {
                                  type: "hearing",
                                  value: nil
                                  },
                                  {
                                  type: "decision",
                                  value: nil
                                  },
                                  {
                                  type: "upload",
                                  value: nil
                                  },
                                  {
                                  type: "publication",
                                  value: nil
                                  }
                                ]

      t.json :reference_ids, :default =>[
                                  {
                                  type: "ncn",
                                  value: nil
                                  },
                                  {
                                  type: "file_number",
                                  value: nil
                                  },
                                  {
                                  type: "reported_number",
                                  value: nil
                                  },
                                  {
                                  type: "appeal_number",
                                  value: nil
                                  }
                                ]

      t.json :other_metadata, :default =>[
                                  {
                                  type: "starred",
                                  value: false
                                  },
                                  {
                                  type: "reported",
                                  value: false
                                  },
                                  {
                                  type: "published",
                                  value: false
                                  },
                                  {
                                  type: "country_guideline",
                                  value: false
                                  },
                                  {
                                  type: "country",
                                  value: nil
                                  },
                                  {
                                  type: "case_name",
                                  value: nil
                                  }
                                ]

      t.timestamps      
    end
  end
end

# id  integer NOT NULL  auto incrementing db id; not manually assigned
# claimant  character varying(255)  
# respondent  character varying(255)  
# doc_file  character varying(255)  original decision doc stored with carrierwave
# pdf_file  character varying(255)  original decision doc stored with carrierwave
# text  text  decision text extracted from doc/pdf
# html  text  decision text converted to html
# search_text text  all metadata appended in front of decision text
# slug  character varying(255)  created based on some unique id (file no. / ncn / id)
# dates json  "hash of different types of dates - 
# promulgation_date (promulgated_on),
# hearing_date,
# decision_date,
# upload_date,
# publication_date"
# notes character varying(255)  
# reference_ids json  "hash of different types of ref ids - 
# ncn,
# file_number,
# reported_number,
# appeal_number"
# other_metadata  json  "other attributes that may not be common across tribunals:
# starred - boolean,
# reported - boolean,
# published - boolean,
# country_guideline - boolean,
# country - character varying(255),
# case_name character varying(255)"
    
# created_at  datetime  default db timestamp
# updated_at  datetime  default db timestamp; allow overriding by admin?