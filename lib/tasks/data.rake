namespace :data do
  desc 'Seed tribunals'

  task seed_tribunals: :environment do
    Tribunal.delete_all
    Tribunal.create([
      {
        name:'Immigration and Aslyum Chamber',
        code:'utiac',
        title: 'Immigration and asylum chamber: decisions on appeals to the Upper Tribunal',
        filters: [
                    {
                      name: "reported", 
                      label: "Case status", 
                      type: "radio",
                      options: [
                                  {
                                    label: "All",
                                    value: "all",
                                    checked: true
                                  },
                                  {
                                    label: "Reported",
                                    value:"reported"
                                  },
                                  {
                                    label: "Unreported",
                                    value:"unreported"
                                  }
                                ]
                    },
                    {
                      name: "country",
                      label: "Country",
                      type: "text",
                      predictive: true
                    }
                  ],
          sort_by: [],
          results_columns: []
        },
      {
        name:'First Tier Tribunal',
        code:'ftt-tax',
        title: 'Tax: First-tier Tribunal judgments',
        filters: [
                    {
                      name: "judge",
                      label: "Name of judge",
                      type: "text",
                      predictive: true,
                      placeholder: "Show cases this judge heard only"
                    },
                    {
                      name: "party",
                      label: "Name of party",
                      type: "text",
                      predictive: true,
                      placeholder: "Show cases brought by this party"
                    },
                    {
                      name: "category",
                      label: "Topic",
                      type: "text",
                      predictive: true,
                      placeholder: "What the case is about"
                    },
                    {
                      name: "subcategory",
                      label: "Sub-topic",
                      type: "text",
                      predictive: true,
                      placeholder: "More detail about the case"
                    }
                  ],
          sort_by: [{name: "date_of_decision", label: "Date of decision"}, {name: "date_of_hearing", label: "Date of hearing"}],
          results_columns: [{name: "reference_id", label: "Reference number"}, {name: "date_of_decision", label: "Date of decision"}]
        },
      {
        name:'Administrative Appeals Chamber',
        code:'utaac',
        title: 'Administrative appeals chamber: decisions on appeals to the Upper Tribunal',
        filters: [
                    {
                      name: "judge",
                      label: "Name of judge",
                      type: "text",
                      predictive: true,
                      placeholder: "Show cases this judge heard only"
                    },
                    {
                      name: "party",
                      label: "Name of party",
                      type: "text",
                      predictive: true,
                      placeholder: "Show cases brought by this party"
                    },
                    {
                      name: "category",
                      label: "Topic",
                      type: "text",
                      predictive: true,
                      placeholder: "What the case is about"
                    },
                    {
                      name: "subcategory",
                      label: "Sub-topic",
                      type: "text",
                      predictive: true,
                      placeholder: "More detail about the case"
                    }
                  ],
                sort_by: [{name: "created_at", label: "Date added"}, {name: "date_of_decision", label: "Date of decision"}],
                results_columns: [{name: "reference_id", label: "Reference number"}, {name: "date_of_decision", label: "Date of decision"}]
      },
      {
        name:'Employment Appeals Tribunal', 
        code:'eat',
        title: 'Employment appeals: judgments on appeals to the Employment Appeal Tribunal',
        filters: [
                    {
                      name: "judge",
                      label: "Name of judge",
                      type: "text",
                      predictive: true,
                      placeholder: "Show cases this judge heard only"
                    },
                    {
                      name: "party",
                      label: "Name of party",
                      type: "text",
                      predictive: true,
                      placeholder: "Show cases brought by this party"
                    },
                    {
                      name: "category",
                      label: "Topic",
                      type: "text",
                      predictive: true,
                      placeholder: "What the case is about"
                    },
                    {
                      name: "subcategory",
                      label: "Sub-topic",
                      type: "text",
                      predictive: true,
                      placeholder: "More detail about the case"
                    }
                  ],
          sort_by: [],
          results_columns: []
        }
    ])
  end

  namespace :convert do
    desc "Convert categories data to new format"
    task categories: :environment do
      {"ftt-tax" => FttCategory, "utaac" => AacCategory, "eat" => EatCategory}.each do |k,v|
        tribunal = Tribunal.find_by_code(k)
        tribunal.categories.delete_all
        v.find_each { |cat| tribunal.categories.create(name: cat.name) }
      end
    end

    namespace :ftt do
      desc "Convert decisions data to new format"
      task decisions: :environment do

        AllDecision.where(tribunal_id: ftt.id).destroy_all
        FttDecision.find_each do |decision|
          puts "Converting FTT decision  #{decision.file_number}"
          AllDecision.create(
                              tribunal_id: ftt.id,
                              claimant: decision.claimant,
                              respondent: decision.respondent,
                              # doc_file: decision.doc_file,
                              # pdf_file: decision.pdf_file,
                              text: decision.text,
                              html: decision.html,
                              search_text: decision.search_text,
                              slug: decision.slug,
                              hearing_date: decision.hearing_date,
                              decision_date: decision.decision_date,
                              publication_date: decision.publication_date,
                              file_number: decision.file_number,
                              other_metadata: {  file_no_1: decision.file_no_1,
                                                  file_no_2: decision.file_no_2
                                                },
                              created_at: decision.created_at,
                              updated_at: decision.updated_at
                            )
        end
      end      
    end

    desc "Convert decisions data to new format"
    task eat: :environment do

      eat = Tribunal.find_by_code "eat"
      AllDecision.where(tribunal_id: eat.id).destroy_all
      EatDecision.find_each do |decision|
        puts "Converting EAT decision  #{decision.file_number}"
        AllDecision.create(
                            tribunal_id: eat.id,
                            claimant: decision.claimant,
                            respondent: decision.respondent,
                            # doc_file: decision.doc_file,
                            # pdf_file: decision.pdf_file,
                            text: decision.text,
                            html: decision.html,
                            search_text: decision.search_text,
                            slug: decision.slug,
                            hearing_date: decision.hearing_date,
                            decision_date: decision.decision_date,
                            upload_date: decision.upload_date,
                            file_number: decision.file_number,
                            starred: decision.starred,                            
                            other_metadata: {  filename: decision.filename,
                                                uploaded_by: decision.uploaded_by
                                              },
                            created_at: decision.created_at,
                            updated_at: decision.updated_at
                          )
      end
    end

    task utaac: :environment do

      utaac = Tribunal.find_by_code "utaac"
      AllDecision.where(tribunal_id: utaac.id).destroy_all
      AacDecision.find_each do |decision|
        puts "Converting UTAAC decision  #{decision.file_number}"
        AllDecision.create(
                            tribunal_id: utaac.id,
                            claimant: decision.claimant,
                            respondent: decision.respondent,
                            # doc_file: decision.doc_file,
                            # pdf_file: decision.pdf_file,
                            text: decision.text,
                            html: decision.html,
                            search_text: decision.search_text,
                            slug: decision.slug,
                            notes: decision.notes,
                            hearing_date: decision.hearing_date,
                            decision_date: decision.decision_date,
                            publication_date: decision.publication_date,
                            file_number: decision.file_number,
                            neutral_citation_number: decision.ncn,
                            reported_number: decision.reported_number,
                            published: decision.is_published,
                            other_metadata: {  file_no_1: decision.file_no_1,
                                                file_no_2: decision.file_no_2,
                                                file_no_3: decision.file_no_3,
                                                ncn_citation: decision.ncn_citation, 
                                                ncn_code1: decision.ncn_code1, 
                                                ncn_code2: decision.ncn_code2, 
                                                ncn_year: decision.ncn_year, 
                                                reported_no_1: decision.reported_no_1, 
                                                reported_no_2: decision.reported_no_2, 
                                                reported_no_3: decision.reported_no_3,
                                                keywords: decision.keywords
                                              },
                            created_at: decision.created_at,
                            updated_at: decision.updated_at
                          )
      end
    end



  end


end




