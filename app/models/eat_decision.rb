require 'doc_processor'

class EatDecision < ActiveRecord::Base
  has_many :eat_category_decisions
  has_many :eat_subcategories, through: :eat_category_decisions

  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader

  def self.ordered
    order("hearing_date DESC")
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

end
