require 'csv'

class CSVImporter
  def initialize(directory, code, logger=Rails.logger)
    @directory = directory
    @logger = logger
    @tribunal = Tribunal.find_by_code(code)
  end
  
  def each_row(fn, &block)
    CSV.foreach(filename(fn), headers: :first_row, &block)
  end
  
  def filename(fn)
    File.join(@directory, fn)
  end

  def import_decisions
    puts "Processing AAC decisions"   
    each_row('judgements.csv') {|row| update_decision(row) }
    puts "\nComplete!"
  end

  def import_categories
    puts "Processing AAC categories"
    each_row('categories.csv') {|row| update_category(row) }
    puts "\nComplete!"
  end

  def import_subcategories
    puts "Processing AAC subcategories"
    each_row('subcategories.csv') {|row| update_subcategory(row) }
    puts "\nComplete!"
  end

  def import_judges
    puts "Processing AAC Judges"
    each_row('judges.csv') {|row| update_judge(row) }
    puts "\nComplete!"
  end

  def update_decisions_judges  
    each_row('judges_judgements_map.csv') { |row| update_decision_judge(row) }  
  end

  def compute_ncn(row)
    "[#{row['ncn_year']}] #{row['ncn_code']} #{row['ncn_citation']}"
  end

  def update_judgment(decision, row)
    decision.promulgated_on = read_date(row['promulgated_datetime'])
    decision.hearing_on = read_date(row['hearing_datetime'])
    decision.created_at = Time.parse(row['created_datetime'])
    decision.updated_at = Time.parse(row['last_updatetime'])
    if (published_on = read_date(row['published_datetime'])).present?
      decision.published_on = published_on
    end

    appeal_number = [row['file_no_1'], row['file_no_2'], row['file_no_3']].join('/')
    if /\A[A-Z]{2}\/[0-9]{5}\/[0-9]{4}\Z/ =~ appeal_number
      decision.appeal_number = appeal_number
    end

    decision.starred = row['is_starred'] == '1'
    decision.country_guideline = row['is_countryguide'] == '1'

    decision.claimant = row['claimant']
    decision.keywords = row.inject([]) do |acc, (k, v)|
      acc << v if /keyword/ =~ k && v.present?
      acc
    end
    decision.case_notes = row['case_notes']
    decision.judges = judges_for(row['id'])

    pp decision.id, decision.changes

    if !decision.valid? && decision.errors.keys == [:doc_file] || decision.errors.keys == [:judges]
      decision.save!(validate: false)
      return
    end

    decision.save!
  end

  def create_judgment(row)
    puts "No new judgments should be created, skipping."
  end

  def update_decision(row)
    d = @tribunal.all_decisions.where('doc_file = ? or neutral_citation_number = ?', row['Doc_name'], compute_ncn(row)).first_or_initialize

    # new_decision = AllDecision.create!(
    #     # doc_file: decision.doc_file,
    #     # pdf_file: decision.pdf_file,
    #     text: decision.text,
    #     html: decision.html,
    #     search_text: decision.search_text,
    #   )
    
    # map meta information
    meta = {
      file_no_1: row['file_no_1'],
      file_no_2: row['file_no_2'],
      file_no_3: row['file_no_3'],
      ncn_citation: row['ncn_citation'],
      ncn_code1: row['ncn_code1'],
      ncn_code2: row['ncn_code2'],
      ncn_year: row['ncn_year'],
      reported_no_1: row['reported_no_1'],
      reported_no_2: row['reported_no_2'],
      reported_no_3: row['reported_no_3'],
      keywords: row['keywords']
    }
    # map attributes
    d.attributes = {
      file_number: row['file_number'],
      reported_number: row['reported_number'],
      neutral_citation_number: compute_ncn(row),
      claimant: row['claimants'],
      respondent: row['respondent'],
      notes: row['notes'],
      published: row['is_published'],
    }

    # main main sub cat
    if row['main_subcategory_id'] && subcategory = @tribunal.subcategories.find_by_legacy_id(row['main_subcategory_id'])
      category = subcategory.category
      d.category_decisions.where(category: category, subcategory: subcategory).first_or_initialize
    end
    # map sec sub cat
    if row['sec_subcategory_id'] && subcategory = @tribunal.subcategories.find_by_legacy_id(row['sec_subcategory_id'])
      category = subcategory.category
      d.category_decisions.where(category: category, subcategory: subcategory).first_or_initialize
    end

    # map dates
    d.hearing_date     = read_date(row['hearing_datetime'],'%d/%m/%Y')      if row['hearing_datetime']
    d.decision_date    = read_date(row['decision_datetime'],'%d/%m/%Y')     if row['decision_datetime']
    d.created_at       = read_date(row['created_datetime'],'%d/%m/%Y')      if row['created_datetime']
    d.publication_date = read_date(row['publication_datetime'],'%d/%m/%Y')  if row['publication_datetime']
    d.updated_at       = read_date(row['last_updatedtime'],'%d/%m/%Y')      if row['last_updatedtime']

    print d.new_record? ? '+' : '.'
    d.save

  end

  def update_category(row)
    c = @tribunal.categories.where(legacy_id: row['num']).first_or_initialize
    c.name = row['description']
    print c.new_record? ? '+' : '.'
    puts "Failed to import #{row['num']} - #{row['description']}" unless c.save
  end

  def update_subcategory(row)
    if c = @tribunal.categories.find_by_legacy_id(row['parent_num'])
      sc = c.subcategories.where(legacy_id: row['id']).first_or_initialize
      sc.name = row['description']
      print sc.new_record? ? '+' : '.'
      puts "Failed to import #{row['id']} - #{row['description']}" unless sc.save
    else
      puts "Could not find category with id #{row['id']}"
    end
  end

  def update_judge(row)
    row['judge_name'] = [row['prefix'], row['surname'], row['suffix']].compact.join(' ')

    j = @tribunal.all_judges.where(legacy_id: row['id']).first_or_initialize
    j.name = row['judge_name']
    print j.new_record? ? '+' : '.'
    puts "Failed to import #{row['id']} - #{row['judge_name']}" unless j.save    
  end    

  def update_decision_judge(row)
    judge = @tribunal.judges.find(row['commissioner_id'])
    decision = @tribunal.all_decisions.find(row['judgement_id'])
    decision.all_judges << judge
    print '.'
  end

  def read_date(value, format=nil)
    return nil unless value
    format.nil? ? Date.parse(value.split(' ').first) : Date.strptime(value, format)
  end

end