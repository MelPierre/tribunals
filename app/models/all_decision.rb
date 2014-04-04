class AllDecision < ActiveRecord::Base
  has_many :category_decisions
  has_many :subcategories, through: :category_decisions
  has_many :categories, through: :category_decisions
  has_and_belongs_to_many :all_judges, join_table: :decisions_judges
  belongs_to :tribunal

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  before_save :set_neutral_citation_number
  before_save :set_file_number

  def slug_candidates
    if file_number.present?
      file_number
    else
      "decision-#{id}"
    end
  end

  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader


  scope :ftt, ->{ where(tribunal_id: Tribunal.ftt_tax.try(:id)) } 
  scope :utaac, ->{ where(tribunal_id: Tribunal.utaac.try(:id)) } 
  scope :eat, ->{ where(tribunal_id: Tribunal.eat.try(:id)) } 
  scope :viewable, ->{ t = self.arel_table; where(t[:reported].eq(true).or(t[:promulgation_date].gteq(Date.new(2013, 6, 1)))) }
  scope :reported, ->{ where(reported: true) }
  scope :legacy_id, ->(legacy_id) { where("other_metadata::json->>'legacy_id' = ?", legacy_id) }
  scope :ordered, ->(order_by = "created_at") { order("#{order_by} DESC") }


  protected
  
    def set_neutral_citation_number
      begin
        if neutral_citation_number.nil? || neutral_citation_number.blank?
          values = other_metadata.with_indifferent_access.slice('ncn_year', 'ncn_code1','ncn_citation').values
          values[0] = "[#{values[0]}]" if values[0]
          self.neutral_citation_number = values.compact.join(' ')
        end
      rescue Exception => ex

      end
    end

    def set_file_number
      begin
        self.file_number ||= other_metadata.with_indifferent_access.slice('file_no_1', 'file_no_2', 'file_no_3').values.compact.join('/')
        self.appeal_number = file_number if file_number =~ /\A[A-Z]{2}\/[0-9]{5}\/[0-9]{4}\Z/
      rescue Exception => ex

      end
    end

end