class AllDecision < ActiveRecord::Base
  include Decisions
  has_many :category_decisions
  has_many :subcategories, through: :category_decisions
  has_many :categories, through: :category_decisions
  has_and_belongs_to_many :all_judges, join_table: :decisions_judges
  belongs_to :tribunal

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


  scope :ftt, ->{ where(tribunal_id: Tribunal.find_by_code("ftt-tax").try(:id)) }
  scope :utaac, ->{ where(tribunal_id: Tribunal.find_by_code("utaac").try(:id)) }
  scope :eat, ->{ where(tribunal_id: Tribunal.find_by_code("eat").try(:id)) }
  scope :viewable, ->{ t = self.arel_table; where(t[:reported].eq(true).or(t[:promulgation_date].gteq(Date.new(2013, 6, 1)))) }
  scope :reported, ->{ where(reported: true) }
  scope :ordered, ->{ order("decision_date DESC") }
end
