require 'doc_processor'

class EatDecision < ActiveRecord::Base
  include DecisionSearch

  before_save :update_search_text

  has_many :eat_category_decisions
  has_many :eat_subcategories, through: :eat_category_decisions

  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader

  def self.ordered(order_by = "hearing_date")
    order("#{order_by} DESC")
  end

  def self.judges_list
    pluck(:judges).uniq.sort
  end

  def self.filtered(filter_hash)
    by_judge(filter_hash[:judge])
    .by_category(filter_hash[:category])
    .by_subcategory(filter_hash[:subcategory])
    .by_party(filter_hash[:party])
    .search(filter_hash[:query])
  end

  def self.by_judge(judge_name)
    if judge_name.present?
      where("? = judges", judge_name)
    else
      where("")
    end
  end

  def self.by_subcategory(subcategory_name)
    if subcategory_name.present?
      joins(:eat_subcategories).where(eat_subcategories: {name: subcategory_name})
    else
      where("")
    end
  end

  def self.by_category(category_name)
    if category_name.present?
      #TODO: Refactor to avoid the find_by_name lookup
      joins(:eat_subcategories).where(eat_subcategories: {eat_category_id: EatCategory.find_by_name(category_name).id})
    else
      where("")
    end
  end

  def self.by_party(party_name)
    if party_name.present?
      where("claimant ilike :q or respondent ilike :q ", q:"%#{party_name}%")
    else
      where("")
    end
  end

  def add_doc
    path = File.join("#{Rails.root}/data/eat/downloads/#{id}.doc")
    DocProcessor.add_doc_file(self, File.open(path)) if File.exists? path
  end

  def process_doc
    DocProcessor.process_doc_file(self, doc_file) if doc_file.present?
  end

  def set_html_from_text(cache={})
    if self.text
      self.html = self.text.gsub(/\n/, '<br/>')
      #TODO: check the citation pattern for EAT
    end
  end

  def subcategory_names
    eat_subcategories.pluck(:name).join(' ')
  end

  def category_names
    eat_subcategories.map(&:eat_category).map(&:name).join(' ')
  end

  def judge_names
    judges
  end

  def update_search_text
    self.search_text = [subcategory_names, category_names, judges, file_number, 
                        claimant, respondent, keywords, notes, text]
                        .join(' ')

  end
end
