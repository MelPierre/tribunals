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

    desc "Convert All"
    task all: [:categories, :judges, :ftt, :utaac, :eat] do
      puts "Finished"
    end

    desc "Convert categories data to new format"
    task categories: :environment do
      Subcategory.delete_all
      Category.delete_all
      
      {"ftt-tax" => FttCategory, "utaac" => AacCategory, "eat" => EatCategory}.each do |k,v|
        tribunal = Tribunal.find_by_code(k)
        v.find_each { |cat| 
          new_cat = tribunal.categories.create(name: cat.name, legacy_id: cat.id)
          cat_key = case k
            when 'ftt-tax' then 'ftt'
            when 'utaac' then 'aac'
            else k
          end
          cat.send("#{cat_key}_subcategories").each do |subcat|
            puts "Adding sub category #{subcat.name} to #{new_cat.name}"
            new_cat.subcategories.create(name: subcat.name, legacy_id: subcat.id)
          end 
        }
      end
    end

    desc "Convert judges data to new format"
    task judges: :environment do
      AllJudge.delete_all
      {"ftt-tax" => FttJudge, "utaac" => Judge}.each do |k,v|
        tribunal = Tribunal.find_by_code(k)
        v.find_each { |judge| 
          puts "Converting #{k} judge  #{judge.name}"

          tribunal.all_judges.create(name: judge.name, legacy_id: judge.id, 
                                     created_at: judge.created_at, updated_at: judge.updated_at)
        }
      end
    end

    desc "Convert decisions data to new format"
    task ftt: :environment do

      ftt = Tribunal.find_by_code "ftt-tax"
      ftt.all_decisions.delete_all

      FttDecision.find_each do |decision|
        puts "Converting FTT decision  #{decision.file_number}"
        new_decision = AllDecision.create!(
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
        decision.ftt_subcategories.each do |subcat|
          new_cat = ftt.categories.find_by_legacy_id(subcat.ftt_category.id)
          new_subcat = new_cat.subcategories.find_by_legacy_id(subcat.id)
          puts "Matched #{new_cat.name} to #{subcat.ftt_category.name}"
          puts "Matched #{new_subcat.name} to #{subcat.name}"
          new_decision.category_decisions.create!(category: new_cat, subcategory: new_subcat)
          puts "Applied category to #{new_decision.file_number}"
        end

        decision.ftt_judges.each do |judge|
          new_judge = ftt.all_judges.find_by_legacy_id(judge.id)
          puts "Adding judge #{judge.name} to #{new_decision.file_number}"          
          new_decision.all_judges << new_judge
        end
      end
    end      

    desc "Convert decisions data to new format"
    task eat: :environment do

      eat = Tribunal.find_by_code "eat"
      eat.all_decisions.delete_all
      EatDecision.find_each do |decision|
        puts "Converting EAT decision  #{decision.file_number}"
        new_decision = AllDecision.create!(
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
        decision.eat_subcategories.each do |subcat|
          new_cat = eat.categories.find_by_legacy_id(subcat.eat_category.id)
          new_subcat = new_cat.subcategories.find_by_legacy_id(subcat.id)
          puts "Matched #{new_cat.name} to #{subcat.eat_category.name}"
          puts "Matched #{new_subcat.name} to #{subcat.name}"
          new_decision.category_decisions.create!(category: new_cat, subcategory: new_subcat)
          puts "Applied category to #{new_decision.file_number}"
        end
        puts "Mapping judge #{decision.judges}"
        eat.all_judges.where(name: decision.judges).first_or_initialize.save!
      end
    end

    task utaac: :environment do

      utaac = Tribunal.find_by_code "utaac"
      utaac.all_decisions.delete_all
      AacDecision.find_each do |decision|
        puts "Converting UTAAC decision  #{decision.file_number}"
        new_decision = AllDecision.create!(
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

        decision.aac_subcategories.each do |subcat|
          new_cat = utaac.categories.find_by_legacy_id(subcat.aac_category.id)
          new_subcat = new_cat.subcategories.find_by_legacy_id(subcat.id)
          puts "Matched #{new_cat.name} to #{subcat.aac_category.name}"
          puts "Matched #{new_subcat.name} to #{subcat.name}"
          new_decision.category_decisions.create!(category: new_cat, subcategory: new_subcat)
          puts "Applied category to #{new_decision.file_number}"
        end

        decision.judges.each do |judge|
          new_judge = utaac.all_judges.find_by_legacy_id(judge.id)
          puts "Adding judge #{judge.name} to #{new_decision.file_number}"          
          new_decision.all_judges << new_judge
        end

      end
    end
  end
end
