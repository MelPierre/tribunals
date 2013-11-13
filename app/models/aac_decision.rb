class AacDecision < ActiveRecord::Base
  before_save :update_search_text

  has_many :aac_subcategories_decisions
  has_many :aac_subcategories, through: :aac_subcategories_decisions
  has_many :aac_judgements
  has_many :judges, through: :aac_judgements
  has_many :aac_import_errors

  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader

  def self.ordered
    order("created_datetime DESC")
  end

  def self.filtered(filter_hash)
    by_judge(filter_hash[:judge]).by_category(filter_hash[:category]).by_subcategory(filter_hash[:subcategory]).search(filter_hash[:query])
  end

  def self.search(query)
    if query.present?
      quoted_query = self.connection.quote(query)
      where("to_tsvector('english', search_text::text) @@ plainto_tsquery('english', :q::text)", q:query)
      .order("search_text ~* #{quoted_query} DESC")
    else
      where("")
    end
  end

  def self.by_judge(judge_name)
    if judge_name.present?
      joins(:judges).where("? = judges.name", judge_name)
    else
      where("")
    end
  end

  def self.by_subcategory(subcategory_name)
    if subcategory_name.present?
      joins(:aac_subcategories).where(aac_subcategories: {name: subcategory_name})
    else
      where("")
    end
  end

  def self.by_category(category_name)
    if category_name.present?
      #TODO: Refactor to avoid the find_by_name lookup
      joins(:aac_subcategories).where(aac_subcategories: {aac_category_id: AacCategory.find_by_name(category_name).id})
    else
      where("")
    end
  end

  def add_doc_file
    if doc = File.open(Dir.glob(File.join("#{Rails.root}/data/aac/docs/j#{id}", "*")).first)
      self.doc_file = doc
      self.doc_file.store!
      self.save!
    end
  rescue StandardError => e
    self.aac_import_errors.create!(:error => e.message, :backtrace => e.backtrace.to_s)
  end

  def process_doc
    if doc_file.present?
      Dir.mktmpdir do |tmp_html_dir|
        Dir.chdir(tmp_html_dir) do
          doc_rel_filename = File.basename(self.doc_file.file.path)
          doc_abs_filename = File.join(tmp_html_dir, doc_rel_filename)
          File.open(doc_abs_filename, 'wb') { |f| f.write(doc_file.sanitized_file.read) }
          [:pdf, "txt:text"].map do |type|
            system("soffice --headless --convert-to #{type} --outdir . '#{doc_rel_filename}'")
          end
          txt_filename = doc_abs_filename.gsub(/\.doc$/i, '.txt')
          pdf_filename = doc_abs_filename.gsub(/\.doc$/i, '.pdf')
          self.text = File.open(txt_filename, 'r:bom|utf-8').read
          self.set_html_from_text
          self.pdf_file = File.open(pdf_filename)
          self.save!
        end
      end
    end
  rescue StandardError => e
    puts e
    self.aac_import_errors.create!(:error => e.message, :backtrace => e.backtrace.to_s)
  end

  def set_html_from_text(cache={})
    if self.text
      self.html = self.text.gsub(/\n/, '<br/>')  
      #TODO: check if citation pattern for AAC has same formatting requirement as IAT
    end
  end

  def subcategory_names
    aac_subcategories.pluck(:name)
  end

  def category_names
    aac_subcategories.map(&:aac_category).map(&:name)
  end

  def judge_names
    judges.pluck(:name)
  end

  def update_search_text
    self.search_text = [subcategory_names, category_names, judge_names, ncn, ncn_year, ncn_code1, ncn_citation, ncn_code2, file_number, file_no_1, file_no_2, 
                        file_no_3, reported_number, claimant, respondent, keywords, notes, text]
                        .join(' ')

  end
end

