require 'doc_processor'

class FttDecision < ActiveRecord::Base
  include DecisionSearch

  before_save :update_search_text

  has_many :ftt_subcategories_decisions
  has_many :ftt_subcategories, through: :ftt_subcategories_decisions
  has_many :ftt_judgments
  has_many :ftt_judges, through: :ftt_judgments

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    if !file_number.blank?
      file_number
    else
      "decision-#{id}"
    end
  end

  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader

  def self.ordered
    order("decision_date DESC")
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
      joins(:ftt_judges).where("? = ftt_judges.name", judge_name)
    else
      where("")
    end
  end

  def self.by_subcategory(subcategory_name)
    if subcategory_name.present?
      joins(:ftt_subcategories).where(ftt_subcategories: {name: subcategory_name})
    else
      where("")
    end
  end

  def self.by_category(category_name)
    if category_name.present?
      #TODO: Refactor to avoid the find_by_name lookup
      joins(:ftt_subcategories).where(ftt_subcategories: {ftt_category_id: FttCategory.find_by_name(category_name).id})
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

  def self.ordered(order_by = "created_datetime")
    order("#{order_by} DESC")
  end

  def add_doc
    if doc = Dir.glob(File.join("#{Rails.root}/data/ftt/docs/j#{id}", "*.doc")).first
      DocProcessor.add_doc_file(self, File.open(doc))
    end
  end

  def add_single_doc path
    DocProcessor.add_doc_file(self, File.open(path))
  end

  def process_doc
    DocProcessor.process_doc_file(self, doc_file) if doc_file.present?
  end

  def set_html_from_text(cache={})
    if self.text
      self.html = self.text.gsub(/\n/, '<br/>')
      #TODO: check if citation pattern for FTT has same formatting requirement as IAT
    end
  end

  def subcategory_names
    ftt_subcategories.pluck(:name).join(' ')
  end

  def category_names
    ftt_subcategories.map(&:ftt_category).map(&:name).join(' ')
  end

  def judge_names
    ftt_judges.pluck(:name).join(', ')
  end

  def update_search_text
    self.search_text = [subcategory_names, category_names, judge_names, file_number,
                        claimant, respondent, notes, text]
                        .join(' ')

  end
end
