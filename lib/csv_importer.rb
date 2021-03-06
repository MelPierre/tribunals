require 'csv'
# Used for #{@tribunal.code}, uses some but not all of the CSV data, expects the following CSV headings

# judgements.csv
# judges, judgment_id,tribunal,chamber,chamber_group,hearing_datetime,decision_datetime,created_datetime,publication_datetime,last_updatedtime,
# file_no,file_no_1,file_no_2,file_no_3,reported_no,reported_no_1,reported_no_2,reported_no_3,neutral_citation_number,ncn_year,ncn_code1,
# ncn_citation,ncn_code2,claimant,respondent,notes,is_published,subcategory_id,sec_subcategory_id,keywords,decision_type

# judges.csv
# id,prefix,surname,suffix

# categories.csv
# id,description

# subcategories.csv
# id,category_id,num,description,category_name

# judges_judgements_map.csv (judgement id is decision.legacy_id and commissioner_id is all_judge.legacy_id)
# judgment_id,commissioner_id

# judgment_jurisdictions.csv
# eat_decision_id,eat_subcategory_id,eat_category_id,


class CSVImporter
  def initialize(directory, code, logger=Rails.logger)
    @directory = directory
    @logger = logger
    @tribunal = Tribunal.send(code)
  end

  def each_row(fn, &block)
    CSV.foreach(filename(fn), headers: :first_row, &block)
  end

  def filename(fn)
    File.join(@directory, fn)
  end

  def import_decisions
    puts "Processing #{@tribunal.code} decisions"
    each_row('judgements.csv') {|row| update_decision(row) }
    puts "\nComplete!"
  end

  def import_categories
    puts "Processing #{@tribunal.code} categories"
    each_row('categories.csv') {|row| update_category(row) }
    puts "\nComplete!"
  end

  def import_subcategories
    puts "Processing #{@tribunal.code} subcategories"
    each_row('subcategories.csv') {|row| update_subcategory(row) }
    puts "\nComplete!"
  end

  def import_eat_subcategories
    puts "Processing #{@tribunal.code} subcategories"
    each_row('level2jury.csv') {|row| update_subcategory(row) }
    puts "\nComplete!"
  end

  def import_judges
    puts "Processing #{@tribunal.code} Judges"
    each_row('judges.csv') {|row| update_judge(row) }
    puts "\nComplete!"
  end

  def map_categories_to_decisions
    puts "Processing #{@tribunal.code} sub-categories to decisions"
    each_row('judgment_jurisdictions.csv') {|row| update_subcategory(row) }
    puts "\nComplete!"
  end

  def update_decisions_judges
    each_row('judges_judgements_map.csv') { |row| update_decision_judge(row) }
  end

  def compute_ncn(row)
    "[#{row['ncn_year']}] #{row['ncn_code1']} #{row['ncn_citation']}"
  end

  def eat_categories_to_decisions(row)
    puts "\n\n\n\nRow: #{row}\n\n\n"
    decision = @tribunal.all_decisions.legacy_id(row['eat_decision_id']).first_or_initialize

    if row.has_key?('eat_category_id') &&  row.fetch('eat_category_id').present?
      category = Category.where(legacy_id: row.fetch('eat_category_id')).first_or_initialize
      decision.categories.push(category)
    end

    if row.has_key?('eat_subcategory_id') &&  row.fetch('eat_subcategory_id').present?
      sub_category = Subcategory.where(legacy_id: row.fetch('eat_subcategory_id')).first_or_initialize
      decision.subcategories.push(sub_category)
    end
    decision.save!
    decision
  end

  def update_decision(row)
    decision = @tribunal.all_decisions.legacy_id(row['judgment_id']).first_or_initialize

    keywords = row.inject([]) do |acc, (k, v)|
      acc << v if /keyword/ =~ k && v.present?
      acc
    end

    if @tribunal.code == 'eat' && row.has_key?('file_no_1') && row['file_no_1'].present?
      row['file_no_1'],row['file_no_2'],row['file_no_3'] =
      split_file_no(row['file_no_1'])
    end
    # map meta information
    meta = {
      legacy_id: row['judgment_id'],
      file_no_1: sanitize(row['file_no_1']),
      file_no_2: sanitize(row['file_no_2']),
      file_no_3: sanitize(row['file_no_3']),
      ncn_citation: row['ncn_citation'],
      ncn_code1: row['ncn_code1'],
      ncn_code2: row['ncn_code2'],
      ncn_year: row['ncn_year'],
      reported_no_1: row['reported_no_1'],
      reported_no_2: row['reported_no_2'],
      reported_no_3: row['reported_no_3'],
      keywords: keywords
    }

    # map attributes
    decision.attributes = {
      reported_number: row['reported_no'],
      claimant: row['claimant'],
      respondent: row['respondent'],
      notes: row['notes'],
      published: row['is_published'],
      other_metadata: meta,
      starred: (row['is_starred'] == '1'),
      country_guideline: (row['is_countryguide'] == '1')
    }

    # map dates
    decision.hearing_date      = read_date(row['hearing_datetime'],'%m/%d/%Y')      if row['hearing_datetime']
    decision.decision_date     = read_date(row['decision_datetime'],'%m/%d/%Y')     if row['decision_datetime']
    decision.created_at        = read_date(row['created_datetime'],'%m/%d/%Y')      if row['created_datetime']
    decision.publication_date  = read_date(row['publication_datetime'],'%m/%d/%Y')  if row['publication_datetime']
    decision.updated_at        = read_date(row['last_updatedtime'],'%m/%d/%Y')      if row['last_updatedtime']
    decision.promulgation_date = read_date(row['promulgated_datetime'],'%m/%d/%Y')  if row['promulgated_datetime']

    print decision.new_record? ? '+' : '.'
    decision.save

    # main main sub cat
    if row['subcategory_id'] && subcategory = @tribunal.subcategories.find_by_legacy_id(row['subcategory_id'])
      category = subcategory.category
      decision.category_decisions.where(category_id: category.id, subcategory_id: subcategory.id).first_or_initialize.save!
    end
    # map sec sub cat
    if row['sec_subcategory_id'] && subcategory = @tribunal.subcategories.find_by_legacy_id(row['sec_subcategory_id'])
      category = subcategory.category
      decision.category_decisions.where(category_id: category.id, subcategory_id: subcategory.id).first_or_initialize.save!
    end

    if row.has_key?('judges')
      judge = AllJudge.where(name: row.fetch('judges')).first_or_create
      if judge.present?
        decision.all_judges.push(judge)
      end
    end
    decision.save!
    decision
  end

  def update_category(row)
    c = @tribunal.categories.where(legacy_id: row['id']).first_or_initialize
    c.name = row['description']
    print c.new_record? ? '+' : '.'
    puts "Failed to import #{row['num']} - #{row['description']}" unless c.save
  end

  def update_subcategory(row)
    category, subcategory = nil

    if row.has_key?('category_id') && row.fetch('category_id').present?
      category = @tribunal.categories.where(legacy_id: row['category_id']).first_or_initialize
    end

    if row.has_key?('id') && row.fetch('id').present? && row.has_key?('description') && row.fetch('description').present?
      subcategory = category.subcategories.where(legacy_id: row['id']).first_or_initialize
      subcategory.name = row['description']
      print subcategory.new_record? ? '+' : '.'
      puts "Failed to import #{row['id']} - #{row['description']}" unless subcategory.save
    else
      puts "Could not find category with id #{row['id']}"
    end

    subcategory
  end

  def update_judge(row)
    row['judge_name'] = [row['prefix'], row['surname'], row['suffix']].compact.join(' ')

    j = @tribunal.all_judges.where(legacy_id: row['id']).first_or_initialize
    j.name = row['judge_name']
    print j.new_record? ? '+' : '.'
    puts "Failed to import #{row['id']} - #{row['judge_name']}" unless j.save
  end

  def update_decision_judge(row)
    judge = @tribunal.all_judges.find_by_legacy_id(row['commissioner_id'])
    decision = @tribunal.all_decisions.legacy_id(row['judgment_id']).first
    decision.all_judges << judge if decision && judge
    print '.'
  end

  def read_date(value, format=nil)
    return nil unless value
    format.nil? ? Date.parse(value.split(' ').first) : Date.strptime(value, format)
  end

  def sanitize(data)
    data.gsub(/\//, '').strip if data.present?
  end

  def split_file_no(file_number)
    file_number.split('/')
  end


end