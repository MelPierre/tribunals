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

  def self.filtered(filter_hash)
    search(filter_hash[:query])
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

  def update_search_text
    self.search_text = [subcategory_names, category_names, judges, file_number, 
                        claimant, respondent, keywords, notes, text]
                        .join(' ')

  end
end
